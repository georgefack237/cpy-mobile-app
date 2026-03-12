import 'dart:async';
import 'package:cpy_app/constants/globals.dart';
import 'package:cpy_app/data/models/poem_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../../../../constants/api_constants.dart';
import '../../../models/hymn_song.dart';

class AdminHymnbookServices {

  Future<HymnSongResponse> addHynSong({
    required HymnSong hymnSong,
    required String partitions,
    String? uniqueProgression
  }) async {

    final dataResponse = HymnSongResponse();
    try {

      final headers = {
        'Accept': 'application/json',
        'Accept-Language': 'en',
      };

      final body = {
        'hymn_book_id': hymnSong.hymnBookId.toString(),
        'category_id': hymnSong.categoryId.toString(),
        'scale_id': hymnSong.scaleId.toString(),
        'title': hymnSong.title,
        'audio_url': hymnSong.audioUrl,
        'has_one_progression': hymnSong.hasOneProgression.toString(),
        'has_chord_over_lyrics': hymnSong.hasChordOverLyrics .toString(),
        'partitions': partitions,
        'unique_progression': hymnSong.hasOneProgression == 1 ? "": uniqueProgression.toString()
    };

      final response = await http.post(
        Uri.parse(ApiConstants.addHymnSongURL),
        headers: headers,
        body: body,
      );

      final responseBody = jsonDecode(response.body);
      print(responseBody);

      switch (response.statusCode) {

        case ApiConstants.successCode:
          dataResponse.data = HymnSong.fromJson(responseBody['data']);
          break;

        case ApiConstants.errorCode:

          dataResponse.error = responseBody['message'];
          break;

        default:
          dataResponse.error = response.body;
          break;
      }
    } on SocketException {

      dataResponse.error = "No Internet connection!";

    } catch (e) {

      dataResponse.error = "Unexpected error: $e";

    }

    return dataResponse;
  }





  Future<HymnSongListResponse> getHymnBook({
    required String hymnBookId,
  }) async {

    final dataResponse = HymnSongListResponse();
    try {

      final headers = {
        'Accept': 'application/json',
        'Accept-Language': 'en',
      };

      final body = {
        'hymn_book_id': hymnBookId
      };

      final response = await http.post(
        Uri.parse(ApiConstants.getHymnBookSongsURL),
        headers: headers,
        body: body,
      );

      //  final responseBody = jsonDecode(response.body);

      switch (response.statusCode) {

        case ApiConstants.successCode:
          List<HymnSong> songs = [];

          for(var data in jsonDecode(response.body)['data']){
            HymnSong hymnSong = HymnSong.fromJson(data);
            songs.add(hymnSong);
          }
          dataResponse.data = songs;
          break;

        case ApiConstants.errorCode:

          dataResponse.error = jsonDecode(response.body)['message'];
          break;

        default:
          dataResponse.error = response.body;
          break;
      }
    }on SocketException catch (e) {

      ///dataResponse.error = "No Internet connection!";
      print("SocketException: $e"); // Log for debugging

      dataResponse.data = [];
    } on TimeoutException catch (e) {
      // Handles timeout exceptions
      dataResponse.error = "Request timed out. Please try again.";
      print("TimeoutException: $e"); // Log for debugging
    } on FormatException catch (e) {
      dataResponse.error = e.message;
      print("FormatException: $e"); // Log for debugging
    } catch (e) {
      // General catch for unexpected errors
      dataResponse.error = "Unexpected error: ${e.toString().trim()}";
      print("Unexpected error: $e"); // Log for debugging
    }
    return dataResponse;
  }



