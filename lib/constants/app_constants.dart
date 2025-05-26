import 'package:flutter_secure_storage/flutter_secure_storage.dart';

String appName = 'Coffee2U';
String appVersion = '';
bool devProcess = false;

String firebaseMessagingKey = '';
String cdnToken = '';

// Create Storage
const storage = FlutterSecureStorage();
String localAccessToken = '';
String localRefreshToken = '';

// Languages
List<String> systemLanguages=['th'];

// URL Path
String apiUrl = "";
String cdnUrl = "";
                 
// Preference
String prefSkipIntro = '';
String prefAlertCount = '';
String prefLocalLanguage = '';
String prefLanguage = '';
String prefUsedCurrency = '';
String prefAndroidNotification = '';

String prefCustomerCashCoupon = '';
String prefCustomerDiscountProduct = '';
String prefCustomerShippingCoupon = '';

String prefAppInstallRefferrer = '';

String prefCustomer = '';
String prefCustomerCart = '';
String prefCustomerShippingAddress = '';
String prefCustomerBillingAddress = '';
String prefCustomerReview = '';

String prefCheckoutPopup = '';

// Default Image Path
const String defaultPath = 'assets/images/default.jpg';
const String defaultAvatar = 'assets/default/avatar-02.jpg';
const String coffeeMug = 'assets/icons/coffee_mug.png';
const String defaultPin = 'assets/default/pin.png';