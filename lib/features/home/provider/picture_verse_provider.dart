
import 'package:cpy_app/constants/globals.dart';
import 'package:cpy_app/data/models/affiche.dart';
import 'package:cpy_app/features/home/provider/picture_verse_services.dart';
import 'package:flutter/material.dart';

class PictureVerseProvider extends ChangeNotifier {

  final PictureVerseServices?  pictureVerseServices;
  PictureVerseProvider({this.pictureVerseServices});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<PictureVerse>? _verses;
  List<PictureVerse>? get verses => _verses;

  List<PictureVerse>? _localVerses;
  List<PictureVerse>? get localVerses => _localVerses;

  String _message = '';
  String get message => _message;


  Future<void> getLocalVerses({required BuildContext context}) async {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLoading(true);
    });

    _resetError();

    final response = await databaseService.getAllVerses();

    if (response != null) {

      _localVerses = response;

    } else {
      _error = "An error occurred";
      logger.i(_error);
    }

    _setLoading(false);

    logger.i(isLoading);

  }


  Future<void> getVerses({required BuildContext context}) async {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLoading(true);
    });

    _resetError();

    try {
      final response = await pictureVerseServices!.getPictureVerses();

      if (response.error == null) {

        _verses = response.data;
        logger.i(_verses);


      } else {
        if(response.error!.isEmpty){
          _error = "No internet connection";

        }else{
          _error = response.error;
          logger.i(_error);

        }
      }
    } catch (e) {
      _error = "Unexpected error: $e";
      logger.i(e.toString());

    }

    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _resetError() {
    _error = null;
  }

  void resetState() {
    _verses = null;
    _localVerses = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }


}
