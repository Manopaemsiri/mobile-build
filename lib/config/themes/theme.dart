import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/* -------------------------------------------------------------------------- */
/*                              default app theme                             */
/* -------------------------------------------------------------------------- */
ThemeData appTheme = ThemeData(
  primarySwatch: appColor,
  fontFamily: "Kanit",
  useMaterial3: false,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.light, // status bar icon color in iOS.
      statusBarIconBrightness: Brightness.dark, // in Android.
      systemNavigationBarColor: Colors.transparent,
    ),
    color: Colors.white,
    foregroundColor: kDarkColor,
    centerTitle: true,
    elevation: 0,
  ),
  scaffoldBackgroundColor: kWhiteSmokeColor,
  // scaffoldBackgroundColor: kWhiteColor,
);
