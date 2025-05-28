import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FlutterFacebookAppLinks {
  static const MethodChannel widgetChannel = MethodChannel("com.coffee2u.aroma");

  static Future<String?> get platformVersion async {
    final String? version = await widgetChannel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> initFBLinks() async {
    try{
      var data = await widgetChannel.invokeMethod('initFBLinks');
      if(kDebugMode) print('Deferred FB Link: $data');
      return data ?? '';
    }catch(e){
      debugPrint("Error retrieving deferred deep link: $e");
      return '';
    }
  }

  static Future<String> getDeepLink() async {
    try{
      var data = await widgetChannel.invokeMethod('getDeepLinkUrl');
      if(kDebugMode) print('Deferred FB Link: $data');
      return data ?? '';
    }catch(e){
      debugPrint("Error retrieving deferred deep link: $e");
      return '';
    }
  }
}