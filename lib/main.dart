import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:coffee2u/data/local_storage/local_storage.dart';
import 'package:coffee2u/services/firebase_analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/controller/index.dart';
import 'package:coffee2u/firebase_options.dart';
import 'package:coffee2u/screens/auth/splash_screen.dart';
import 'package:coffee2u/services/notification_service.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timezone/data/latest.dart' as tz;

import 'constants/env_init.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  await EnvInit.init();
  runApp(Phoenix(child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int language = 0; // 0 = th, 1 = en

  Future<bool> requestTrackingAuthorization() async {
    TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) status = await AppTrackingTransparency.requestTrackingAuthorization();
    return status == TrackingStatus.authorized;
  }

  _initState() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    bool setAdvertiserTracking = true;
    if(Platform.isIOS) setAdvertiserTracking = await requestTrackingAuthorization();
    await FirebaseAnalyticsService.setAdvertiserTracking(value: setAdvertiserTracking);
    
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, DeviceOrientation.portraitDown
    ]);

    final prefs = await SharedPreferences.getInstance();
    final temp = prefs.getInt(prefLocalLanguage);
    if (temp != null) {
      language = temp;
    }
    Utils.appLocale = language == 0
      ? const Locale('th', 'TH'): const Locale('en', 'US');
    Intl.defaultLocale = language == 0 ? 'th' : 'en';
    timeago.setLocaleMessages('th', timeago.ThMessages());

    // Timezone
    tz.initializeTimeZones();

    // Youtube Config
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: kAppColor,
      ),
    );

    // Firebase
    NotificationService.init();
    FirebaseMessaging.onBackgroundMessage(
      NotificationService.onMessagingBackground,
    );

    // Badge
    AppBadgePlus.updateBadge(0);
    bool supportAppBadge = await AppBadgePlus.isSupported();
    if (supportAppBadge) {
      await LocalStorage.clear(prefAlertCount);
    }
  }

  @override
  void initState() {
    _initState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      logWriterCallback: localLogWriter,
      theme: appTheme,
      supportedLocales: const [
        Locale('th', 'TH'),
        Locale('en', 'US'),
      ],
      locale: language == 0
        ? const Locale('th', 'TH'): const Locale('en', 'US'),
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialBinding: ControllerConfig(),
      builder: (context, child) {

        final scale = MediaQuery.textScalerOf(context).scale(1);
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(scale),
            ),
            child: child!,
          ),
        );
      },
      home: const SplashScreen(),
    );
  }

  void localLogWriter(String text, {bool isError = false}) {
    debugPrint("Log : " + text);
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}