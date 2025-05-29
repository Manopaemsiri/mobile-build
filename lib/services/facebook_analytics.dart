import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class FacebookAppEvents {
  static const widgetChannel = MethodChannel("com.coffee2u.aroma");

  // See: https://github.com/facebook/facebook-android-sdk/blob/master/facebook-core/src/main/java/com/facebook/appevents/AppEventsConstants.java
  static const eventNameCompletedRegistration =
      'fb_mobile_complete_registration';
  static const eventNameViewedContent = 'fb_mobile_content_view';
  static const eventNameRated = 'fb_mobile_rate';
  static const eventNameInitiatedCheckout = 'fb_mobile_initiated_checkout';
  static const eventNameAddedToCart = 'fb_mobile_add_to_cart';
  static const eventNameAddedToWishlist = 'fb_mobile_add_to_wishlist';
  static const eventNameSubscribe = "Subscribe";
  static const eventNameStartTrial = "StartTrial";
  static const eventNameAdImpression = "AdImpression";
  static const eventNameAdClick = "AdClick";

  static const _paramNameValueToSum = "_valueToSum";
  static const paramNameAdType = "fb_ad_type";
  static const paramNameCurrency = "fb_currency";
  static const paramNameOrderId = "fb_order_id";
  static const paramNameRegistrationMethod = "fb_registration_method";
  static const paramNamePaymentInfoAvailable = "fb_payment_info_available";
  static const paramNameNumItems = "fb_num_items";
  static const paramValueYes = "1";
  static const paramValueNo = "0";

  static const paramNameContentType = "fb_content_type";
  static const paramNameContent = "fb_content";
  static const paramNameContentId = "fb_content_id";

  Future<void> clearUserData() 
    => widgetChannel.invokeMethod<void>('clearUserData');

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

    return widgetChannel.invokeMethod<void>('setUserData', args);
  }

  Future<void> clearUserID() 
    => widgetChannel.invokeMethod<void>('clearUserID');

  Future<void> flush() 
    => widgetChannel.invokeMethod<void>('flush');

  Future<String?> getApplicationId() 
    => widgetChannel.invokeMethod<String>('getApplicationId');

  Future<String?> getAnonymousId() {
    return widgetChannel.invokeMethod<String>('getAnonymousId');
  }

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

    return widgetChannel.invokeMethod<void>('logEvent', _filterOutNulls(args));
  }

  static Future<void> logPushNotificationOpen({
    required Map<String, dynamic> payload,
    String? action,
  }) {
    final args = <String, dynamic>{
      'payload': payload,
      'action': action,
    };

    return widgetChannel.invokeMethod<void>('logPushNotificationOpen', args);
  }

  Future<void> setUserID(String id) 
    => widgetChannel.invokeMethod<void>('setUserID', id);

  Future<void> logCompletedRegistration({String? registrationMethod}) 
    => logEvent(
    name: eventNameCompletedRegistration,
    parameters: {
      paramNameRegistrationMethod: registrationMethod,
    },
  );

  Future<void> logRated({double? valueToSum}) 
    => logEvent(
    name: eventNameRated,
    valueToSum: valueToSum,
  );

  Future<void> logViewContent({
    Map<String, dynamic>? content,
    String? id,
    String? type,
    String? currency,
    double? price,
  }) {
    return logEvent(
      name: eventNameViewedContent,
      parameters: {
        paramNameContent: content != null ? json.encode(content) : null,
        paramNameContentId: id,
        paramNameContentType: type,
        paramNameCurrency: currency,
      },
      valueToSum: price,
    );
  }

  Future<void> logAddToCart({
    Map<String, dynamic>? content,
    required String id,
    required String type,
    required String currency,
    required double price,
  }) {
    return logEvent(
      name: eventNameAddedToCart,
      parameters: {
        paramNameContent: content != null ? json.encode(content) : null,
        paramNameContentId: id,
        paramNameContentType: type,
        paramNameCurrency: currency,
      },
      valueToSum: price,
    );
  }

  Future<void> logAddToWishlist({
    Map<String, dynamic>? content,
    required String id,
    required String type,
    required String currency,
    required double price,
  }) {
    return logEvent(
      name: eventNameAddedToWishlist,
      parameters: {
        paramNameContent: content != null ? json.encode(content) : null,
        paramNameContentId: id,
        paramNameContentType: type,
        paramNameCurrency: currency,
      },
      valueToSum: price,
    );
  }

  Future<void> setAutoLogAppEventsEnabled(bool enabled) =>
    widgetChannel.invokeMethod<void>('setAutoLogAppEventsEnabled', enabled);

  Future<void> setDataProcessingOptions(
    List<String> options, {
    int? country,
    int? state,
  }) {
    final args = <String, dynamic>{
      'options': options,
      'country': country,
      'state': state,
    };

    return widgetChannel.invokeMethod<void>('setDataProcessingOptions', args);
  }

  Future<void> logPurchase({
    required double amount,
    required String currency,
    Map<String, dynamic>? parameters,
  }) {
    final args = <String, dynamic>{
      'amount': amount,
      'currency': currency,
      'parameters': parameters,
    };
    return widgetChannel.invokeMethod<void>('logPurchase', _filterOutNulls(args));
  }

  Future<void> logInitiatedCheckout({
    double? totalPrice,
    String? currency,
    String? contentType,
    String? contentId,
    int? numItems,
    bool paymentInfoAvailable = false,
  }) {
    return logEvent(
      name: eventNameInitiatedCheckout,
      valueToSum: totalPrice,
      parameters: {
        paramNameContentType: contentType,
        paramNameContentId: contentId,
        paramNameNumItems: numItems,
        paramNameCurrency: currency,
        paramNamePaymentInfoAvailable:
            paymentInfoAvailable ? paramValueYes : paramValueNo,
      },
    );
  }

  /// Sets the Advert Tracking propeety for iOS advert tracking
  /// an iOS 14+ feature, android should just return a success.
  Future<void> setAdvertiserTracking({
    required bool enabled,
    bool collectId = true,
  }) {
    final args = <String, dynamic>{
      'enabled': enabled,
      'collectId': collectId,
    };
      // case "setAutoLogAppEventsEnabled":
      // case "setAdvertiserTracking":
    return widgetChannel.invokeMethod<void>('setAdvertiserTracking', args);
  }

  Future<void> logSubscribe({
    double? price,
    String? currency,
    required String orderId,
  }) {
    return logEvent(
      name: eventNameSubscribe,
      valueToSum: price,
      parameters: {
        paramNameCurrency: currency,
        paramNameOrderId: orderId,
      },
    );
  }

  Future<void> logStartTrial({
    double? price,
    String? currency,
    required String orderId,
  }) => logEvent(
    name: eventNameStartTrial,
    valueToSum: price,
    parameters: {
      paramNameCurrency: currency,
      paramNameOrderId: orderId,
    },
  );

  Future<void> logAdImpression({
    required String adType,
  }) => logEvent(
    name: eventNameAdImpression,
    parameters: {
      paramNameAdType: adType,
    },
  );

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