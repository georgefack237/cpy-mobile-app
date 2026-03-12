import 'dart:async';
import 'package:cpy_app/features/notifications/data/notification_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../../../../constants/api_constants.dart';


class NotificationServices {
  
  Future<NotificationResponse> getNotifications() async {

    final dataResponse = NotificationResponse();

    try {
      final headers = {
        'Accept': 'application/json',
        'Accept-Language': 'en',
      };

      final response = await http.post(Uri.parse(ApiConstants.getNotificationsURL),
          headers: headers
      );

      print(response.body);

      switch (response.statusCode) {
        case ApiConstants.successCode:

          List<NotificationModel> notifications = [];


          for(var data in jsonDecode(response.body)['data']){

            NotificationModel wordReference = NotificationModel.fromJson(data);
            notifications.add(wordReference);
          }
          dataResponse.data = notifications;

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
