import 'package:flutter/material.dart';

const MaterialColor appColor =
    MaterialColor(_appColorPrimaryValue, <int, Color>{
  50: Color(0xFFF8E2E5),
  100: Color(0xFFEFB7BF),
  200: Color(0xFFE48794),
  300: Color(0xFFD95669),
  400: Color(0xFFD03248),
  500: Color(_appColorPrimaryValue),
  600: Color(0xFFC20C24),
  700: Color(0xFFBB0A1E),
  800: Color(0xFFB40818),
  900: Color(0xFFA7040F),
});
const int _appColorPrimaryValue = 0xFFC80E28;

const MaterialColor appColorAccent =
    MaterialColor(_appColorAccentValue, <int, Color>{
  100: Color(0xFFFFD1D3),
  200: Color(_appColorAccentValue),
  400: Color(0xFFFF6B71),
  700: Color(0xFFFF5258),
});
const int _appColorAccentValue = 0xFFFF9EA2;
