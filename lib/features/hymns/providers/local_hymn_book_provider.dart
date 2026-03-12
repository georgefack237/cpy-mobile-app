import 'package:cpy_app/data/local/database_services.dart';
import 'package:cpy_app/data/models/poem_model.dart';
import 'package:flutter/material.dart';
import '../../../data/models/hymn_book_collection.dart';
import '../../../data/models/hymn_song.dart';

class LocalHymnBookProvider extends ChangeNotifier {

  final DatabaseService?  databaseService;

  LocalHymnBookProvider({this.databaseService});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<HymnBookCollection>? _hymnBooks;
  List<HymnBookCollection>? get hymnBooks => _hymnBooks;

  HymnBookCollection? _addedHymnBook;
  HymnBookCollection? get addedHymnBook => _addedHymnBook;

  List<HymnSong>? _songs;
  List<HymnSong>? get songs => _songs;

  List<PoemModel>? _poems;
  List<PoemModel>? get poems => _poems;

  int? _allPoems;
  int? get allPoems => _allPoems;

  int? _allSongs;
  int? get allSongs => _allSongs;

  Future<void> getHymnBooks() async {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLoading(true);
    });

    _resetError();

    try {

      final response = await databaseService!.getHymnBooks();
      _hymnBooks = response;
    } catch (e) {
      _error = "Unexpected error: $e";
    }
    _setLoading(false);
  }





  Future<void> getAllPoems() async {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLoading(true);
    });

    _resetError();


    try {

      final response = await databaseService!.getAllPoems();
      _allPoems = response!.length;

    } catch (e) {
      _error = "Unexpected error: $e";
    }


    _setLoading(false);


  }


  Future<void> getAllSongs() async {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLoading(true);
    });

    _resetError();


    try {

      final response = await databaseService!.getAllSongs();
      _allSongs = response!.length;

    } catch (e) {
      _error = "Unexpected error: $e";
    }


    _setLoading(false);


  }


  Future<void> getLocalHymnBookPoems({required int hymnBookId}) async {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLoading(true);
    });

    _resetError();


    try {

      final response = await databaseService!.getHymnPoemsByHymnBookId(hymnBookId: hymnBookId);
      _poems = response;

    } catch (e) {
      _error = "Unexpected error: $e";
    }


    _setLoading(false);


  }




  Future<void> getLocalHymnBookSongs({required int hymnBookId}) async {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLoading(true);
    });

    _resetError();


    try {

      final response = await databaseService!.getHymnSongsByHymnBookId(hymnBookId: hymnBookId);

      print(response);
      _songs = response;

    } catch (e) {
      _error = "Unexpected error: $e";
    }


    _setLoading(false);


  }



  Future<void> addHymnBookSong({required HymnSong hymnSong}) async {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLoading(true);
    });

    _resetError();

    try {
     await databaseService!.insertHymnSong(hymnSong);

    } catch (e) {
      _error = "Unexpected error: $e";
    }

    _setLoading(false);
  }





  Future<void> addHymnBookPoem({required PoemModel poem}) async {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLoading(true);
    });

    _resetError();

    try {
      await databaseService!.insertHymnPoem(poem);

    } catch (e) {
      _error = "Unexpected error: $e";
    }

    _setLoading(false);
  }



  Future<void> addHymnBook({required HymnBookCollection hymnBook}) async {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLoading(true);
    });

    _resetError();

    try {
      final response = await  databaseService!.insertHymnBook(hymnBook);

      _addedHymnBook = response;

    } catch (e) {
      _error = "Unexpected error: $e";
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
    _songs = null;
    _addedHymnBook = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }


}
