import 'package:coffee2u/constants/app_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {

  static get(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
  static getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }
  static Future<List<String>?> getStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }
  static save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    if(value is bool){
      await prefs.setBool(key, value);
    }else{
      await prefs.setString(key, value);
    }
  }
  static saveBool(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    if(value is bool){
      await prefs.setBool(key, value);
    }
  }
  static saveStringList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
  }
  static clear(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static clearAll() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.deleteAll();
  }

  static getAccessToken() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    return await storage.read(key: localAccessToken);
  }
  static Future<void> saveAccessToken(value) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.write(key: localAccessToken, value: value);
  }
  static Future<void> clearAccessToken() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.delete(key: localAccessToken);
  }

  static getRefreshToken() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    return await storage.read(key: localRefreshToken);
  }
  static Future<void> saveRefreshToken(value) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.write(key: localRefreshToken, value: value);
  }
  static clearRefreshToken() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.delete(key: localRefreshToken);
  }

  static Future<bool> getSkipIntro() async {
    final prefs = await SharedPreferences.getInstance();
    final getSkip = prefs.getBool(prefSkipIntro);
    if(getSkip == null){
      return false;
    }else{
      return getSkip == true? true: false;
    }
  }
  
  static Future<int> getAlertCount() async {
    final prefs = await SharedPreferences.getInstance();
    String? countStr = prefs.getString(prefAlertCount);
    if(countStr == null || countStr == ''){
      return 0;
    }else{
      return int.parse(countStr);
    }
  }
}
