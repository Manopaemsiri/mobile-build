import 'package:coffee2u/services/facebook_analytics.dart';
import 'package:coffee2u/services/tiktok_analytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class FirebaseAnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: _analytics);
  
  static final FacebookAppEvents _facebookAppEvents = FacebookAppEvents();
  static final TikTokAppEvents _tikTokAppEvents = TikTokAppEvents();
  
  FirebaseAnalyticsService();

  static Future<void> setAdvertiserTracking({bool value = true}) async {
    try {
      await _analytics.setAnalyticsCollectionEnabled(value);
      await _analytics.setConsent(adStorageConsentGranted: value, analyticsStorageConsentGranted: value);
      await _facebookAppEvents.setAdvertiserTracking(enabled: value);
      await _facebookAppEvents.setAutoLogAppEventsEnabled(value);
      await _tikTokAppEvents.setTrackingEnabled(value);
    } catch (e) {
      if(kDebugMode) print(e.toString());
    }
  }

  static Future<void> logEvent(String eventName, Map<String, Object>? parameters) async {
    try {
      _analytics.logEvent(name: eventName, parameters: parameters);
      _facebookAppEvents.logEvent(name: eventName, parameters: parameters);
      _tikTokAppEvents.logEvent(name: eventName, parameters: parameters);
    } catch (e) {
      if(kDebugMode) print(e.toString());
    }
  }
}