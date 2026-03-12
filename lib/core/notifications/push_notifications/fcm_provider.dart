
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart' show RemoteMessage;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'firebase_push_notifications.dart';

class FCMProvider with ChangeNotifier {
  static BuildContext? _context;

  static void setContext(BuildContext context) =>
      FCMProvider._context = context;

  static Future<void> onTapNotification(NotificationResponse? response) async {
    if (FCMProvider._context == null || response?.payload == null) return;
    final  Map data = FCMProvider.convertPayload(response!.payload!);
    if (data.containsKey('screen')) {
      // await Navigator.of(FCMProvider._context!).push(MaterialPageRoute(builder: (c)=> const Notifications()));
    }
  }

  static Map convertPayload(String payload) {
    final String payload0 = payload.substring(1, payload.length - 1);
    List<String> split = [];
    payload0.split(",").forEach((String s) => split.addAll(s.split(":")));
    Map mapped = {};
    for (int i = 0; i < split.length + 1; i++) {
      if (i % 2 == 1) {
        mapped.addAll(
            {split[i - 1].trim().toString(): split[i].trim()});
      }
    }
    return mapped;
  }



  static Future<void> backgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    NotificationService.initializeFirebase();

    if(message.data['page'] == 'update_location'){



    }

  }
}

