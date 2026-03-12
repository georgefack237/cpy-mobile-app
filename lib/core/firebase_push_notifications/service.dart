import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Centralized notification service using FCM + local notifications.
class PushNotificationService {
  PushNotificationService._internal();

  static final PushNotificationService _instance = PushNotificationService._internal();
  static PushNotificationService get instance => _instance;

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  /// Global navigation key used to navigate from background/terminated state.
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Initialize everything: permissions, channels, listeners, and check initial message.
  Future<void> init() async {
    // Request permissions (Android 13+, iOS)
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      log('🔕 Notifications permission denied');
      return;
    }

    log('✅ Notifications permission granted');

    // Setup local notification plugin and Android channel
    await _initLocalNotifications();

    // Print FCM token for testing
    final token = await _fcm.getToken();
    log('📱 FCM Token: $token');

    // 1️⃣ Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // 2️⃣ Notification opened while app in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // 3️⃣ App opened from terminated state (cold start)
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }

    // 4️⃣ Background message handler (separate isolate)
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  }

  /// Initialize local notifications and Android notification channel.
  Future<void> _initLocalNotifications() async {
    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important push notifications.',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    // Initialization settings for Android and iOS
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _localNotifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
      ),
      onDidReceiveNotificationResponse: (details) {
        // Called when a local notification (scheduled or custom) is tapped
        final payload = details.payload;
        if (payload != null) {
          _handleLocalNotificationTap(payload);
        }
      },
    );

    // Create the Android channel (Android 8+)
    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  /// Show a local notification from a received FCM message (foreground only).
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final title = message.notification?.title ?? 'Notification';
    final body = message.notification?.body ?? '';
    final data = message.data; // custom data for navigation

    final payload = jsonEncode(data);

    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important push notifications.',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      showWhen: true,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _localNotifications.show(
      message.hashCode,
      title,
      body,
      const NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
      ),
      payload: payload,
    );
  }

  /// Handle FCM message when app is in foreground.
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    log('📩 Foreground message: ${message.messageId}');
    _showLocalNotification(message);
  }

  /// Called when a remote notification is tapped (background or terminated).
  void _handleNotificationTap(RemoteMessage message) {
    final data = message.data;
    _navigateBasedOnData(data);
  }

  /// Called when a local notification is tapped.
  void _handleLocalNotificationTap(String payload) {
    final data = jsonDecode(payload) as Map<String, dynamic>;
    _navigateBasedOnData(data);
  }




  void _navigateBasedOnData(Map<String, dynamic> data) {
    final routeName = data['page'] ?? data['page'] ?? '/';
    final args = data['id'];

    // Wait for widget tree to be built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performNavigation(routeName, args);
    });
  }

  void _performNavigation(String routeName, dynamic args) {
    final navigator = navigatorKey.currentState;
    if (navigator == null) {
      log('❌ Navigator null - retrying in 100ms');
      Future.delayed(const Duration(milliseconds: 100), () {
        _performNavigation(routeName, args);
      });
      return;
    }

    navigator.pushNamed(routeName, arguments: args);
  }



  // Public helpers

  Future<String?> getToken() => _fcm.getToken();
  Future<void> deleteToken() => _fcm.deleteToken();
  Future<void> subscribeToTopic(String topic) => _fcm.subscribeToTopic(topic);
  Future<void> unsubscribeFromTopic(String topic) => _fcm.unsubscribeFromTopic(topic);
}

/// Background message handler – runs in a separate isolate.
@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  log('📩 Background message: ${message.messageId}');
  // If you want to display a notification while in background,
  // you can use flutter_local_notifications here as well.
  // Be careful: the isolate is separate, you may need to re-initialize plugins.
  // Usually FCM shows a heads-up notification automatically if the payload contains a 'notification' field.
}