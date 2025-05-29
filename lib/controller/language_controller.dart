import 'dart:convert';

import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/data/local_storage/local_storage.dart';
import 'package:coffee2u/models/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;

class LanguageController extends GetxController {
  String languageCode = "th";
  Map<String, String> lang = {};

  // Currency
  List<CurrencyModel> currencies = [];
  CurrencyModel? defaultCurrency;
  CurrencyModel? usedCurrency;

  Future<void> initData({String? code}) async {
    String? fromStorage = await LocalStorage.get(prefLanguage);
    languageCode = systemLanguages.length > 1? (fromStorage ?? systemLanguages[0]):  systemLanguages[0];
    if(code != null) languageCode = code;
    refreshData(code: languageCode);
  }

  Future<void> refreshData({String code="th"}) async {
    languageCode = code.toLowerCase();
    await LocalStorage.save(prefLanguage, languageCode);

    // Set Timezone
    Intl.defaultLocale = languageCode;
    initializeDateFormatting();
    tz.initializeTimeZones();

    Get.updateLocale(Locale(code));
    
    // fontFamily = fontFamilies[code] ?? "Roboto";
    // API
    Map<String, dynamic> input = {
      "dataFilter": {
        "lang": languageCode.toUpperCase()
      }
    };
    var data1 = await http.post(Uri.parse('${apiUrl}frontend/languages'),
    headers: {'Content-Type': 'application/json; charset=UTF-8',}, body: jsonEncode(input));
    Map<String , dynamic> decode = json.decode(data1.body);
    lang =  Map<String, String>.from(decode["data"]["result"]);

    if(currencies.isEmpty) await updateCurrency(input: input);
    update();
  }

  Future<void> updateCurrency({String? currency, Map<String, dynamic> input = const {}}) async {
    if(currencies.isEmpty){
      var data2 = await http.post(
        Uri.parse('${apiUrl}frontend/currencies'),
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: jsonEncode(input),
      );
      currencies = [];
      try {
        final decode2 = jsonDecode(data2.body);
        if(decode2.isNotEmpty){
          final length = decode2?["data"]?["result"]?.length ?? 0;
          for (var i = 0; i < length; i++) {
            CurrencyModel model = CurrencyModel.fromJson(decode2?["data"]?["result"][i]);
            currencies.add(model);
          }
        }
        defaultCurrency = currencies.firstWhereOrNull((e) => e.isDefault == 1);
        final prefCurrency = await LocalStorage.get(prefUsedCurrency);
        if(prefCurrency == null) {
          usedCurrency = defaultCurrency;
        } else {
          final currencyKey = currencyModelFromJson(prefCurrency);
          final index = currencies.indexWhere((e) => e.code.toLowerCase() == currencyKey.code.toLowerCase());
          if(index > -1) {
            usedCurrency = currencies[index];
            if(usedCurrency != null) await LocalStorage.save(prefUsedCurrency, currencyModelToJson(usedCurrency!));
          }
        }
        if(usedCurrency != null) await LocalStorage.save(prefUsedCurrency, currencyModelToJson(usedCurrency!));
      } catch (e) {
        if(kDebugMode) printError(info: '$e');
      }
    }
    if(currency != null){
      final index = currencies.indexWhere((e) => e.code.toLowerCase() == currency.toLowerCase());
      if(index > -1) {
        usedCurrency = currencies[index];
        if(usedCurrency != null) await LocalStorage.save(prefUsedCurrency, currencyModelToJson(usedCurrency!));
      }
    }
    update();
  }

  String getLang(String key) {
    var unescape = HtmlUnescape();
    String cleanKey = key.toLowerCase();
    if(lang[cleanKey] == null){
      // final Map<String, String> input = { "key": key };
      // ApiService.processCreate("language", input: input);
      return key;
    }else {
      return lang[cleanKey] != null? unescape.convert(lang[cleanKey]!): key;
    }
  }


  Future<void> clearAll() async {
    update();
  }
}