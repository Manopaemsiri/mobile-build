import 'dart:async';
import 'dart:convert';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils.dart';

class ApplicationLocalizations {
  Locale appLocale = Utils.appLocale;

  ApplicationLocalizations(this.appLocale);

  static ApplicationLocalizations? of(BuildContext context) {
    try {
      return Localizations.of<ApplicationLocalizations>(
          context, ApplicationLocalizations);
    } catch(e) {
      return null;
    }
  }

  late Map<String, String> _localizedStrings;

  Future<bool> load() async {
    final prefs = await SharedPreferences.getInstance();
    final temp = prefs.getInt(prefLocalLanguage);
    if (temp != null) {
      Utils.appLocale =
          temp == 0 ? const Locale('th', 'TH') : const Locale('en', 'US');
    }

    String jsonString = await rootBundle
        .loadString("assets/lang/${Utils.appLocale.languageCode}.json");
    Map<String, dynamic> jsonLanguageMap = json.decode(jsonString);
    _localizedStrings = jsonLanguageMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return true;
  }

  // called from every widget which needs a localized text
  String translate(String jsonkey) {
    return _localizedStrings[jsonkey] ?? "null";
  }
}
