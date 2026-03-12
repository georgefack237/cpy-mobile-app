import 'package:cpy_app/constants/globals.dart';
import 'package:cpy_app/features/media/data/models/media_file.dart';
import 'package:cpy_app/features/media/data/network/media_file_services.dart';
import 'package:flutter/material.dart';


class MediaFilesProvider extends ChangeNotifier {

  final MediaFileServices?  mediaFileServices;

  MediaFilesProvider({this.mediaFileServices});

  bool _isLoading = false;
  bool get isLoading => _isLoading;



  bool _loadingLocal = false;
  bool get loadingLocal => _loadingLocal;

  String? _error;
  String? get error => _error;

  List<MediaFile>? _files;
  List<MediaFile>? get files => _files;


  List<MediaFile>? _localFiles;
  List<MediaFile>? get localFiles => _localFiles;



  Future<void> getLocalMediaFiles({required BuildContext context}) async {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLoadingLocal(true);
    });

    _resetError();

    final response = await databaseService.getAllFiles();

    if (response != null) {

      _localFiles = response;

    } else {
      _error = "An error occurred";
      logger.i(_error);
    }

    _setLoadingLocal(false);

    logger.i(isLoading);

  }



  Future<void> getMediaFiles() async {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLoading(true);
    });

    _resetError();

    try {
      final response = await mediaFileServices!.getMediaFiles();
      if (response.error == null) {

        _files = response.data;
        logger.i(_files);

      } else {
        if(response.error!.isEmpty){
          _error = "No internet connection";

        }else{
          _error = response.error;
        }
      }
    } catch (e) {
      _error = "Unexpected error: $e";

    }
    _setLoading(false);
  }


  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }


  void _setLoadingLocal(bool value) {
    _loadingLocal = value;
    notifyListeners();
  }


  void _resetError() {
    _error = null;
  }

  void resetState() {
    _error = null;
    _isLoading = false;
    _loadingLocal = false;
    notifyListeners();
  }


}
