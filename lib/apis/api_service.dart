// ignore_for_file: constant_identifier_names
import 'dart:convert';
import 'dart:developer';
import 'package:coffee2u/apis/api_data.dart';
import 'package:coffee2u/apis/res_api_auth.dart';
import 'package:coffee2u/apis/res_api_error.dart';
import 'package:coffee2u/apis/res_api_read.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/firebase_controller.dart';
import 'package:coffee2u/data/local_storage/local_storage.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/auth/sign_in/sign_in_menu_screen.dart';
import 'package:coffee2u/services/notification_service.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart' as dio;

const API_CUSTOMER_PATHS = [
  'signout',
  'request-to-delete',
  'cart',
  'chatroom',
  'account',
  'password',
  'tier',
  'points',
  'total-points',
  'seller-shop-rating',
  'frequently-bought-products',
  'favorite-products',
  'favorite-product',
  'shipping-addresses',
  'shipping-address',
  'shipping-address-get-selected',
  'shipping-address-set-selected',
  'my-partner-product-coupons',
  'my-partner-product-coupon',
  'redeem-partner-product-coupons',
  'redeem-partner-product-coupon',
  'my-partner-product-coupon-logs',
  'my-partner-shipping-coupons',
  'my-partner-shipping-coupon',
  'my-partner-shipping-coupon-logs',
  'redeem-partner-shipping-coupons',
  'redeem-partner-shipping-coupon',
  'fcm-token',
  'orders',
  'order',
  'billing-addresses',
  'billing-address',
  'billing-address-get-selected',
  'billing-address-set-selected',
  'checkout-partner-product-coupons',
  'checkout-partner-cash-coupons',
  'checkout-partner-shipping-coupons',
  'checkout-shipping-methods',
  'checkout-payment-methods',
  'checkout-click-and-collect-shipping-methods',
  'checkout-partner-cash-coupon',
  'checkout-partner-product-coupon',
  'checkout-partner-shipping-coupon',
  'checkout-shipping-method-coupons',
  'group',
  'partner-product-rating',
  'order-rating',
  'subscriptions',
  'subscription',
  'subscription-cart',
  'subscription-shipping-methods',
  'subscription-click-and-collect-shipping-methods',
  'subscription-payment-2c2p',
  'subscription-plans',
];

class ApiService {

  static Future<bool> authSignin({Map<String, dynamic> input = const {}}) async {
    log("API CALL: Auth Signin");
    ShowDialog.showLoadingDialog();
    final lCode = await LocalStorage.get(prefLanguage) ?? 'th';
    try {
      var data1 = await http.post(Uri.parse('${apiUrl}auth/customer-signin'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(input));
      if ([200, 201, 204].contains(data1.statusCode)) {
        final res1 = ResApiAuth.fromJson(jsonDecode(data1.body));

        if (res1.data?.user != null) {
          final CustomerController _customerController = Get.find<CustomerController>();
          await _customerController.clear();

          await LocalStorage.saveAccessToken(res1.data?.accessToken); 
          await LocalStorage.saveRefreshToken(res1.data?.refreshToken);
          
          final _shopId = res1.data?.user?.partnerShop?.id;
          await _customerController.updateCustomer(res1.data?.user);
          if (_customerController.isCustomer()) {
            final FirebaseController _firebaseController = Get.find<FirebaseController>();
            _firebaseController.updateChatrooms(res1.data?.user?.id ?? '');
            _firebaseController.updateOrderStatuses(res1.data?.user?.id ?? '');
            
            final resPartnerShop = await processRead('partner-shop', input: { '_id': _shopId });
            PartnerShopModel? partnerShop = resPartnerShop?['result'].isNotEmpty == true? PartnerShopModel.fromJson(resPartnerShop?['result']): null;

            //String fcmToken = await NotificationService.getFcmToken();
            //res1.data?.user?.fcmToken = fcmToken;
            //await processUpdate('fcm-token', input: { "fcmToken": fcmToken });
            await _customerController.updateCustomer(res1.data?.user, value: partnerShop);
            await _customerController.updateFavoriteProducts();
          }

          CustomerShippingAddressModel? address;
          var data2 = await http.get(
              Uri.parse('${apiUrl}customer/shipping-address-get-selected?lang=${systemLanguages.length > 1
                ? lCode.toUpperCase()
                : systemLanguages[0].toUpperCase()}'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer ${res1.data?.accessToken}'
              });
          if ([200, 201, 204].contains(data2.statusCode)) {
            var res2 = jsonDecode(data2.body);
            if (res2!['data']['result'] != null) {
              address =
                  CustomerShippingAddressModel.fromJson(res2['data']['result']);
            }
          }
          await _customerController.updateShippingAddress(address);

          CustomerCartModel? cart;
          var data3 = await http.get(
            Uri.parse('${apiUrl}customer/cart?lang=${systemLanguages.length > 1
              ? lCode.toUpperCase()
              : systemLanguages[0].toUpperCase()}'),
            headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${res1.data?.accessToken}'
          });
          if ([200, 201, 204].contains(data3.statusCode)) {
            var res3 = jsonDecode(data3.body);
            if (res3!['data']['result'] != null) {
              cart = CustomerCartModel.fromJson(res3['data']['result']);
            }
          }
          await _customerController.updateCart(cart);

          CustomerBillingAddressModel? billingAddress;
          var data4 = await http.get(
              Uri.parse('${apiUrl}customer/billing-address-get-selected?lang=${systemLanguages.length > 1
                ? lCode.toUpperCase()
                : systemLanguages[0].toUpperCase()}'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer ${res1.data?.accessToken}'
              });
          if ([200, 201, 204].contains(data4.statusCode)) {
            var res4 = jsonDecode(data4.body);
            if (res4!['data']['result'] != null) {
              billingAddress =
                  CustomerBillingAddressModel.fromJson(res4['data']['result']);
            }
          }
          await _customerController.updateBillingAddress(billingAddress);

          Get.back();
          await Future.delayed(const Duration(milliseconds: 100));
          return true;
        } else {
          Get.back();
        }
      } else {
        Get.back();
        final res1 = ResApiError.fromJson(jsonDecode(data1.body)).error;
        String dialogTitle = "Error";
        String dialogDesc = res1?.errorText() ?? '';
        if(res1?.errorText()?.contains('Account associated') == true) {
          dialogTitle = "Incorrect information";
          dialogDesc = "text_error_sign_in_1";
        }
        ShowDialog.showForceDialog(dialogTitle, dialogDesc, () => Get.back());
      }

