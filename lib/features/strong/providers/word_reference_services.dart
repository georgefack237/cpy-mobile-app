import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../../../../constants/api_constants.dart';
import '../../../constants/globals.dart';
import '../data/model/word_reference.dart';


class WordReferenceServices {


  Future<WordReferenceListResponse> getWords() async {

    isNetworkEnabled.value = true;
    final dataResponse = WordReferenceListResponse();

    try {
      final headers = {
        'Accept': 'application/json',
        'Accept-Language': 'en',
      };

      final response = await http.post(Uri.parse(ApiConstants.getWordsURL),
          headers: headers
      ).timeout(const Duration(seconds: 20));

      print(response.body);

      switch (response.statusCode) {
        case ApiConstants.successCode:

          List<WordReference> words = [];

          for(var data in jsonDecode(response.body)['data']){

            WordReference wordReference = WordReference.fromJson(data);
            words.add(wordReference);
            databaseService.insertWord(wordReference);

          }
          dataResponse.data = words;
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
      var offlineData = await databaseService.getAllWords();

      if(offlineData != null){

        dataResponse.data = offlineData;
      }else{
        dataResponse.error = "Pas de connexion Internet";

      }


    } on TimeoutException catch (e) {

      isNetworkEnabled.value = false;

      // Handles cases where there is no internet connection
      var offlineData = await databaseService.getAllWords();
      if(offlineData != null){

        dataResponse.data = offlineData;
      }else{
        dataResponse.error = "Délai d'attente expiré. Veuillez réessayer.";

      }


      print("TimeoutException: $e"); // Log for debugging
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
