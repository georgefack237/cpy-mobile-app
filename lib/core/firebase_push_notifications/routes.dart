import 'package:cpy_app/features/home/pages/main_page.dart';
import 'package:cpy_app/features/hymns/pages/hymn_books_page.dart';
import 'package:cpy_app/features/media/pages/media_page.dart';
import 'package:cpy_app/features/strong/pages/strong_page.dart';
import 'package:flutter/material.dart';

import '../../features/hymns/pages/poem_detail_page.dart';
import '../../features/introduction/screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String words = 'words';
  static const String songs = 'songs';
  static const String poems = 'poems';
  static const String medias = 'medias';
  static const String verses = 'verses';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case songs:
        return MaterialPageRoute(builder: (_) => const HymnBooksPage());

      case verses:
        return MaterialPageRoute(builder: (_) => const MainAppScreen());


      case words:
        return MaterialPageRoute(builder: (_) => const StrongPage());

      case poems:
      // Extract arguments
        final args = settings.arguments;
        if (args is String) {

          return MaterialPageRoute(
            builder: (_) => PoemDetailPage(id: int.parse(args), title: ''),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const HymnBooksPage(),
        );

      case medias:
        return MaterialPageRoute(builder: (_) => const MediaPage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}