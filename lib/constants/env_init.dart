import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app_constants.dart';

class EnvInit{

  static init() async {
    // await dotenv.load(fileName: '.env_DEV');
    // await dotenv.load(fileName: '.env_DEV_UAT');
    await dotenv.load(fileName: '.env');

    appName = dotenv.get('APP_NAME', fallback: 'Coffee2U');
    appVersion = dotenv.get('APP_VERSION', fallback: '');
    
    firebaseMessagingKey = dotenv.get('FIREBASE_MESSAGING_KEY');
    cdnToken = dotenv.get('CDN_TOKEN');

    systemLanguages = (dotenv.env['SYSTEM_LANGUAGES'] ?? '').split(',');
    if(systemLanguages.isEmpty) systemLanguages.add('th');

    localAccessToken = dotenv.get('ACCESS_TOKEN');
    localRefreshToken = dotenv.get('REFRESH_TOKEN');

    apiUrl = dotenv.get('API_URL');
    cdnUrl = dotenv.get('CDN_URL');
    devProcess = dotenv.getBool('DEV_PROCESS', fallback: false);
    if(apiUrl.contains('api.aromacoffee2u')) devProcess = false;

    prefSkipIntro = dotenv.get('PREF_SKIP_INTRO', fallback: 'PREF_SKIP_INTRO');
    prefAlertCount = dotenv.get('PREF_ALERT_COUNT', fallback: 'PREF_ALERT_COUNT');
    prefLocalLanguage = dotenv.get('PREF_LOCAL_LANGUAGE', fallback: 'PREF_LOCAL_LANGUAGE');
    prefLanguage = dotenv.get('PREF_LANGUAGE', fallback: 'PREF_LANGUAGE');
    prefUsedCurrency = dotenv.get('PREF_USED_CURRENCY', fallback: 'PREF_USED_CURRENCY');
    prefAndroidNotification = dotenv.get('PREF_ANDROID_NOTIFICATION', fallback: 'PREF_ANDROID_NOTIFICATION');

    prefCustomerCashCoupon = dotenv.get('PREF_CUSTOMER_CASH_COUPON', fallback: '_CASH_COUPON');
    prefCustomerDiscountProduct = dotenv.get('PREF_CUSTOMER_DISCOUNT_PRODUCT', fallback: '_DISCOUNT_PRODUCT');
    prefCustomerShippingCoupon = dotenv.get('PREF_CUSTOMER_SHIPPING_COUPON', fallback: '_SHIPPING_COUPON');

    prefAppInstallRefferrer = dotenv.get('PREF_APP_INSTALL_REFERRER', fallback: 'PREF_APP_INSTALL_REFERRER');

    prefCustomer = dotenv.get('PREF_CUSTOMER', fallback: 'PREF_CUSTOMER');
    prefCustomerCart = dotenv.get('PREF_CUSTOMER_CART', fallback: 'PREF_CUSTOMER_CART');
    prefCustomerShippingAddress = dotenv.get('PREF_CUSTOMER_SHIPPING_ADDRESS', fallback: 'PREF_CUSTOMER_SHIPPING_ADDRESS');
    prefCustomerBillingAddress = dotenv.get('PREF_CUSTOMER_BILLING_ADDRESS', fallback: 'PREF_CUSTOMER_BILLING_ADDRESS');
    prefCustomerReview = dotenv.get('PREF_CUSTOMER_REVIEW', fallback: 'PREF_CUSTOMER_REVIEW');

    prefCheckoutPopup = dotenv.get('PREF_CHECKOUT_POPUP', fallback: 'PREF_CHECKOUT_POPUP');
  }
}