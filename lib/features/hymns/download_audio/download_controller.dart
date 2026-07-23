import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'download_permissions.dart';
import 'hymn_download_service.dart';

/// Owns download progress / downloaded-file state for a single hymn's
/// audio. Replaces the _progress / _isDownloading / _downloadedFiles
/// fields + setState calls that used to live directly in
/// HymnSongDetailsPage.
class HymnAudioDownloadController extends ChangeNotifier {
  HymnAudioDownloadController({
    required this.audioUrl,
    HymnAudioDownloadService? service,
    HymnDownloadPermissionHandler? permissionHandler,
  })  : _service = service ?? HymnAudioDownloadService(),
        _permissionHandler = permissionHandler ?? HymnDownloadPermissionHandler();

  final String audioUrl;
  final HymnAudioDownloadService _service;
  final HymnDownloadPermissionHandler _permissionHandler;

  double progress = 0.0;
  bool isDownloading = false;
  List<FileSystemEntity> downloadedFiles = [];

  bool get hasDownload => downloadedFiles.isNotEmpty;

  Future<void> loadDownloadedFiles() async {
    downloadedFiles = await _service.getDownloadedFiles(audioUrl);
    notifyListeners();
  }

  Future<void> download({required BuildContext context, required String url}) async {
    final hasPermission = await _permissionHandler.ensurePermission(context);
    if (!hasPermission) {
      if (kDebugMode) print("Permission denied!");
      return;
    }

    isDownloading = true;
    progress = 0.0;
    notifyListeners();

    try {
      await _service.download(
        url: url,
        audioUrl: audioUrl,
        onProgress: (p) {
          progress = p;
          notifyListeners();
        },
      );
      await loadDownloadedFiles();
    } catch (e) {
      if (kDebugMode) print("Download error: $e");
    } finally {
      isDownloading = false;
      notifyListeners();
    }
  }
}