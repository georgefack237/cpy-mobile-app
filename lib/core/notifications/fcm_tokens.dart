import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

Future<String?> getFcmToken() async {


  if (Platform.isIOS) {

    String? fcmKey = await FirebaseMessaging.instance.getToken();
    //await FirebaseMessaging.instance.subscribeToTopic('all');
    return fcmKey;



  }else{
    await FirebaseMessaging.instance.subscribeToTopic('all');
    String? fcmKey = await FirebaseMessaging.instance.getToken();
    return fcmKey;
  }


}



Future<void> deleteToken() async {
  await FirebaseMessaging.instance.deleteToken();
}

