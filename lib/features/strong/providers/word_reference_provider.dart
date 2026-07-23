
import 'package:cpy_app/constants/globals.dart';
import 'package:cpy_app/features/strong/providers/word_reference_services.dart';
import 'package:flutter/material.dart';
import '../data/model/word_reference.dart';

class WordReferenceProvider extends ChangeNotifier {

  final WordReferenceServices?  wordReferenceServices;
  WordReferenceProvider({this.wordReferenceServices});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<WordReference>? _words;
  List<WordReference>? get words => _words;

  List<WordReference>? _localWords;
  List<WordReference>? get localWords => _localWords;

  WordReference? _word;
  WordReference? get word => _word;

  String _message = '';
  String get message => _message;


  void removeListWord({required int index}){
    _words!.removeAt(index);
    notifyListeners();
  }



  Future<void> getWords({required BuildContext context}) async {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLoading(true);
    });

    _resetError();

    try {
      final response = await wordReferenceServices!.getWords();

      if (response.error == null) {

        _words = response.data
          ?..sort((a, b) => a.word.toLowerCase().compareTo(b.word.toLowerCase())); // ✅ added

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


  Future<void> getLocalWords({required BuildContext context}) async {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLoading(true);
    });

    _resetError();

    final response = await databaseService.getAllWords();

    if (response != null) {

      _localWords = response
        ..sort((a, b) => a.word.toLowerCase().compareTo(b.word.toLowerCase())); // ✅ added

    } else {
      _error = "An error occurred";
      logger.i(_error);
    }

    _setLoading(false);

    logger.i(isLoading);
  }


  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _resetError() {
    _error = null;
  }

  void resetState() {
    _words = null;
    _word = null;
    _localWords = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }


}
