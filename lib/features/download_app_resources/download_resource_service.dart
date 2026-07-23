import 'dart:convert';
import 'dart:io';

import 'package:cpy_app/features/strong/data/model/word_reference.dart';
import 'package:cpy_app/profile/providers/profile_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as En;

import '../../../constants/globals.dart';
import '../../../core/notifications/fcm_tokens.dart';
import '../../../data/models/hymn_book_collection.dart';
import '../../../data/models/hymn_song.dart';
import '../../../data/models/poem_model.dart';
import '../../../utils/globals.dart';

/// Explicit stages of the import pipeline — the UI renders a different
/// status line per phase instead of one static "downloading..." message
/// regardless of what's actually happening.
enum ImportPhase {
  idle,
  downloading,
  extracting,
  processingBooks,
  processingWords,
  creatingProfile,
  completed,
  failed,
}

/// Owns the whole "download resources -> extract -> parse JSON -> create
/// device profile" pipeline that used to live inside
/// _DownloadResourcesPageState. No BuildContext, no Navigator calls —
/// purely data + side effects, so the page just reacts to `phase`.
class AppResourceImportService extends ChangeNotifier {
  ImportPhase phase = ImportPhase.idle;
  double downloadProgress = 0.0;
  String statusMessage = '';
  String? errorMessage;
  String? _lastZipUrl;

  bool get isBusy =>
      phase != ImportPhase.idle && phase != ImportPhase.completed && phase != ImportPhase.failed;

  void _emit({ImportPhase? phase, double? progress, String? message, String? error}) {
    if (phase != null) this.phase = phase;
    if (progress != null) downloadProgress = progress;
    if (message != null) statusMessage = message;
    errorMessage = error;
    notifyListeners();
  }

  Future<String> _downloadDirectory() async {
    Directory? directory =
    Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
    return "${directory!.path}/resources/books";
  }

  /// Kicks off the whole pipeline. Safe to call again after a failure —
  /// it just starts over from the download step.
  Future<void> run({required String zipUrl, required ProfileProvider profileProvider}) async {
    _lastZipUrl = zipUrl;
    try {
      _emit(phase: ImportPhase.downloading, progress: 0, message: "Téléchargement des données…", error: null);
      await _download(zipUrl);

      _emit(phase: ImportPhase.extracting, message: "Extraction des fichiers…");
      await _extractZip();

      _emit(phase: ImportPhase.processingBooks, message: "Importation des cantiques et poèmes…");
      await _processJsonFiles();

      _emit(phase: ImportPhase.processingWords, message: "Importation du lexique…");
      await _processWordsFiles();

      _emit(phase: ImportPhase.creatingProfile, message: "Finalisation…");
      await _createProfile(profileProvider);

      _emit(phase: ImportPhase.completed, message: "Terminé");
    } catch (e, stackTrace) {
      logger.e('Resource import failed', error: e, stackTrace: stackTrace);
      _emit(phase: ImportPhase.failed, message: "Une erreur est survenue.", error: e.toString());
    }
  }

  /// Re-runs the pipeline from the start using the last URL passed to `run`.
  Future<void> retry({required ProfileProvider profileProvider}) async {
    if (_lastZipUrl == null) return;
    await run(zipUrl: _lastZipUrl!, profileProvider: profileProvider);
  }

  void reset() {
    phase = ImportPhase.idle;
    downloadProgress = 0;
    statusMessage = '';
    errorMessage = null;
    notifyListeners();
  }

  // ── Download ──────────────────────────────────────────────────────

