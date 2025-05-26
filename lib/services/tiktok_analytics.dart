import 'dart:async';

import 'package:flutter/services.dart';

class TikTokAppEvents {
  static const _channel = MethodChannel('com.coffee2u.aroma');

  static const eventNameAdImpression = 'AdImpression';
  static const eventNameAdClick = 'AdClick';

  static const _paramNameValueToSum = '_valueToSum';
  static const paramNameAdType = 'tt_ad_type';

  static const String _logEventName = 'tiktokLogEvent';
  static const String _setTrackingEnabledName = 'setTrackingEnabled';
  static const String _logPushNotificationOpenName = 'logPushNotificationOpen';
  static const String _setAdvertiserTrackingName = 'setAdvertiserTracking';
  static const String _setUserDataName = 'setUserData';
  
  /// Clears the current user data
  Future<void> clearUserData() =>
    _channel.invokeMethod<void>('clearUserData');

  Future<void> setUserData({
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? dateOfBirth,
    String? gender,
    String? city,
    String? state,
    String? zip,
    String? country,
  }) {
    final args = <String, dynamic>{
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
    };

    return _channel.invokeMethod<void>(_setUserDataName, args);
  }

  /// Clears the currently set user id.
  Future<void> clearUserID() =>
    _channel.invokeMethod<void>('clearUserID');

  /// Explicitly flush any stored events to the server.
  Future<void> flush() =>
    _channel.invokeMethod<void>('flush');

  /// Returns the app ID this logger was configured to log to.
  Future<String?> getApplicationId() =>
    _channel.invokeMethod<String>('getApplicationId');

  Future<String?> getAnonymousId() =>
    _channel.invokeMethod<String>('getAnonymousId');

  /// Log an app event with the specified [name] and the supplied [parameters] value.
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
    double? valueToSum,
  }) {
    final args = <String, dynamic>{
      'name': name,
      _paramNameValueToSum: valueToSum,
    };

    if (parameters != null) {
      args['parameters'] = _filterOutNulls(parameters);
    }
    return _channel.invokeMethod<void>(_logEventName, _filterOutNulls(args));
  }

  /// Logs an app event that tracks that the application was open via Push Notification.
  static Future<void> logPushNotificationOpen({
    required Map<String, dynamic> payload,
    String? action,
  }) {
    final args = <String, dynamic>{
      'payload': payload,
      'action': action,
    };

    return _channel.invokeMethod<void>(_logPushNotificationOpenName, args);
  }

  Future<void> setTrackingEnabled(bool enabled) => 
    _channel.invokeMethod<void>(_setTrackingEnabledName, enabled);

  static Future<void> setAdvertiserTracking({
    required bool enabled,
    bool collectId = true,
  }) {
    final args = <String, dynamic>{
      'enabled': enabled,
      'collectId': collectId,
    };

    return _channel.invokeMethod<void>(_setAdvertiserTrackingName, args);
  }

  /// Log this event when the user views an ad.
  Future<void> logAdImpression({
    required String adType,
  }) => logEvent(
    name: eventNameAdImpression,
    parameters: {
      paramNameAdType: adType,
    },
  );

  /// Log this event when the user clicks an ad.
  Future<void> logAdClick({
    required String adType,
  }) => logEvent(
    name: eventNameAdClick,
    parameters: {
      paramNameAdType: adType,
    },
  );

  static Map<String, dynamic> _filterOutNulls(Map<String, dynamic> parameters) {
    final Map<String, dynamic> filtered = <String, dynamic>{};
    parameters.forEach((String key, dynamic value) {
      if (value != null) {
        filtered[key] = value;
      }
    });
    return filtered;
  }
}