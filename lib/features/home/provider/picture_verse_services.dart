import 'dart:async';
import 'package:cpy_app/data/models/affiche.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../../../../constants/api_constants.dart';
import '../../../constants/globals.dart';


class PictureVerseServices {


  Future<PictureVerseListResponse> getPictureVerses() async {

    isNetworkEnabled.value = true;
    final dataResponse = PictureVerseListResponse();

    try {
      final headers = {
        'Accept': 'application/json',
        'Accept-Language': 'en',
      };

      final response = await http.post(Uri.parse(ApiConstants.getVersesURL),
          headers: headers
      ).timeout(const Duration(seconds: 20));

      print(response.body);

      switch (response.statusCode) {
        case ApiConstants.successCode:

          List<PictureVerse> verses = [];

          for(var data in jsonDecode(response.body)['data']){

            PictureVerse pictureVerse = PictureVerse.fromJson(data);
            verses.add(pictureVerse);

            /// TODO save to local storage
            databaseService.insertVerse(pictureVerse);

          }
          dataResponse.data = verses;
          break;

        case ApiConstants.errorCode:

          dataResponse.error = jsonDecode(response.body)['message'];
          break;

        default:
          dataResponse.error = response.body;
          break;
      }
    }on SocketException catch (e) {
      isNetworkEnabled.value = false;

      // Handles cases where there is no internet connection
      var offlineData = await databaseService.getAllVerses();
      print(offlineData);

      dataResponse.data = offlineData ?? [];

    } on TimeoutException catch (e) {


      isNetworkEnabled.value = false;

      // Handles cases where there is no internet connection
      var offlineData = await databaseService.getAllVerses();
      print(offlineData);

      dataResponse.data = offlineData ?? [];

      print("TimeoutException: $e");

    } on FormatException catch (e) {
      dataResponse.error = e.message;
      print("FormatException: $e"); // Log for debugging
    } catch (e) {
      isNetworkEnabled.value = false;

      // General catch for unexpected errors
      dataResponse.error = "Unexpected error: ${e.toString().trim()}";
      print("Unexpected error: $e"); // Log for debugging
    }
    return dataResponse;
  }


}
