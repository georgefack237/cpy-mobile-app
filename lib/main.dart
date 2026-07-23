import 'package:cpy_app/profile/network/profile_services.dart';
import 'package:cpy_app/profile/providers/profile_provider.dart';
import 'package:cpy_app/utils/font_controls.dart';
import 'package:cpy_app/utils/font_settings.dart';
import 'package:cpy_app/utils/globals.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'core/firebase_push_notifications/routes.dart';
import 'core/firebase_push_notifications/service.dart';
import 'data/local/database_services.dart';
import 'data/network/admin/hymn_book_management/admin_hymnbook_services.dart';
import 'features/home/provider/picture_verse_provider.dart';
import 'features/home/provider/picture_verse_services.dart';
import 'features/hymns/providers/admin_hymn_book_provider.dart';
import 'features/hymns/providers/local_hymn_book_provider.dart';
import 'features/media/data/network/media_file_services.dart';
import 'features/media/pages/media_page.dart';

import 'package:flutter/widgets.dart';

import 'features/media/providers/media_files_provider.dart';
import 'features/notifications/providers/notification_services.dart';
import 'features/notifications/providers/notifications_provider.dart';
import 'features/strong/providers/word_reference_provider.dart';
import 'features/strong/providers/word_reference_services.dart';

Future<void> main() async {
  SentryWidgetsFlutterBinding.ensureInitialized();

  await _initializeServices();
  _configureSystemUI();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await SentryFlutter.init(
        (options) {
      options.dsn = const String.fromEnvironment('https://ca5e0b8sentry.io/4510994656329808');
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runApp(const AppProviders()),
  );
}

Future<void> _initializeServices() async {
  await Firebase.initializeApp();
  //await PushNotificationService.instance.init();
  tz.initializeTimeZones();
  await initGlobals();
}

void _configureSystemUI() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
}

class AppProviders extends StatelessWidget {
  const AppProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(
            profileServices: ProfileServices(),
            databaseService: DatabaseService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PictureVerseProvider(
            pictureVerseServices: PictureVerseServices(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AdminHymnBookProvider(
            adminHymnbookServices: AdminHymnbookServices(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => RefreshNotifier()),
        ChangeNotifierProvider(
          create: (_) => NotificationsProvider(
            notificationServices: NotificationServices(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => WordReferenceProvider(
            wordReferenceServices: WordReferenceServices(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => LocalHymnBookProvider(
            databaseService: DatabaseService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => FontSettings(),
          child: const FontControls(),
        ),
        ChangeNotifierProvider(
          create: (_) => MediaFilesProvider(
            mediaFileServices: MediaFileServices(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Poppins'),
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}