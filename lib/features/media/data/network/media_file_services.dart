import 'dart:async';
import 'package:cpy_app/constants/globals.dart';
import 'package:cpy_app/features/media/data/models/media_file.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../../../../constants/api_constants.dart';


class MediaFileServices {

  Future<MediaFileListResponse> getMediaFiles() async {

    final dataResponse = MediaFileListResponse();

    isNetworkEnabled.value = true;


    try {
      final headers = {
        'Accept': 'application/json',
        'Accept-Language': 'en',
      };


      final response = await http.post(
        Uri.parse(ApiConstants.getMediaFilesURL),
        headers: headers
      ).timeout(Duration(seconds: 20));


      switch (response.statusCode) {
        case ApiConstants.successCode:

          List<MediaFile> files = [];

          for(var data in jsonDecode(response.body)['data']){

            MediaFile file = MediaFile.fromJson(data);
            files.add(file);
            databaseService.insertFile(file);
          }
          dataResponse.data = files;
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

      var offlineData = await databaseService.getAllFiles();

      if(offlineData != null){

        dataResponse.data = offlineData;
      }else{
        dataResponse.error = "Pas de connexion Internet";

      }
    } on TimeoutException catch (e) {
      
      isNetworkEnabled.value = false;

      // Handles cases where there is no internet connection
      var offlineData = await databaseService.getAllFiles();
      if(offlineData != null){

        dataResponse.data = offlineData;
      }else{
        dataResponse.error = "Délai d'attente expiré. Veuillez réessayer.";

      }

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

