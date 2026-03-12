import 'dart:async';
import 'package:cpy_app/profile/model/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../../../../constants/api_constants.dart';


class ProfileServices {

  Future<ProfileResponse> addProfile({
    required String deviceId,
    required String notificationId}) async {

    final dataResponse = ProfileResponse();

    try {

      final headers = {
        'Accept': 'application/json',
        'Accept-Language': 'en',
      };

      
      final body = {
        'device_id': deviceId,
        'notification_id': notificationId
      };

      final response = await http.post(
        Uri.parse(ApiConstants.addProfileURL),
        headers: headers,
        body: body,
      );

      final responseBody = jsonDecode(response.body);

      switch (response.statusCode) {

        case ApiConstants.successCode:
          dataResponse.data = Profile.fromJson(responseBody['data']);
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

}