  Future<void> _download(String url) async {
    final dio = Dio();
    final directoryPath = await _downloadDirectory();
    final directory = Directory(directoryPath);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    final savePath = "$directoryPath/books.zip";

    await dio.download(
      url,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          _emit(progress: received / total);
        }
      },
    );
  }

  // ── Extraction ────────────────────────────────────────────────────

  Future<void> _extractZip() async {
    final directoryPath = await _downloadDirectory();
    final directory = Directory(directoryPath);

    if (!directory.existsSync()) {
      throw Exception('Download directory does not exist');
    }

    final zipFile = File("${directory.path}/books.zip");
    if (!zipFile.existsSync()) {
      logger.i('No books.zip file found');
      return;
    }

    // flutter_archive throws UNZIP_ERROR if a destination file already
    // exists (no overwrite flag). Clear previous extraction artifacts so
    // re-downloads always work cleanly. The zip itself is kept until
    // extraction succeeds.
    for (final entity in directory.listSync(recursive: false)) {
      if (entity.path == zipFile.path) continue;
      if (entity is File) {
        await entity.delete();
      } else if (entity is Directory) {
        await entity.delete(recursive: true);
      }
    }

    await ZipFile.extractToDirectory(
      zipFile: zipFile,
      destinationDir: Directory("${directory.path}/"),
    );

    await zipFile.delete();
  }

  // ── JSON processing ───────────────────────────────────────────────

  Future<void> _processJsonFiles() async {
    final directoryPath = await _downloadDirectory();
    final directory = Directory(directoryPath);

    final jsonFiles = directory
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('books.json'))
        .toList();

    for (final file in jsonFiles) {
      await _processSingleJsonFile(file);
    }
  }

  Future<void> _processWordsFiles() async {
    final directoryPath = await _downloadDirectory();
    final directory = Directory(directoryPath);

    final jsonFiles = directory
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('words.json'))
        .toList();

    for (final file in jsonFiles) {
      await _processSingleWordFile(file);
    }
  }

  Future<void> _processSingleJsonFile(File file) async {
    _emit(message: "Traitement de ${file.path.split('/').last}");

    final data = jsonDecode(await file.readAsString());
    if (data is! List) {
      logger.w('Invalid JSON structure in ${file.path}: expected List but got ${data.runtimeType}');
      return;
    }

    for (final book in data) {
      await _processBook(book as Map<String, dynamic>);
    }
  }

  Future<void> _processSingleWordFile(File file) async {
    _emit(message: "Traitement de ${file.path.split('/').last}");

    final data = jsonDecode(await file.readAsString());
    if (data is! List) {
      logger.w('Invalid JSON structure in ${file.path}: expected List but got ${data.runtimeType}');
      return;
    }

    for (final word in data) {
      await databaseService.insertWord(WordReference.fromJson(word));
    }
  }

  Future<void> _processBook(Map<String, dynamic> bookJson) async {
    final hymnBook = HymnBookCollection.fromJson(bookJson);
    await databaseService.insertHymnBook(hymnBook);

    for (final hymnJson in (bookJson['hymns'] as List? ?? [])) {
      await databaseService.insertHymnSong(HymnSong.fromJson(hymnJson));
    }

    for (final poemJson in (bookJson['poems'] as List? ?? [])) {
      await databaseService.insertHymnPoem(PoemModel.fromJson(poemJson));
    }

    logger.i(
        'Processed book: ${hymnBook.nameFr} with ${(bookJson['hymns'] as List? ?? []).length} hymns and ${(bookJson['poems'] as List? ?? []).length} poems');
  }

  // ── Device fingerprint / profile ─────────────────────────────────

  Future<void> _createProfile(ProfileProvider provider) async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    // Skip getFcmToken on iOS — APNs token may not be ready this early,
    // causing a firebase_messaging/apns-token-not-set crash.
    final fcmKey = Platform.isAndroid ? (await getFcmToken() ?? '') : '';

    saveShowIntro(false);
    await showIntroScreenFunc();

    const encryptionKey = "A9fP3nX7LGP2NdQ4";
    String rawFingerprint;

    if (Platform.isAndroid) {
      final deviceInfo = await deviceInfoPlugin.androidInfo;
      rawFingerprint = deviceInfo.data['fingerprint']?.toString() ?? deviceInfo.id;
    } else {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      rawFingerprint = iosInfo.identifierForVendor ?? iosInfo.name;
    }

    final En.Encrypted encrypted = helperFunctions.encrypt(encryptionKey, rawFingerprint);
    await provider.addProfile(deviceId: encrypted.base64, notificationId: fcmKey);
  }
}