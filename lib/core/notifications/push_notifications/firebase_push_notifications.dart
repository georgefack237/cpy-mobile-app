import 'dart:io';
import 'dart:ui';
import 'package:cpy_app/core/notifications/push_notifications/push_notification.dart';
import 'package:cpy_app/features/hymns/pages/hymn_books_page.dart';
import 'package:cpy_app/features/media/pages/media_page.dart';
import 'package:cpy_app/features/strong/pages/strong_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../../features/hymns/pages/poem_detail_page.dart';
import 'fcm_provider.dart';

class NotificationService {


  static FirebaseMessaging? _firebaseMessaging;
  static FirebaseMessaging get firebaseMessaging =>
      NotificationService._firebaseMessaging ?? FirebaseMessaging.instance;

  static Future<void> initializeFirebase() async {
    NotificationService._firebaseMessaging = FirebaseMessaging.instance;
    await NotificationService.initializeLocalNotifications();
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  }


  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initializeLocalNotifications() async {

    const InitializationSettings initSettings = InitializationSettings(
        android: AndroidInitializationSettings("app_icon"),
        iOS: DarwinInitializationSettings());


    await NotificationService._localNotificationsPlugin.initialize(initSettings, onDidReceiveNotificationResponse: FCMProvider.onTapNotification);

     //await AdnaFirebasePushNotifications.firebaseMessaging.requestPermission();


    await NotificationService.firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await NotificationService.firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: false,
      sound: true,
    );


    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: false,
      sound: true,
    );


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {

      var id = message.data['id'];
      var page = message.data['page'];


      if (id == 'update') {

      }
    });


  }


  static Future<void> init(BuildContext context) async {
    // For background notification tap
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessage(context, message);
    });

  }

  static void _handleMessage(BuildContext context, RemoteMessage message) {
    final data = message.data;
    final page = data['page'];
    final id = data['id'];

    if (id == 'update') {
      // Handle update action
      return;
    }

    switch (page) {
      case 'songs':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const HymnBooksPage()));
        break;
      case 'medias':
        Navigator.push(context, MaterialPageRoute(builder: (_) => MediaPage()));
        break;

      case 'poems':
        Navigator.push(context, MaterialPageRoute(builder: (context)=>  PoemDetailPage(id: message.data['id'] , title: '')));

        break;
      case 'words':
        Navigator.push(context, MaterialPageRoute(builder: (_) => StrongPage()));
        break;
    }
  }

  static Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {

    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    await Firebase.initializeApp();

    try {

      if(message.data['page'] == ''){




      }
    }catch(e){
      print(e.toString());
    }


  }


  static NotificationDetails platformChannelSpecifics =
  const NotificationDetails(
      android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.max,
          enableLights: true,
          icon: "app_icon",
          color: Color.fromARGB(240, 151, 14, 232),
          priority: Priority.max,
          sound: RawResourceAndroidNotificationSound("promise_tone"),
          playSound: true),
      iOS: DarwinNotificationDetails());



  Future<void> deleteNotificationToken() async {
    await NotificationService.firebaseMessaging.deleteToken();
  }



  static Future<void> onMessage(BuildContext context) async {

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {

     // _handleMessage(context, message);

      if (Platform.isAndroid) {


        await NotificationService._localNotificationsPlugin.show(
          0,
          message.notification!.title,
          message.notification!.body,
          NotificationService.platformChannelSpecifics,
          payload: message.data.toString(),
        );



      }else{


        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        if(notification.body != null){

          showSimpleNotification(
            Text(notification.title!),
            subtitle: Text(notification.body!),
            background: Colors.white,
            duration: const Duration(seconds: 2),

          );
        }


      }
    });
  }




}
