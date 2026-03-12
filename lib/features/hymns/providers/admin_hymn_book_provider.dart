import 'package:cpy_app/constants/globals.dart';
import 'package:flutter/material.dart';
import '../../../data/models/hymn_book_collection.dart';
import '../../../data/models/hymn_song.dart';
import '../../../data/models/poem_model.dart';
import '../../../data/network/admin/hymn_book_management/admin_hymnbook_services.dart';
import '../../../data/network/hymns_book/hymn_book_network_services.dart';


class AdminHymnBookProvider extends ChangeNotifier {

  final AdminHymnbookServices?  adminHymnbookServices;

  AdminHymnBookProvider({this.adminHymnbookServices});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<HymnSong>? _songs;
  List<HymnSong>? get songs => _songs;

  List<HymnBookCollection>? _hymnBooks;
  List<HymnBookCollection>? get hymnBooks => _hymnBooks;

  HymnSong? _addedSong;
  HymnSong? get addedSong => _addedSong;

  List<PoemModel>? _poems;
  List<PoemModel>? get poems => _poems;

  PoemModel? _poem;
  PoemModel? get poem => _poem;

  DataResponse? _dataResponse;
  DataResponse? get dataResponse => _dataResponse;


  HymnSong? _hymnSong;
  HymnSong?  get  hymnSong => _hymnSong;


  Future<void> getDataResponse() async {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLoading(true);
    });

    print(_isLoading);

    _resetError();

    try {

      final response = await HymnBookNetworkServices().getBooksData();
      if (response.error == null) {


        _dataResponse = DataResponse(songCount: response.songCount, poemCount: response.poemCount);

      } else {
        if(response.error!.isEmpty){

          _error = "No internet connection";

        }else{
          _error = response.error;
        }
      }
    } catch (e) {
      _error = "Unexpected error: $e";

      print(_error);
    }

    _setLoading(false);
  }


  Future<void> getPoemById({required int id}) async {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLoading(true);
    });

    print(_isLoading);

    _resetError();

    try {

      final response = await HymnBookNetworkServices().getPoemById(id: id);
      if (response.error == null) {


        _poem = response.data;

      } else {
        if(response.error!.isEmpty){

          _error = "No internet connection";

        }else{
          _error = response.error;
        }
      }
    } catch (e) {
      _error = "Unexpected error: $e";

      print(_error);
    }

    _setLoading(false);
  }




  Future<void> getHymnSong({required int id}) async {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLoading(true);
    });

    print(_isLoading);

    _resetError();

    try {

      final response = await adminHymnbookServices!.getHymnBookSong(songId: id.toString());

      if (response.error == null) {

        _hymnSong = response.data;

      } else {

        if(response.error!.isEmpty && response.data != null){
          _error = 'No internet connection';

        }else{
          _error = response.error;
        }
      }
    } catch (e) {
      _error = "Unexpected error: $e";

      print(_error);
    }

    _setLoading(false);
  }



  Future<void> getHymnBooks() async {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLoading(true);
    });

    print(_isLoading);

    _resetError();

    try {

      final response = await HymnBookNetworkServices().getHymnBooks();
      if (response.error == null) {
        _hymnBooks = response.data;
      } else {
        if(response.error!.isEmpty){
          _error = "No internet connection";

        }else{
          _error = response.error;
        }
      }
    } catch (e) {
      _error = "Unexpected error: $e";

      print(_error);
    }

    _setLoading(false);
  }


  Future<void> getLocalHymnBookSongs({required String hymnBookId}) async {
  //  _resetError();
    try {
      final response = localHymns.where((hymn){return hymn.hymnBookId.toString() == hymnBookId;}).toList();

      _songs = response;

    } catch (e) {
      _error = "Unexpected error: $e";
    }

  }



  Future<void> getHymnBookPoems({required int hymnBookId}) async {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLoading(true);
    });

    _resetError();

    try {
      final response = await adminHymnbookServices!.getHymnBookPoems(hymnBookId: hymnBookId.toString());
      if (response.error == null) {
        _poems = response.data;

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


  Future<void> getHymnBookSongs({required String hymnBookId}) async {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLoading(true);
    });

    _resetError();

    try {
      final response = await adminHymnbookServices!.getHymnBookSongs(hymnBookId: hymnBookId);
      if (response.error == null) {

        _songs = response.data;

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

  void _resetError() {
    _error = null;
  }

  void resetState() {
    _songs = null;
    _addedSong = null;
    _poem = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }


}
