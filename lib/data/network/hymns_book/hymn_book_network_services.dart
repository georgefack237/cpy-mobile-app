import 'dart:async';

import 'package:cpy_app/data/models/poem_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import '../../../constants/api_constants.dart';
import '../../../constants/globals.dart';
import '../../models/hymn_book_collection.dart';

class HymnBookNetworkServices {



  Future<HymnBookCollectionListResponse> getHymnBooks() async {

    final dataResponse = HymnBookCollectionListResponse();
    try {

      final headers = {
        'Accept': 'application/json',
        'Accept-Language': 'en',
      };

      isNetworkEnabled.value = true;


      final response = await http.post(
        Uri.parse(ApiConstants.getHymnBooksURL),
        headers: headers,
      ).timeout(Duration(seconds: 20));

      final responseBody = jsonDecode(response.body);

      switch (response.statusCode) {

        case ApiConstants.successCode:
          List<HymnBookCollection> books = [];
          for(var book in responseBody['data']){
            HymnBookCollection collection = HymnBookCollection.fromJson(book);
            books.add(collection);
          }
          dataResponse.data = books;
          break;

        case ApiConstants.errorCode:

          dataResponse.error = responseBody['message'];
          break;

        default:
          dataResponse.error = "Server error!";
          break;
      }
    } on SocketException {
      //dataResponse.data = ;
     dataResponse.error = "No Internet connection!";

    }on TimeoutException{

      isNetworkEnabled.value = false;
      dataResponse.error = "Time out ${isNetworkEnabled.value}";


    } catch (e) {
      isNetworkEnabled.value = false;
      dataResponse.error = "Unexpected error: $e";

    }

    return dataResponse;
  }




  Future<DataResponse> getBooksData() async {

    final dataResponse = DataResponse();
    try {

      final headers = {
        'Accept': 'application/json',
        'Accept-Language': 'en',
      };

      isNetworkEnabled.value = true;


      final response = await http.get(
          Uri.parse(ApiConstants.getBooksDataURL),
          headers: headers
      );

      final responseBody = jsonDecode(response.body);

      logger.i(responseBody);

      switch (response.statusCode) {

        case ApiConstants.successCode:

          dataResponse.songCount = responseBody['songs'];
          dataResponse.poemCount = responseBody['poems'];
          break;

        case ApiConstants.errorCode:

          dataResponse.error = responseBody['message'];
          break;

        default:
          dataResponse.error = "Server error!";
          break;
      }
    } on SocketException {
      //dataResponse.data = ;
      dataResponse.error = "No Internet connection!";

    }on TimeoutException{

      isNetworkEnabled.value = false;
      dataResponse.error = "Time out ${isNetworkEnabled.value}";


    } catch (e) {
      isNetworkEnabled.value = false;
      dataResponse.error = "Unexpected error: $e";

    }

    return dataResponse;
  }




  Future<PoemResponse> getPoemById({required int id}) async {

    final dataResponse = PoemResponse();
    try {

      final headers = {
        'Accept': 'application/json',
        'Accept-Language': 'en',
      };

      isNetworkEnabled.value = true;


      final response = await http.post(
        Uri.parse(ApiConstants.getHPoemByItemURL),
        headers: headers,
        body: {
          'id': id.toString()
        }
      );

      final responseBody = jsonDecode(response.body);

      logger.i(responseBody);

      switch (response.statusCode) {

        case ApiConstants.successCode:

          PoemModel poemModel = PoemModel.fromJson(responseBody['data']);
          dataResponse.data = poemModel;
          break;

        case ApiConstants.errorCode:

          dataResponse.error = responseBody['message'];
          break;

        default:
          dataResponse.error = "Server error!";
          break;
      }
    } on SocketException {
      //dataResponse.data = ;
      dataResponse.error = "No Internet connection!";

    }on TimeoutException{

      isNetworkEnabled.value = false;
      dataResponse.error = "Time out ${isNetworkEnabled.value}";


    } catch (e) {
      isNetworkEnabled.value = false;
      dataResponse.error = "Unexpected error: $e";

    }

    return dataResponse;
  }



}
