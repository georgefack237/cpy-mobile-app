
import 'package:cpy_app/features/notifications/data/notification_model.dart';
import 'package:flutter/material.dart';

import 'notification_services.dart';


class NotificationsProvider extends ChangeNotifier {

  final NotificationServices?  notificationServices;
  NotificationsProvider({this.notificationServices});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<NotificationModel>? _notifications;
  List<NotificationModel>? get notifications => _notifications;

  String _message = '';
  String get message => _message;


  void removeListWord({required int index}){
    _notifications!.removeAt(index);
    notifyListeners();
  }

  Future<void> getNotifications({required BuildContext context}) async {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLoading(true);
    });

    _resetError();

    try {
      final response = await notificationServices!.getNotifications();

      if (response.error == null) {

        _notifications = response.data;

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
    _notifications = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }


}
