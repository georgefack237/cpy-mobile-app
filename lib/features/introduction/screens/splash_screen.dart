import 'dart:async';
import 'dart:io';
import 'package:cpy_app/features/home/pages/main_page.dart';
import 'package:cpy_app/features/introduction/screens/introduction_pages.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../utils/globals.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 2;
  bool _isFromNotification = false;

  @override
  void initState() {
    super.initState();
    _checkNotificationLaunch();
  }

  Future<void> _checkNotificationLaunch() async {
    // Check if app was opened from notification
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print('📱 App launched from notification - short splash');
      _isFromNotification = true;

      // Just show splash briefly, notification service will navigate
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          // Keep splash visible, notification service handles navigation
        }
      });
    } else {
      // Normal launch - proceed with normal flow
      _startNormalSplash();
    }
  }

  void _startNormalSplash() {
    Future.delayed(Duration(seconds: splashDelay), () {
      if (mounted) {
        _navigateToNextScreen();
      }
    });
  }

  Future<void> _navigateToNextScreen() async {
    bool showIntro = await showIntroScreenFunc();

    if (showIntro) {
      _navigateToIntro();
    } else {
      _navigateToMain();
    }
  }

  void _navigateToIntro() {
    // 🔥 FIXED: Use pushReplacement instead of pushAndRemoveUntil
    Navigator.of(context).pushReplacement(
      Platform.isAndroid
          ? MaterialPageRoute(builder: (context) => const IntroScreen())
          : CupertinoPageRoute(builder: (context) => const IntroScreen()),
    );
  }

  void _navigateToMain() {
    // 🔥 FIXED: Use pushReplacement instead of pushAndRemoveUntil
    Navigator.of(context).pushReplacement(
      Platform.isAndroid
          ? MaterialPageRoute(builder: (context) => const MainAppScreen())
          : CupertinoPageRoute(builder: (context) => const MainAppScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 250,
          width: 250,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}