      return false;
    } catch (e) {
      Get.back();
      ShowDialog.showForceDialog("Error", "$e", () => Get.back());
      if (kDebugMode) log('$e');
      throw Exception(e);
    }
  }

  static Future<bool> authSignup({Map<String, dynamic> input = const {}, bool isScan = false}) async {
    log("API CALL: Auth Signup");
    ShowDialog.showLoadingDialog();
    try {
      var data1 = await http.post(Uri.parse('$apiUrl${isScan? 'auth/customer-signup-with-info': 'auth/customer-signup'}'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(input));

      Get.back();
      if ([200, 201, 204].contains(data1.statusCode)) {
        return await ApiService.authSignin(input: {
          "username": input["telephone"] ?? input["email"] ?? input["username"],
          "password": input["password"]
        });
      } else {
        final res1 = ResApiError.fromJson(jsonDecode(data1.body)).error;
        final temp = res1?.errorText();
        ShowDialog.showForceDialog("Incorrect information", "$temp", () => Get.back());
      }

      return false;
    } catch (e) {
      Get.back();
      ShowDialog.showForceDialog("Error", "$e", () => Get.back());
      if (kDebugMode) log('$e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> sendOTP({ required String telephoneCode, required String telephone }) async {
    final lCode = await LocalStorage.get(prefLanguage) ?? 'th';
    String endpoint = 'auth/send-otp';
    Map<String, String> apiHeader = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    try {
      Map<String, dynamic> input = {
        'telephoneCode': telephoneCode,
        'telephone': telephone,
        'lang': systemLanguages.length > 1? lCode.toUpperCase(): systemLanguages[0].toUpperCase()
      };

      var data1 = await http.post(Uri.parse('$apiUrl$endpoint'),
          headers: apiHeader, body: jsonEncode(input));
      Map<String, dynamic> res = json.decode(data1.body);

      return res['data'] ?? {};
    }catch (e){
      if (kDebugMode) log("API ERROR: $e");
      return json.decode(e.toString());
    }
  }
  static Future<Map<String, dynamic>?> verifyOTP({ required Map<String, dynamic> input }) async {
    final lCode = await LocalStorage.get(prefLanguage) ?? 'th';
    String endpoint = 'auth/verify-otp';
    Map<String, String> apiHeader = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    ShowDialog.showLoadingDialog();

    try {
      Map<String, dynamic> _input = input;
      _input['lang'] = systemLanguages.length > 1? lCode.toUpperCase(): systemLanguages[0].toUpperCase();

      var data1 = await http.post(Uri.parse('$apiUrl$endpoint'),
          headers: apiHeader, body: jsonEncode(_input));
      Map<String, dynamic> res = json.decode(data1.body);
      Get.back();
      if(res['error']?.isNotEmpty == true){
        ShowDialog.showForceDialog("Error", res['error']['system'] ?? 'Incorrect code"', () => Get.back());
        return null;
      }else{
        return res['data'] ?? {};
      }
    }catch (e){
      if (kDebugMode) log("API ERROR: $e");
      return json.decode(e.toString());
    }
  }
  static Future<Map<String, dynamic>?> customerForgetPassword({Map<String, dynamic> input = const {}}) async {
    log("API CALL: Auth Signup");
    ShowDialog.showLoadingDialog();
    try {
      var data1 = await http.post(Uri.parse('${apiUrl}auth/customer-forget-password'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(input));
      Get.back();
      if ([200, 201, 204].contains(data1.statusCode)) {
          return jsonDecode(data1.body);
      } else {
        final res1 = ResApiError.fromJson(jsonDecode(data1.body)).error;
        final temp = res1?.errorText();
        ShowDialog.showForceDialog("Error", "$temp", () => Get.back());
      }

      return jsonDecode(data1.body);
    } catch (e) {
      Get.back();
      ShowDialog.showForceDialog("Error", "$e", () => Get.back());
      if (kDebugMode) log('$e');
      return {};
    }
  }

  static Future<bool> customerResetPassword({Map<String, dynamic> input = const {}}) async {
    log("API CALL: Auth Signup");
    ShowDialog.showLoadingDialog();
    try {
      var data1 = await http.patch(Uri.parse('${apiUrl}auth/customer-reset-password'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(input));
      Get.back();
      if ([200, 201, 204].contains(data1.statusCode)) {
          return true;
      } else {
        final res1 = ResApiError.fromJson(jsonDecode(data1.body)).error;
        final temp = res1?.errorText();
        ShowDialog.showForceDialog("Error", "$temp", () => Get.back());
      }

      return false;
    } catch (e) {
      Get.back();
      ShowDialog.showForceDialog("Error", "$e", () => Get.back());
      if (kDebugMode) log('$e');
      return false;
    }
  }

  static Future<bool> customerCheckDuplicate({Map<String, dynamic> input = const {}}) async {
    log("API CALL: Customer Check Duplicate");
    ShowDialog.showLoadingDialog();
    try {
      var data1 = await http.post(
          Uri.parse('${apiUrl}auth/customer-check-duplicate'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(input));

      Get.back();
      if ([200, 201, 204].contains(data1.statusCode)) {
        final res1 = jsonDecode(data1.body);
        if (res1["data"] == true) {
          ShowDialog.showForceDialog(
              "โปรดตรวจสอบข้อมูล", res1["message"], () => Get.back());
          return true;
        }
      }

      return false;
    } catch (e) {
      Get.back();
      ShowDialog.showForceDialog("Error", "$e", () => Get.back());
      if (kDebugMode) log('$e');
      return true;
    }
  }


  static authSignout() async {
    log("API CALL: Auth Signout");
    try {
      final FirebaseController _firebaseController = Get.find<FirebaseController>();
      _firebaseController.updateChatrooms(null);
      _firebaseController.updateOrderStatuses(null);
      // Sign Out Social
      // await FacebookAuth.instance.logOut();
      // Sign Out Firebase
      // await FirebaseAuth.instance.signOut();

      await processUpdate("signout");
    } catch (e) {
      if (kDebugMode) log("API ERROR: $e");
      throw Exception(e);
    }

    final CustomerController _customerController = Get.find<CustomerController>();
    await AppHelpers.clearAllCoupons(_customerController.customerModel?.id ?? '');
    await _customerController.clear();
    await _customerController.syncData();
    Get.offAll(() => const SignInMenuScreen(
      isFirstState: true,
    ));
  }

  static Future<Map<String, dynamic>> cardScanner({Map<String, dynamic> input = const {}}) async {
    log("API CALL: Card Scanner");
    ShowDialog.showLoadingDialog();
    Map<String, dynamic> res = {
      "result": {},
    };
    try {
      var data1 = await http.post(
        Uri.parse('${apiUrl}tool/customer-card-scanner'),
        // headers: {'Content-Type': 'multipart/form-data'},
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(input));
      Get.back();
      if ([200, 201, 204].contains(data1.statusCode)) {
        var res1 = resApiReadFromJson(data1.body);
        res['result'] = res1.data?.result ?? {};
        return res;
      }

      return res;
    } catch (e) {
      Get.back();
      ShowDialog.showForceDialog("Error", "$e", () => Get.back());
      if (kDebugMode) log('$e');
      return res;
    }
  }


  static Future<void> guestInit({String customerId = ''}) async {
    log("CALL API: Guest Init");
    final lCode = await LocalStorage.get(prefLanguage) ?? 'th';
    try {
      var data1 = await http.post(Uri.parse('${apiUrl}auth/guest-init'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode({"customerId": customerId}));
      if ([200, 201, 204].contains(data1.statusCode)) {
        final res1 = ResApiAuth.fromJson(jsonDecode(data1.body));

        final CustomerController _customerController = Get.find<CustomerController>();
        await _customerController.clear();

        final _shopId = res1.data?.user?.partnerShop?.id;
        await Future.wait([
          LocalStorage.saveAccessToken(res1.data?.accessToken),
          LocalStorage.saveRefreshToken(res1.data?.refreshToken),
          _customerController.updateCustomer(res1.data?.user),
        ]);

        if (_customerController.isCustomer()) {
          final FirebaseController _firebaseController = Get.find<FirebaseController>();

          final List<dynamic> resWait1 = await Future.wait([
            _firebaseController.updateChatrooms(res1.data?.user?.id ?? ''),
            _firebaseController.updateOrderStatuses(res1.data?.user?.id ?? ''),
            processRead('partner-shop', input: { '_id': _shopId }),
          ]);
          final Map<String, dynamic> resPartnerShop = resWait1[2];
          PartnerShopModel? partnerShop = resPartnerShop['result'].isNotEmpty == true? PartnerShopModel.fromJson(resPartnerShop['result']): null;

         // String fcmToken = await NotificationService.getFcmToken();
          //res1.data?.user?.fcmToken = fcmToken;
          
          await Future.wait([
            //processUpdate('fcm-token', input: { "fcmToken": fcmToken }),
            _customerController.updateCustomer(res1.data?.user, value: partnerShop),
          ]);
          await _customerController.updateFavoriteProducts();
        }

        final List<dynamic> resWait2 = await Future.wait([
          _readShippingAddress(lang: lCode, accessToken: res1.data?.accessToken ?? ''),
          _readCustomerCart(lang: lCode, accessToken: res1.data?.accessToken ?? ''),
          _readBillingAddress(lang: lCode, accessToken: res1.data?.accessToken ?? ''),
        ]);
        CustomerShippingAddressModel? address = resWait2[0];
        CustomerCartModel? cart = resWait2[1];
        CustomerBillingAddressModel? billingAddress = resWait2[2];
         await Future.wait([
          _customerController.updateShippingAddress(address),
          _customerController.updateCart(cart),
          _customerController.updateBillingAddress(billingAddress),
        ]);
      }
    } catch (e) {
      if (kDebugMode) log("API ERROR: $e");
      throw Exception(e);
    }
  }

  static Future<CustomerShippingAddressModel?> _readShippingAddress({required String lang, required String accessToken}) async {
    CustomerShippingAddressModel? address;
    try {
      var data = await http.get(
          Uri.parse('${apiUrl}customer/shipping-address-get-selected?lang=${systemLanguages.length > 1
            ? lang.toUpperCase()
            : systemLanguages[0].toUpperCase()}'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $accessToken'
          });
      if ([200, 201, 204].contains(data.statusCode)) {
        var res = jsonDecode(data.body);
        if (res!['data']['result'] != null) {
          address = CustomerShippingAddressModel.fromJson(res['data']['result']);
        }
      }
    } catch (_) {}
    return address;
  }
  static Future<CustomerCartModel?> _readCustomerCart({required String lang, required String accessToken}) async {
    CustomerCartModel? cart;
    try {
      var data = await http.get(Uri.parse('${apiUrl}customer/cart?lang=${systemLanguages.length > 1
            ? lang.toUpperCase()
            : systemLanguages[0].toUpperCase()}'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      });
      if ([200, 201, 204].contains(data.statusCode)) {
        var res = jsonDecode(data.body);
        if (res!['data']['result'] != null) {
          cart = CustomerCartModel.fromJson(res['data']['result']);
        }
      }
    } catch (_) {}
    return cart;
  }
  static Future<CustomerBillingAddressModel?> _readBillingAddress({required String lang, required String accessToken}) async {
    CustomerBillingAddressModel? billingAddress;
    try {
      var data4 = await http.get(
        Uri.parse('${apiUrl}customer/billing-address-get-selected?lang=${systemLanguages.length > 1
          ? lang.toUpperCase()
          : systemLanguages[0].toUpperCase()}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        });

    if ([200, 201, 204].contains(data4.statusCode)) {
      var res4 = jsonDecode(data4.body);
      if (res4!['data']['result'] != null) {
        billingAddress = CustomerBillingAddressModel.fromJson(res4['data']['result']);
      }
    }
    } catch (_) {}
    return billingAddress;
  }
  
  static Future<CustomerChatroomModel> chatroomCreate(String orderId) async {
    log("API CALL: Chatroom Create");
    ShowDialog.showLoadingDialog();
    try {
      final accessToken = await storage.read(key: localAccessToken);
      var data1 = await http.post(Uri.parse('${apiUrl}customer/chatroom'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $accessToken'
          },
          body: jsonEncode({"orderId": orderId}));

      Get.back();
      if ([200, 201, 204].contains(data1.statusCode)) {
        final res1 = jsonDecode(data1.body);
        if (res1!['data']!['result'] != null) {
          return CustomerChatroomModel.fromJson(res1['data']['result']);
        } else {
          return CustomerChatroomModel();
        }
      } else {
        final res1 = ResApiError.fromJson(jsonDecode(data1.body)).error;
        ShowDialog.showForceDialog(
            "Error", "${res1?.errorText()}", () => Get.back());
        return CustomerChatroomModel();
      }
    } catch (e) {
      Get.back();
      ShowDialog.showForceDialog("Error", "$e", () => Get.back());
      if (kDebugMode) log('$e');
      return CustomerChatroomModel();
    }
  }

  static Future<bool> updateCart(String shopId, List<Map<String, dynamic>> products, { bool needLoading = true }) async {
    log("CALL API: Update Cart");
    if (needLoading) ShowDialog.showLoadingDialog();
    try {
      final accessToken = await storage.read(key: localAccessToken);
      var data1 = await http.patch(Uri.parse('${apiUrl}customer/cart'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode({"shopId": shopId, "products": products}));
      if (needLoading) Get.back();
      if ([200, 201, 204].contains(data1.statusCode)) {
        final res1 = jsonDecode(data1.body);
        CustomerCartModel? cart =
          CustomerCartModel.fromJson(res1['data']['result']);
        final CustomerController _customerController =
          Get.find<CustomerController>();
        await _customerController.updateCart(cart);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (needLoading) Get.back();
      if (kDebugMode) log("API ERROR: $e");
      throw Exception(e);
    }
  }
  static Future<bool> readCart({bool needLoading = true}) async {
    log("CALL API: Read Cart");
    if(needLoading) ShowDialog.showLoadingDialog();
    final lCode = await LocalStorage.get(prefLanguage) ?? 'th';
    try {
      // Add Language Code
      final accessToken = await storage.read(key: localAccessToken);
      var data1 = await http.get(
        Uri.parse('${apiUrl}customer/cart?lang=${systemLanguages.length > 1
          ? lCode.toUpperCase()
          : systemLanguages[0].toUpperCase()}'
        ),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        }
      );
      if(needLoading)  Get.back();
      if ([200, 201, 204].contains(data1.statusCode)) {
        final res1 = jsonDecode(data1.body);
        CustomerCartModel? cart =
          CustomerCartModel.fromJson(res1['data']['result']);
        final CustomerController _customerController =
          Get.find<CustomerController>();
        await _customerController.updateCart(cart);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if(needLoading)  Get.back();
      if (kDebugMode) log("API ERROR: $e");
      throw Exception(e);
    }
  }

  static Future<Payment2C2PModel> customerPayment2C2P({
    required double amount,
    required String shippingAddressId,
    required dynamic shippingFrontend,
    required String paymentMethodId,
    int hasDownPayment = 0,
    double missingPayment = 0,
    String billingAddressId = '',
    dynamic shippingCouponFrontend,
    dynamic couponFrontend,
    dynamic cashCouponFrontend,
    double pointBurn = 0,
    String? salesManagerId,
    int hasCustomDownPayment = 0,
    double? customDownPayment,
    double? amountDefault,
    double? missingPaymentDefault,
  }) async {
    log("CALL API: Customer Checkout Payment 2C2P");
    ShowDialog.showLoadingDialog();
    try {
      final accessToken = await storage.read(key: localAccessToken);
      var data1 = await http.post(Uri.parse('${apiUrl}customer/checkout-payment-2c2p'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode({
          "amount": amount,
          "hasDownPayment": hasDownPayment,
          "missingPayment": missingPayment,
          "shippingAddressId": shippingAddressId,
          "shippingFrontend": shippingFrontend,
          "paymentMethodId": paymentMethodId,
          "billingAddressId": billingAddressId,
          "shippingCouponFrontend": shippingCouponFrontend,
          "couponFrontend": couponFrontend,
          "cashCouponFrontend": cashCouponFrontend,
          "pointBurn": pointBurn,
          "salesManagerId": salesManagerId,
          "hasCustomDownPayment": hasCustomDownPayment,
          "customDownPayment": customDownPayment,
          "amountDefault": amountDefault,
          "missingPaymentDefault": missingPaymentDefault,
        })
      );
      Get.back();
      if ([200, 201, 204].contains(data1.statusCode)) {
        final res1 = jsonDecode(data1.body);
        if (res1 != null && res1["data"] != null) {
          return Payment2C2PModel.fromJson(res1["data"]);
        } else {
          ShowDialog.showForceDialog("Error", "${res1?['message']}", () => Get.back());
          return Payment2C2PModel();
        }
      } else {
        final res1 = ResApiError.fromJson(jsonDecode(data1.body)).error;
        ShowDialog.showForceDialog("Error", "${res1?.errorText()}", () => Get.back());
        return Payment2C2PModel();
      }
    } catch (e) {
      Get.back();
      ShowDialog.showForceDialog("Error", "$e", () => Get.back());
      if (kDebugMode) log("API ERROR: $e");
      throw Exception(e);
    }
  }
  static Future<Payment2C2PModel> customerSubscriptionPayment2C2P({
    required double amount,
    required String signature,
    required String shippingAddressId,
    required PartnerShippingFrontendModel shippingFrontend,
    String? billingAddressId,
    String? salesManagerId,
  }) async {
    log("CALL API: Customer Subscription Checkout Payment 2C2P");
    ShowDialog.showLoadingDialog();
    try {
      Map<String, dynamic> _input = {
        "amount": amount,
        "signature": signature,
        "shippingAddressId": shippingAddressId,
        "shippingFrontend": shippingFrontend.toJson(),
      };
      if(billingAddressId?.isNotEmpty == true) _input['billingAddressId'] = billingAddressId;
      if(salesManagerId?.isNotEmpty == true) _input['salesManagerId'] = salesManagerId;

      final accessToken = await storage.read(key: localAccessToken);
      var data1 = await http.post(Uri.parse('${apiUrl}customer/subscription-payment-2c2p'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(_input)
      );
      Get.back();
      if ([200, 201, 204].contains(data1.statusCode)) {
        final res1 = jsonDecode(data1.body);
        if (res1 != null && res1["data"] != null) {
          return Payment2C2PModel.fromJson(res1["data"]);
        } else {
          ShowDialog.showForceDialog("Error", "${res1?['message']}", () => Get.back());
          return Payment2C2PModel();
        }
      } else {
        final res1 = ResApiError.fromJson(jsonDecode(data1.body)).error;
        ShowDialog.showForceDialog("Error", "${res1?.errorText()}", () => Get.back());
        return Payment2C2PModel();
      }
    } catch (e) {
      Get.back();
      ShowDialog.showForceDialog("Error", "$e", () => Get.back());
      if (kDebugMode) log("API ERROR: $e");
      throw Exception(e);
    }
  }
  static Future<dynamic> customerPayment2C2PCompleted({required String payload}) async {
    log("CALL API: Customer Checkout Payment 2C2P Completed");
    // ShowDialog.showLoadingDialog();
    try {
      final accessToken = await storage.read(key: localAccessToken);
      var data1 = await http.post(
        Uri.parse('${apiUrl}customer/checkout-payment-2c2p-completed'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode({"payload": payload})
      );
      // Get.back();
      if ([200, 201, 204].contains(data1.statusCode)) {
        final res1 = jsonDecode(data1.body);
        final CustomerController _customerController = Get.find<CustomerController>();

        await _customerController.updateCart(null);
        await _customerController.updateBillingAddress(null);
        await _customerController.setShippingMethod(null);
        await _customerController.setPaymentMethod(null);
        _customerController.setDiscountShipping(null);
        _customerController.setDiscountProduct(null);
        _customerController.setDiscountCash(null);
        _customerController.setDiscountPoint(null);

        return res1['data']['result'];
      }else{
        final res1 = ResApiError.fromJson(jsonDecode(data1.body)).error;
        // ShowDialog.showForceDialog("Payment Failed", "${res1?.errorText()}", () => Get.back());
        return { "error": "${res1?.errorText()}" };
      }
    } on PlatformException catch (e) {
      // Get.back();
      // ShowDialog.showForceDialog("Payment Failed", e.message ?? '', () => Get.back());
      if (kDebugMode) log("API ERROR: $e");
      return { "error": "${e.message}" };
      // throw Exception(e);
    } catch (e) {
      // Get.back();
      // ShowDialog.showForceDialog("Payment Failed", e.toString(), () => Get.back());
      if (kDebugMode) log("API ERROR: $e");
      return { "error": e.toString() };
      // throw Exception(e);
    } 
  }

  static Future<PaymentStripeModel> customerPaymentStripe({
    required double amount,
    required String shippingAddressId,
    required dynamic shippingFrontend,
    required String paymentMethodId,
    int hasDownPayment = 0,
    double missingPayment = 0,
    String billingAddressId = '',
    dynamic shippingCouponFrontend,
    dynamic couponFrontend,
    dynamic cashCouponFrontend,
    double pointBurn = 0,
    String? salesManagerId,
    int hasCustomDownPayment = 0,
    double? customDownPayment,
    double? amountDefault,
    double? missingPaymentDefault,
  }) async {
    log("CALL API: Customer Checkout Payment Stripe");
    ShowDialog.showLoadingDialog();
    try {
      final accessToken = await storage.read(key: localAccessToken);
      Map<String, dynamic> input = {
        "amount": amount,
        "hasDownPayment": hasDownPayment,
        "missingPayment": missingPayment,
        "shippingAddressId": shippingAddressId,
        "shippingFrontend": shippingFrontend,
        "paymentMethodId": paymentMethodId,
        "billingAddressId": billingAddressId,
        "shippingCouponFrontend": shippingCouponFrontend,
        "couponFrontend": couponFrontend,
        "cashCouponFrontend": cashCouponFrontend,
        "pointBurn": pointBurn,
        "salesManagerId": salesManagerId,
        "hasCustomDownPayment": hasCustomDownPayment,
        "customDownPayment": customDownPayment,
        "amountDefault": amountDefault,
        "missingPaymentDefault": missingPaymentDefault,
      };
      var data1 = await http.post(Uri.parse('${apiUrl}customer/checkout-payment-stripe'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(input)
      );
      Get.back();
      if ([200, 201, 204].contains(data1.statusCode)) {
        final res1 = jsonDecode(data1.body);
        if (res1 != null && res1["data"] != null) {
          return PaymentStripeModel.fromJson(res1["data"]);
        } else {
          ShowDialog.showForceDialog("Error", "${res1?['message']}", () => Get.back());
          return PaymentStripeModel();
        }
      } else {
        final res1 = ResApiError.fromJson(jsonDecode(data1.body)).error;
        ShowDialog.showForceDialog("Error", "${res1?.errorText()}", () => Get.back());
        return PaymentStripeModel();
      }
    } catch (e) {
      Get.back();
      ShowDialog.showForceDialog("Error", "$e", () => Get.back());
      if (kDebugMode) log("API ERROR: $e");
      throw Exception(e);
    }
  }
  static Future<dynamic> customerPaymentStripeCompleted({required PaymentStripeModel model}) async {
    log("CALL API: Customer Checkout Payment Stripe Completed");
    ShowDialog.showLoadingDialog();
    try {
      final accessToken = await storage.read(key: localAccessToken);
      var data1 = await http.post(
        Uri.parse('${apiUrl}customer/checkout-payment-stripe-completed'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode({
          "paymentIntentId": model.id,
          "clientSecret": model.clientSecret,
        }),
      );
      Get.back();
      if ([200, 201, 204].contains(data1.statusCode)) {
        final res1 = jsonDecode(data1.body);
        final CustomerController _customerController = Get.find<CustomerController>();

        await _customerController.updateCart(null);
        await _customerController.updateBillingAddress(null);
        await _customerController.setShippingMethod(null);
        await _customerController.setPaymentMethod(null);
        _customerController.setDiscountShipping(null);
        _customerController.setDiscountProduct(null);
        _customerController.setDiscountCash(null);
        _customerController.setDiscountPoint(null);

        return res1['data']['result'];
      } else {
        final res1 = ResApiError.fromJson(jsonDecode(data1.body)).error;
        ShowDialog.showForceDialog("Payment Failed", "${res1?.errorText()}", () => Get.back());
        return {};
      }
    } on PlatformException catch (e) {
      Get.back();
      ShowDialog.showForceDialog("Payment Failed", e.message ?? '', () => Get.back());
      if (kDebugMode) log("API ERROR: $e");
      throw Exception(e);
    } catch (e) {
      Get.back();
      ShowDialog.showForceDialog("Payment Failed", e.toString(), () => Get.back());
      if (kDebugMode) log("API ERROR: $e");
      throw Exception(e);
    } 
  }

  static Future<dynamic> customerCheckout({
    required dynamic shippingFrontend,
    required String paymentMethodId,
    String billingAddressId = '',
    dynamic shippingCouponFrontend,
    dynamic couponFrontend,
    dynamic cashCouponFrontend,
    double pointBurn = 0,
    String? salesManagerId,
    int hasCustomDownPayment = 0,
    double? customDownPayment,
    double? amountDefault,
    double? missingPaymentDefault,
  }) async {
    log("CALL API: Customer Checkout");
    ShowDialog.showLoadingDialog();
    try {
      final accessToken = await storage.read(key: localAccessToken);
      var data1 = await http.post(
        Uri.parse('${apiUrl}customer/checkout'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode({
          "shippingFrontend": shippingFrontend,
          "billingAddressId": billingAddressId,
          "paymentMethodId": paymentMethodId,
          "shippingCouponFrontend": shippingCouponFrontend,
          "couponFrontend": couponFrontend,
          "cashCouponFrontend": cashCouponFrontend,
          "pointBurn": pointBurn,
          "salesManagerId": salesManagerId,             
          "hasCustomDownPayment": hasCustomDownPayment,
          "customDownPayment": customDownPayment,
          "amountDefault": amountDefault,
          "missingPaymentDefault": missingPaymentDefault,
        })
      );
      Get.back();
      if ([200, 201, 204].contains(data1.statusCode)) {
        final res1 = jsonDecode(data1.body);
        final CustomerController _customerController = Get.find<CustomerController>();

        await _customerController.updateCart(null);
        await _customerController.updateBillingAddress(null);
        await _customerController.setShippingMethod(null);
        await _customerController.setPaymentMethod(null);
        _customerController.setDiscountShipping(null);
        _customerController.setDiscountProduct(null);
        _customerController.setDiscountCash(null);
        _customerController.setDiscountPoint(null);

        return res1['data']['result'];
      } else {
        final res1 = ResApiError.fromJson(jsonDecode(data1.body)).error;
        ShowDialog.showForceDialog("Error", "${res1?.errorText()}", () => Get.back());
        return {};
      }
    } catch (e) {
      Get.back();
      ShowDialog.showForceDialog("Error", "$e", () => Get.back());
      if (kDebugMode) log("API ERROR: $e");
      throw Exception(e);
    }
  }

  
  static Future<FileModel> uploadFile(XFile input, {
    bool needLoading = false,
    String folder = '',
    int resize = 0,
    String acceptMimetypes = 'image/png,image/jpeg,image/jpg'
  }) async {
    Map<String, String> apiHeader = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer $cdnToken",
      'Accept-Mimetypes': acceptMimetypes
    };

    String path = "file/single";
    if(folder != ''){
      path += "/$folder";
      if(resize > 0) path += "/$resize";
    }

    if (needLoading) ShowDialog.showLoadingDialog();
    try {
      final formData = dio.FormData.fromMap({
        'file': await dio.MultipartFile.fromFile(
          input.path,
          filename: input.name,
          contentType: MediaType("image", "jpeg"),
        ),
      });
      final res = await dio.Dio(
        dio.BaseOptions(
          headers: apiHeader,
          validateStatus: (_) => true,
          baseUrl: cdnUrl,
          connectTimeout: Duration(milliseconds: 5000),
          receiveTimeout: Duration(milliseconds: 5000),
        ),
      ).post(path, data: formData);
      int? status = res.statusCode;
      if ([200, 201, 204].contains(status)) {
        if (needLoading) Get.back();
        FileModel file = FileModel.fromJson(res.data["data"]["file"]);
        return file;
      } else {
        if (needLoading) Get.back();
        return FileModel();
      }
    } catch (e) {
      log("Upload File Error: ${e.toString()}");
      if (needLoading) Get.back();
      return FileModel();
    }
  }

  static Future<List<FileModel>?> uploadMultipleFile(List<XFile> inputs, {
    bool needLoading = false,
    String folder = '',
    int resize = 0,
    String acceptMimetypes = 'image/png,image/jpeg,image/jpg'
  }) async {
    Map<String, String> apiHeader = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer $cdnToken",
      'Accept-Mimetypes': acceptMimetypes
    };

    String path = "file/multiple";
    if(folder != ''){
      path += "/$folder";
      if(resize > 0) path += "/$resize";
    }

    if (needLoading) ShowDialog.showLoadingDialog();
    try {
      var formData = dio.FormData();
      for (var e in inputs) {
        formData.files.addAll([
          MapEntry(
            "files",
            await dio.MultipartFile.fromFile(
              e.path,
              filename: e.name,
              contentType: MediaType("image", "jpeg")
            )
          ),
        ]);
      }
      final res = await dio.Dio(
        dio.BaseOptions(
          headers: apiHeader,
          validateStatus: (_) => true,
          baseUrl: cdnUrl,
          connectTimeout: Duration(milliseconds: 5000),
          receiveTimeout: Duration(milliseconds: 5000),
        ),
      ).post(path, data: formData);
      int? status = res.statusCode;
      if ([200, 201, 204].contains(status)) {
        if (needLoading) Get.back();
        List<FileModel> files =  List<FileModel>.from(res.data["data"]["files"].map((e) => FileModel.fromJson(e)));
        return files;
      } else {
        if (needLoading) Get.back();
        return null;
      }
    } catch (e) {
      if (needLoading) Get.back();
      return null;
    }
  }

  static Future<Map<String, dynamic>?> processList(String type, {Map<String, dynamic> input = const {}, bool addPartnerShop = false}) async {
    log("API CALL: Process List - $type");
    final lCode = await LocalStorage.get(prefLanguage) ?? 'th';
    bool ready = true;
    String endpoint = 'frontend/';
    Map<String, String> apiHeader = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final CustomerModel? customer = Get.find<CustomerController>().customerModel;

    var res = {'paginate': PaginateModel(), 'dataFilter': {}, 'result': []};
    try {
      if (API_CUSTOMER_PATHS.contains(type)) {
        final accessToken = await storage.read(key: localAccessToken);
        if ([null, 'null', ''].contains(accessToken)) {
          ready = false;
          // LogOutService.logOut();
        } else {
          endpoint = 'customer/';
          apiHeader['Authorization'] = 'Bearer $accessToken';
        }
      }

      if(ready){
        if(input['dataFilter'] != null){
          final input2 = Map.of(input);
          final input3 = Map.of(input2["dataFilter"]);
          input3['lang'] = systemLanguages.length > 1? lCode.toUpperCase(): systemLanguages[0].toUpperCase();
          if(addPartnerShop) {
            PartnerShopModel? partnerShop = Get.find<CustomerController>().partnerShop;
            if(partnerShop?.id != null && partnerShop?.type != 9) {
              input3['partnerShopId'] = partnerShop?.id;
            }else{
              input3['partnerShopCode'] = 'CENTER';
            }
          }
          if(customer != null){
            if(customer.group?.isValid() == true){
              input3['customerGroupId'] = customer.group?.id;
            }
          }
          input2["dataFilter"] = input3;
          input = input2;
        }else {
          final input2 = Map.of(input);
          Map<dynamic, dynamic>  input3 = {'lang': systemLanguages.length > 1? lCode.toUpperCase(): systemLanguages[0].toUpperCase()};
          if(addPartnerShop) {
            PartnerShopModel? partnerShop = Get.find<CustomerController>().partnerShop;
            if(partnerShop?.id != null && partnerShop?.type != 9) {
              input3['partnerShopId'] = partnerShop?.id;
            } else{
              input3['partnerShopCode'] = 'CENTER';
            }
          }
          if(customer != null){
            if(customer.group?.isValid() ==true){
              input3['customerGroupId'] = customer.group?.id;
            }
          }
          input2['dataFilter'] = input3;
          input = input2;
        }
        var data1 = await http.post(Uri.parse('$apiUrl$endpoint$type'),
            headers: apiHeader, body: jsonEncode(input));
        var res1 = apiDataFromJson(data1.body);
        res['result'] = res1.data?.result?.toList() == null
            ? []
            : res1.data!.result!.toList();
        res['paginate'] = res1.data?.paginate == null
            ? PaginateModel()
            : res1.data!.paginate!;
        res['dataFilter'] =
            res1.data?.dataFilter == null ? {} : res1.data!.dataFilter!;
      }

      return res;
    } catch (e) {
      if (kDebugMode) log("API ERROR: $e");
      throw Exception(e);
    }
  }

  static Future<Map<String, dynamic>?> processRead(String type, {Map<String, dynamic> input = const {}}) async {
    log("API CALL: Process Read - $type");
    final lCode = await LocalStorage.get(prefLanguage) ?? 'th';

    bool ready = true;
    String endpoint = 'frontend/';
    Map<String, String> apiHeader = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final CustomerModel? customer = Get.find<CustomerController>().customerModel;

    Map<String, dynamic> res = {
      "result": {},
    };

    try {
      if (API_CUSTOMER_PATHS.contains(type)) {
        final accessToken = await storage.read(key: localAccessToken);
        if ([null, 'null', ''].contains(accessToken)) {
          ready = false;
          // LogOutService.logOut();
        } else {
          endpoint = 'customer/';
          apiHeader['Authorization'] = 'Bearer $accessToken';
        }
      }

      String inputUrl = '';
      String sep = '?';
      input.forEach((key, value) {
        inputUrl += '$sep$key=$value';
        sep = '&';
      });
      inputUrl += '${sep}lang=${systemLanguages.length > 1? lCode.toUpperCase(): systemLanguages[0].toUpperCase()}';
      sep = '&';
      if(customer != null){
        if(customer.group?.isValid() == true){
          inputUrl += '${sep}customerGroupId=${customer.group!.id}';
        }
      }
      if (ready) {
        var data1 = await http.get(
          Uri.parse('$apiUrl$endpoint$type$inputUrl'),
          headers: apiHeader,
        );
        var res1 = resApiReadFromJson(data1.body);
        res['result'] = res1.data?.result ?? {};
      }

      return res;
    } catch (e) {
      if (kDebugMode) log("API ERROR: $e");

      // let temp = RefreshService;
      // if(!temp) LogOutService.logOut();
      throw Exception(e);
    }
    // return null;
  }

  static Future<bool> processCreate(String type, {Map<String, dynamic> input = const {}, bool needLoading = false}) async {
    log("API CALL: Process Create - $type");

    bool ready = true;
    String endpoint = 'frontend/';
    Map<String, String> apiHeader = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    if (needLoading) ShowDialog.showLoadingDialog();
    try {
      if (API_CUSTOMER_PATHS.contains(type)) {
        final accessToken = await storage.read(key: localAccessToken);
        if ([null, 'null', ''].contains(accessToken)) {
          ready = false;
          // LogOutService.logOut();
        } else {
          endpoint = 'customer/';
          apiHeader['Authorization'] = 'Bearer $accessToken';
        }
      }

      if(ready){
        var data1 = await http.post(Uri.parse('$apiUrl$endpoint$type'),
            headers: apiHeader, body: jsonEncode(input));
        if (needLoading) Get.back();
        log("data1 ${data1.body}");
        if ([200, 201, 204].contains(data1.statusCode)) {
          return true;
        } else {
          final res1 = ResApiError.fromJson(jsonDecode(data1.body)).error;
          if(needLoading) ShowDialog.showForceDialog("Error", "${res1?.errorText()}", () => Get.back());
          return false;
        }
      } else {
        if(needLoading) Get.back();
        return false;
      }
    } catch (e) {
      if (needLoading) {
        Get.back();
        ShowDialog.showForceDialog("Error", "$e", () => Get.back());
      }
      if (kDebugMode) log("API ERROR: $e");
      throw Exception(e);
    }
  }

  static Future<bool> processUpdate(String type, {Map<String, dynamic> input = const {}, bool needLoading = false}) async {
    log("API CALL: Process Update - $type");

    bool ready = true;
    String endpoint = 'frontend/';
    Map<String, String> apiHeader = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    if (needLoading) ShowDialog.showLoadingDialog();
    try {
      if (API_CUSTOMER_PATHS.contains(type)) {
        final accessToken = await storage.read(key: localAccessToken);
        if ([null, 'null', ''].contains(accessToken)) {
          ready = false;
          // LogOutService.logOut();
        } else {
          endpoint = 'customer/';
          apiHeader['Authorization'] = 'Bearer $accessToken';
        }
      }

      if (ready) {
        var data1 = await http.patch(
          Uri.parse('$apiUrl$endpoint$type'),
          headers: apiHeader,
          body: jsonEncode(input)
        );
        if (needLoading) Get.back();
        if ([200, 201, 204].contains(data1.statusCode)) {
          return true;
        } else {
          final res1 = ResApiError.fromJson(jsonDecode(data1.body)).error;
          if (needLoading) {
            ShowDialog.showForceDialog("Error", "${res1?.errorText()}", () => Get.back());
          }
          return false;
        }
      } else {
        if (needLoading) Get.back();
        return false;
      }
    } catch (e) {
      if (needLoading) {
        Get.back();
        ShowDialog.showForceDialog("Error", "$e", () => Get.back());
      }
      if (kDebugMode) log("API ERROR: $e");
      throw Exception(e);
    }
  }

  static Future<bool> processDelete(String type, {Map<String, dynamic> input = const {}, bool needLoading = false}) async {
    log("API CALL: Process Delete - $type");

    bool ready = true;
    String endpoint = 'frontend/';
    Map<String, String> apiHeader = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    if (needLoading) ShowDialog.showLoadingDialog();
    try {
      if (API_CUSTOMER_PATHS.contains(type)) {
        final accessToken = await storage.read(key: localAccessToken);
        if ([null, 'null', ''].contains(accessToken)) {
          ready = false;
          // LogOutService.logOut();
        } else {
          endpoint = 'customer/';
          apiHeader['Authorization'] = 'Bearer $accessToken';
        }
      }

      if (ready) {
        var data1 = await http.delete(Uri.parse('$apiUrl$endpoint$type'),
            headers: apiHeader, body: jsonEncode(input));
        if (needLoading) Get.back();
        if ([200, 201, 204].contains(data1.statusCode)) {
          return true;
        } else {
          final res1 = ResApiError.fromJson(jsonDecode(data1.body)).error;
          if (needLoading) {
            ShowDialog.showForceDialog(
                "Error", "${res1?.errorText()}", () => Get.back());
          }
          return false;
        }
      } else {
        if (needLoading) Get.back();
        return false;
      }
    } catch (e) {
      if (needLoading) {
        Get.back();
        ShowDialog.showForceDialog("Error", "$e", () => Get.back());
      }
      if (kDebugMode) log("API ERROR: $e");
      throw Exception(e);
    }
  }
}
