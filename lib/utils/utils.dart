import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/data/local_storage/local_storage.dart';
import 'package:coffee2u/services/firebase_analytics_service.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class Utils {
  static LanguageController lController = Get.find<LanguageController>();

  static Locale appLocale = const Locale("th", "TH");
  static late BuildContext globalContext;

  static String translate(String text, {BuildContext? context}) {
    return ApplicationLocalizations.of(context ?? globalContext)?.translate(text) ?? '';
  }

  /// return bool เช็คว่าเป็นตัวเลขหรือไม่ [0-9]
  static bool isNumeric(String str) {
    RegExp dataNumeric = RegExp(r'^-?[0-9]+$');
    return dataNumeric.hasMatch(str);
  }

  /// return ตัวเลขแบบมีคอมม่า (,) เช่น 10,000
  static String numberComma(dynamic number) {
    if (number == null) {
      return '-';
    }
    if (number is String) {
      if (double.tryParse(number) != null) {
        number = double.parse(number);
        assert(number is double);
      } else {
        return number;
      }
    }
    return NumberFormat("#,###,###.##").format(number);
  }

  /// return int จำนวนวัน (from - to = result)
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  // return เวลา เช่น "เมื่อ 20 นาที ที่แล้ว"
  static String timeAgo(DateTime? dateTime) {
    final dataDateTime = dateTime;
    if (dataDateTime != null) {
      if (daysBetween(dataDateTime, DateTime.now()) > 3) {
        return dateFormat(dataDateTime, format: 'd MMMM y');
      }
      return timeago.format(dataDateTime, locale: 'th');
    }
    return "";
  }

  static bool isContainSpecialChar(String str) {
    for(var i = 0; i < str.length; i++){
      if(['*','!','@','#','\$','&','?','%','^','(',')'].contains(str[i])){
        return true;
      }
    }
    return false;
  }


  // Validations
  static String? validateString(String? value, {String? title}) {
    if(value == null || value.isEmpty){
      return "${lController.getLang("text_error_required_1")} ${title ?? ""}";
    }
    return null;
  }
  static String? validateEmail(String? value, {bool isRequired = false}) {
    if(value == null || value.isEmpty){
      return isRequired? lController.getLang("text_error_required_1"): null;
    }else if(
      !RegExp(
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'
      ).hasMatch(value)
    ){
      return lController.getLang("text_error_email_1");
    }
    return null;
  }
  static String? validatePassword(String? password, String? password2, int sequence) {
    if(sequence == 1){
      if(password == null || password.isEmpty){
        return lController.getLang("text_error_required_1");
      }else if(password.length < 6){
        return '${lController.getLang('At least')} 6 ${lController.getLang('characters')}';
      }else if(!password.contains(RegExp(r'[0-9]'))){
        return '${lController.getLang('Number')} 0-9 ${lController.getLang('At least')} 1 ${lController.getLang('characters')}';
      }else if(!isContainSpecialChar(password)){
        return '${lController.getLang('Symbol')}  * ! @ # \$ & ? % ^ ( ) ${lController.getLang('At least')} 1 ${lController.getLang('characters')}';
      }
    }else if(sequence == 2){
      if(password2 == null || password2.isEmpty){
        return lController.getLang("text_error_required_1");
      }else if(password2.length < 6){
        return '${lController.getLang('At least')} 6 ${lController.getLang('characters')}';
      }else if(!password2.contains(RegExp(r'[0-9]'))){
        return '${lController.getLang('Number')} 0-9 ${lController.getLang('At least')} 1 ${lController.getLang('characters')}';
      }else if(!isContainSpecialChar(password2)){
        return '${lController.getLang('Symbol')} * ! @ # \$ & ? % ^ ( ) ${lController.getLang('At least')} 1 ${lController.getLang('characters')}';
      }
    }

    if(password != password2){
      return lController.getLang('text_error_password_1');
    }
    return null;
  }
  static String? validatePhone(String? value) {
    if(value == null || value.isEmpty){
      return lController.getLang("text_error_telephone_1");
    }else if (value.length < 10){
      return lController.getLang("text_error_telephone_2");
    }else if (!isNumeric(value)){
      return lController.getLang("text_error_telephone_3");
    }
    return null;
  }

  static Widget tagTextComingSoon(String text, Color textColor, Color textBgColor) {
    return Container(
      width: 88, height: 88,
      padding: const EdgeInsets.all(kQuarterGap),
      color: kWhiteColor.withValues(alpha: 0.45),
      child: Center(
        child: Text(
          'Coming\nSoon',
          textAlign: TextAlign.center,
          style: subtitle2.copyWith(
            color: kDarkColor,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            height: 1.05,
          ),
        ),
      ),
    );
  }
  
  static Widget tagText(String text, Color textColor, Color textBgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kQuarterGap),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: textBgColor,
      ),
      child: Text(
        text,
        style: caption.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  
  static Widget? tagImage(String iconPath) {
    if(iconPath.isEmpty){
      return null;
    }else{
      return ImageProduct(
        imageUrl: iconPath,
        width: 35, height: 35,
        decoration: const BoxDecoration(),
        fit: BoxFit.contain,
        alignment: Alignment.topLeft,
      );
    }
  }

  static Future<void> appReferrrer() async {
    final resRef1 = await LocalStorage.get(prefAppInstallRefferrer);
    if(resRef1 == null || resRef1?.isEmpty == true){
      String resRef = "";
      // Get referrer following platform
      if(Platform.isIOS) {
        final Uri? initialLink = await AppLinks().getInitialLink();
        resRef = initialLink?.path ?? '';
        if(resRef.isEmpty){
          const MethodChannel widgetChannel = MethodChannel('com.coffee2u.aroma');
          const String installReferrer = "app_install_referrer";
          resRef = await widgetChannel.invokeMethod(installReferrer).timeout(const Duration(seconds: 5), onTimeout: () async {
            if(kDebugMode) print("ERROR : Install referrer time out");
            await LocalStorage.clear(prefAppInstallRefferrer);
          });
        }
      }else{
        const MethodChannel widgetChannel = MethodChannel('com.coffee2u.aroma');
        const String installReferrer = "app_install_referrer";
        try {
          resRef = await widgetChannel.invokeMethod(installReferrer).timeout(const Duration(seconds: 5), onTimeout: () async {
            if(kDebugMode) print("ERROR : Install referrer time out");
            await LocalStorage.clear(prefAppInstallRefferrer);
          });
        } catch (e) {
          if(kDebugMode) print(e.toString());
        }
      }

      // Saved
      await LocalStorage.save(prefAppInstallRefferrer, resRef);
      if(kDebugMode) print("SUCCESS : Install referrer saved");
      try {
        Map<String, dynamic> input = {};
        if(Uri.parse(resRef).isAbsolute){
          Uri uri = Uri.parse(Uri.decodeFull(resRef));
          Map<String, String> parameters = uri.queryParameters;
          String ref = parameters['referrer'] ?? '';
          if(ref.isNotEmpty){
            final List<String> widgetList = ref.split('&');
            for (var item in widgetList) {
              List<String> it = item.split('=');
              if(it.isNotEmpty) input[it[0]] = Uri.decodeFull(it[1]);
            }
          }else {
            parameters.forEach((key, value) {
              input[key] = Uri.decodeFull(value);
            });
          }
        }else {
          if(resRef.isNotEmpty){
            final List<String> widgetList = resRef.split('&');
            for (var item in widgetList) {
              List<String> it = item.split('=');
              if(it.isNotEmpty) input[it[0]] = Uri.decodeFull(it[1]);
            }
          }
        }
        
        Map<String, Object> input2 = {};
        input.forEach((key, value) {
          if(key.toLowerCase() == "idfa"){
            input2["device_id_macro"] = value;
          }else if(key.toLowerCase() == "cs" || key.toLowerCase() == "utm_source") {
            input2["utm_source"] = value;
          }else if(key.toLowerCase() == "cm" || key.toLowerCase() == "utm_medium") {
            input2["utm_medium"] = value;
          }else if(key.toLowerCase() == "ck" || key.toLowerCase()  == "utm_term") {
            input2["utm_term"] = value;
          }else if(key.toLowerCase() == "cc" || key.toLowerCase() == "utm_content") {
            input2["utm_content"] = value;
          }else if(key.toLowerCase() == "cn" || key.toLowerCase() == "utm_campaign") {
            input2["utm_campaign"] = value;
          }else {
            input2[key] = value;
          }
        });
        if(resRef.isNotEmpty) input2["referrer"] = Uri.decodeFull(resRef);
        if(input2.isEmpty){
          await LocalStorage.save(prefAppInstallRefferrer, "Referrer URL is empty");
        }
        input2["platform"] = Platform.isIOS? 'IOS': 'Android';
        await FirebaseAnalyticsService.logEvent('app_install_referrer', input2);
      } catch (e) {
        final Map<String, Object> input = {
          "platform": Platform.isIOS? 'IOS': 'Android',
          "referrer": resRef,
        };
        if(resRef.isNotEmpty) input["referrer"] = Uri.decodeFull(resRef);
        await FirebaseAnalyticsService.logEvent('app_install_referrer', input);
        if(kDebugMode) print(e);
      }
    }
  }
}