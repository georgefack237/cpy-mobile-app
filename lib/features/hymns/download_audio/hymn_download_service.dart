import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

/// Pure IO/download logic for hymn audio — no BuildContext, no widgets.
/// Was previously inlined across three methods in HymnSongDetailsPage
/// (_getDownloadDirectory, downloadAudioFile, _loadDownloadedFiles).
class HymnAudioDownloadService {
  HymnAudioDownloadService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<String> getDownloadDirectory() async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    return "${directory!.path}/DownloadedAudios";
  }

  /// Any already-downloaded file matching [audioUrl]'s filename.
  Future<List<FileSystemEntity>> getDownloadedFiles(String audioUrl) async {
    final directoryPath = await getDownloadDirectory();
    final directory = Directory(directoryPath);
    if (!directory.existsSync()) return [];

    final fileName = audioUrl.split('/').last;
    return directory
        .listSync()
        .where((file) => file.path.split('/').last == fileName)
        .toList();
  }

  /// Downloads [url]; [audioUrl] is only used to derive the destination
  /// filename. Reports progress in [0.0, 1.0] via [onProgress].
  Future<File> download({
    required String url,
    required String audioUrl,
    required void Function(double progress) onProgress,
  }) async {
    final directoryPath = await getDownloadDirectory();
    final directory = Directory(directoryPath);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    final fileName = audioUrl.split('/').last;
    final savePath = "$directoryPath/$fileName";

    await _dio.download(
      url,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          onProgress(received / total);
        }
      },
    );

    return File(savePath);
  }
}