  Future<HymnSongListResponse> getHymnBookSongs({
    required String hymnBookId,
  }) async {

    final dataResponse = HymnSongListResponse();
    try {

      final headers = {
        'Accept': 'application/json',
        'Accept-Language': 'en',
      };

      final body = {
        'hymn_book_id': hymnBookId
      };

      final response = await http.post(
        Uri.parse(ApiConstants.getHymnBookSongsListURL),
        headers: headers,
        body: body,
      );

      print(response.body);

      switch (response.statusCode) {

        case ApiConstants.successCode:
          List<HymnSong> songs = [];

          for(var data in jsonDecode(response.body)['data']){
            HymnSong hymnSong = HymnSong.fromJson(data);
            songs.add(hymnSong);
          }
          dataResponse.data = songs;
          break;

        case ApiConstants.errorCode:

          dataResponse.error = jsonDecode(response.body)['message'];
          break;

        default:
          dataResponse.error = response.body;
          break;
      }
    }on SocketException catch (e) {
      // Handles cases where there is no internet connection
      ///dataResponse.error = "No Internet connection!";
      print("SocketException: $e"); // Log for debugging

      dataResponse.data = [];
    } on TimeoutException catch (e) {
      // Handles timeout exceptions
      dataResponse.error = "Request timed out. Please try again.";
      print("TimeoutException: $e"); // Log for debugging
    } on FormatException catch (e) {
      dataResponse.error = e.message;
      print("FormatException: $e"); // Log for debugging
    } catch (e) {
      // General catch for unexpected errors
      dataResponse.error = "Unexpected error: ${e.toString().trim()}";
      print("Unexpected error: $e"); // Log for debugging
    }
    return dataResponse;
  }





  Future<HymnSongResponse> getHymnBookSong({
    required String songId,
  }) async {

    final dataResponse = HymnSongResponse();
    try {

      final headers = {
        'Accept': 'application/json',
        'Accept-Language': 'en',
      };

      final body = {
        'song_id': songId
      };

      final response = await http.post(
        Uri.parse(ApiConstants.getHymnBookSongURL),
        headers: headers,
        body: body,
      );

      print(response.body);

      switch (response.statusCode) {

        case ApiConstants.successCode:

            HymnSong hymnSong = HymnSong.fromJson(jsonDecode(response.body)['data']);


          dataResponse.data = hymnSong;
          break;

        case ApiConstants.errorCode:

          dataResponse.error = jsonDecode(response.body)['message'];
          break;

        default:
          dataResponse.error = response.body;
          break;
      }
    }on SocketException catch (e) {

      var data = await databaseService.getHymnSongById(id: int.parse(songId));

      if(data != null){

        dataResponse.data = data;
      }else{
        dataResponse.error = "Pas de connexion Internet";

      }




    } on TimeoutException catch (e) {
      var data = await databaseService.getHymnSongById(id: int.parse(songId));

      if(data != null){

        dataResponse.data = data;
      }else{
        dataResponse.error = "Délai d'attente expiré. Veuillez réessayer.";

      }


      // Log for debugging
    } on FormatException catch (e) {
      dataResponse.error = e.message;
      print("FormatException: $e"); // Log for debugging
    } catch (e) {
      // General catch for unexpected errors
      dataResponse.error = "Unexpected error: ${e.toString().trim()}";
      print("Unexpected error: $e"); // Log for debugging
    }
    return dataResponse;
  }



  Future<PoemListResponse> getHymnBookPoems({
    required String hymnBookId
  }) async {

    final dataResponse = PoemListResponse();

    try {
      final headers = {
        'Accept': 'application/json',
        'Accept-Language': 'en'
      };

      final body = {
        'hymn_book_id': hymnBookId
      };

      final response = await http.post(
        Uri.parse(ApiConstants.getHymnBookPoemsURL),
        headers: headers,
        body: body
      );


      print(response.body);

      switch (response.statusCode) {

        case ApiConstants.successCode:

          List<PoemModel> poems = [];

          for(var data in jsonDecode(response.body)['data']){

            PoemModel poem = PoemModel.fromJson(data);
            poems.add(poem);
          }
          dataResponse.data = poems;
          break;

        case ApiConstants.errorCode:

          dataResponse.error = jsonDecode(response.body)['message'];
          break;

        default:
          dataResponse.error = response.body;
          break;
      }
    }on SocketException catch (e) {
      // Handles cases where there is no internet connection
      ///dataResponse.error = "No Internet connection!";
      print("SocketException: $e"); // Log for debugging

      dataResponse.data = [];
    } on TimeoutException catch (e) {
      // Handles timeout exceptions
      dataResponse.error = "Request timed out. Please try again.";
      print("TimeoutException: $e"); // Log for debugging
    } on FormatException catch (e) {
      dataResponse.error = e.message;
      print("FormatException: $e"); // Log for debugging
    } catch (e) {
      // General catch for unexpected errors
      dataResponse.error = "Unexpected error: ${e.toString().trim()}";
      print("Unexpected error: $e"); // Log for debugging
    }
    return dataResponse;
  }


}
