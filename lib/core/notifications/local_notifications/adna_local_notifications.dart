
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';
import 'dart:math' as math;

class AdnaLocalNotifications {
  var uuid = const Uuid();
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();


  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('app_icon');
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 2000;
    vibrationPattern[2] = 2000;
    vibrationPattern[3] = 1000;

    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.max,

    );

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
          print(":::::::::::::::::::::::::NEWEST WORK NOTIFICATION $payload");
        });

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await _localNotificationsPlugin.initialize(
        initializationSettings
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);



  }



  notificationDetails() {
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 2000;
    vibrationPattern[2] = 2000;
    vibrationPattern[3] = 1000;



    return NotificationDetails(
        android: AndroidNotificationDetails(
          'default_notification_channel_id',
          'Tasks',
          importance: Importance.max,
          enableLights: true,
          icon: "app_icon",
          color: const Color.fromARGB(240, 222, 227, 250),
          priority: Priority.max,
          sound: const RawResourceAndroidNotificationSound("promise_tone"),
          playSound: true,
          vibrationPattern: vibrationPattern,


        ),
        iOS: const DarwinNotificationDetails(
            sound: 'promise_tone.caf'
        ));
  }



  zonedScheduleNotification(String note, DateTime date, occ) async {
    int id = math.Random().nextInt(10000);

    try {
      await _localNotificationsPlugin.zonedSchedule(
        id,
        occ,
        note,
        tz.TZDateTime.parse(tz.local, date.toString()),
        notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );
      return id;
    } catch (e) {
      if (kDebugMode) {
        print("Error at zonedScheduleNotification----------------------------$e");
      }
      if (e ==
          "Invalid argument (scheduledDate): Must be a date in the future: Instance of 'TZDateTime'") {
        if (kDebugMode) {
          print("Select future date");
        }
      }
      return -1;
    }
  }

  Future cancelLocalNotification(int id) async {
    await _localNotificationsPlugin.cancel(id);
  }

  Future scheduleNotification(

      {String? title,
        String? body,
        String? payLoad,
        int? id,
        required DateTime scheduledNotificationDateTime}) async {



    await _localNotificationsPlugin.zonedSchedule(
        id!,
        title,
        body,
        tz.TZDateTime.from(scheduledNotificationDateTime, tz.local),
        await notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exact,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );



  }





}
