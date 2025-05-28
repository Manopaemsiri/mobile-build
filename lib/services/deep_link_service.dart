import 'package:app_links/app_links.dart';
import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/data/local_storage/local_storage.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/bottom_nav/bottom_nav.dart';
import 'package:coffee2u/screens/cms/content/list.dart';
import 'package:coffee2u/screens/cms/content/read.dart';
import 'package:coffee2u/screens/customer/order/read.dart';
import 'package:coffee2u/screens/customer/profile/profile_screen.dart';
import 'package:coffee2u/screens/customer/shopping_cart/read.dart';
import 'package:coffee2u/screens/partner/product/list.dart';
import 'package:coffee2u/screens/partner/product/read.dart';
import 'package:coffee2u/screens/partner/search/read.dart';
import 'package:coffee2u/services/facebook_app_links.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter_facebook_sdk/flutter_facebook_sdk.dart';
import 'package:get/get.dart';

import '../screens/partner/subscription/list.dart';
import '../screens/partner/subscription/read.dart';

// xcrun simctl openurl booted 'https://aromacoffee2u.com/app/partner/product?url=TaurinoMuiraSilver'
// xcrun simctl openurl booted 'com.coffee2u.aroma://aromacoffee2u.com/app/partner/product?url=TaurinoMuiraSilver'

// adb shell 'am start -W -a android.intent.action.VIEW -d "com.coffee2u.aroma://app" com.coffee2u.aroma'
// adb shell 'am start -W -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "https://aromacoffee2u.com/app/partner/product-category?url=coffee-beans"'

mixin DeepLinkService {

  Future<void> initPlatformState() async {
    try{
      String? deepLinkUrl = await FlutterFacebookAppLinks.initFBLinks();
      if(deepLinkUrl.isNotEmpty) handleDeepLink(Uri.parse(deepLinkUrl));
    }catch(e){
      if(kDebugMode) print('Error on FB APP LINKS');
    }  
  }

  Future<void> initUniLinks() async {
    try {
      final AppLinks appLinks = AppLinks();
      final Uri? initialLink = await appLinks.getInitialLink();
      handleDeepLink(initialLink);
      initPlatformState();
    } on Exception {
      if (kDebugMode) print("object");
    }

    // linkStream.listen((String? link) {
    //   if (link != null) handleDeepLink(link);
    // }, onError: (err) {
    //   // Handle exception by warning the user their action did not succeed
    // });
    AppLinks().uriLinkStream.listen((link) {
      if (link.path.isNotEmpty) handleDeepLink(link);
    });
  }

  Future<void> handleDeepLink(Uri? link) async {
    if (link != null && link.path.isNotEmpty == true) {
      Uri uri = link;
      List<String> pathSegments = uri.pathSegments;
      final skipIntro = await LocalStorage.getSkipIntro();
      if(uri.pathSegments.isNotEmpty && skipIntro == true){
        String fullPath = pathSegments.join('/');
        Map<String, String> params = uri.queryParameters;

        if(fullPath == 'app'){
          final salesId = params['salesManagerId']?.trim();
          if(salesId?.isNotEmpty == true) {
            CustomerController controller = Get.find<CustomerController>();
            Map<String, dynamic> input = { 
              'salesManagerId': salesId,
              'isNoSalesManager': 1
            };
            ApiService.processUpdate('account', input: input).then((value1) {
              if(value1 == true){
                ApiService.processRead('account').then((value2){
                  if(value2?['result'] != null){
                    UserModel? salesManager;
                    try {
                      salesManager = UserModel.fromJson(value2?['result']);
                    } catch (e) {
                      if(kDebugMode) printError(info: '$e');
                    }
                    if(salesManager != null) {
                      CustomerModel? customer = controller.customerModel;
                      customer?.salesManager = salesManager;
                      controller.updateCustomer(customer);
                    }
                  }
                });
              }
            });
          }
        }
        // Get.offAll(() => const BottomNav(showPopup: false));
        Get.offAll(() => const BottomNav());

        switch (fullPath) {

          case 'app/customer/orders':
            // Get.offAll(() => const BottomNav(showPopup: false, initialTab : 1));
            Get.offAll(() => const BottomNav(initialTab : 1));
            break;

          case 'app/customer/order':
          // [ orderId ]
            String _orderId = params['orderId'] ?? '';
            if(_orderId.isNotEmpty){
              Get.to(() => CustomerOrderScreen(orderId: _orderId));
            }
            break;

          case 'app/customer/cart':
            Get.to(() => const ShoppingCartScreen());
            break;

          case 'app/customer/profile':
            // Get.offAll(() => const BottomNav(showPopup: false, initialTab : 4));
            Get.offAll(() => const BottomNav(initialTab : 4));
            Get.to(() => const ProfileScreen());
            break;

          case 'app/partner/product':
          // [ url, shopCode ]
            String thisUrl = params['url'] ?? '';
            if(thisUrl.isNotEmpty){
              var res = await ApiService.processRead('partner-product', input: { 'url': thisUrl });
              if(res != null && res['result'] != null){
                PartnerProductModel _product = PartnerProductModel.fromJson(res['result']);
                Get.to(() => ProductScreen(productId: _product.id));
              }
            }
            break;
          case 'app/partner/product-category':
          // [ url]
            String thisUrl = params['url'] ?? '';
            if(thisUrl.isNotEmpty){
              try {
                var res = await ApiService.processRead('partner-product-category', input: { 'url': thisUrl });
                if(res != null && res['result'] != null){
                  PartnerProductCategoryModel _cate = PartnerProductCategoryModel.fromJson(res['result']);
                  Get.to(() => PartnerProductsScreen(appTitle: _cate.name, dataFilter: { "categoryId": _cate.id } ));
                }
              } catch (e) {
                break;
              }
            }
            break;
          case 'app/partner/product-search':
          // [ keyword, isBrand, isCategory ]
            String _keyword = params['keyword'] ?? '';
            bool _isBrand = (params['isBrand'] ?? '') == '1';
            bool _isCategory = (params['isCategory'] ?? '') == '1';
            if(_keyword.isNotEmpty){
              if(_isBrand){
                _keyword = '@$_keyword';
              }else if(_isCategory){
                _keyword = '#$_keyword';
              }
              Get.to(() => SearchScreen(initSearch: _keyword));
            }
            break;

          case 'app/partner/shop':
          // [ code ]
            String _code = params['code'] ?? '';
            if(_code.isNotEmpty){
              var res = await ApiService.processRead('partner-shop', input: { 'code': _code });
              if(res != null && res['result'] != null){
                PartnerShopModel _shop = PartnerShopModel.fromJson(res['result']);
                // Get.to(() => PartnerShopScreen(shopId: _shop.id));
              }
            }
            break;

          case 'app/cms/contents':
          // [ categoryUrl ]
            String thisUrl = params['categoryUrl'] ?? '';
            CmsCategoryModel? _cate;
            if(thisUrl.isNotEmpty){
              var res = await ApiService.processRead('cms-content-category', input: { 'url': thisUrl });
              if(res != null && res['result'] != null){
                _cate = CmsCategoryModel.fromJson(res['result']);
              }
            }
            Get.to(() => CmsContentsScreen(category: _cate));
            break;

          case 'app/cms/content':
          // [ url ]
            String thisUrl = params['url'] ?? '';
            if(thisUrl.isNotEmpty){
              var res = await ApiService.processRead('cms-content', input: { 'url': thisUrl });
              if(res != null && res['result'] != null){
                CmsContentModel widgetContent = CmsContentModel.fromJson(res['result']);
                Get.to(() => CmsContentScreen(url: widgetContent.url));
              }
            }
            break;
          

          case 'app/partner/product-subscriptions':
            Get.to(() => PartnerProductSubscriptionsScreen(lController: Get.find<LanguageController>()));
            break;

          case 'app/partner/product-subscription':
          // [ _id ]
            String _id = params['_id'] ?? '';
            if(_id.isNotEmpty){
              try {
                var res = await ApiService.processRead('partner-product-subscription', input: { '_id': _id });
                if(res != null && res['result'] != null){
                  PartnerProductSubscriptionModel _subscription = PartnerProductSubscriptionModel.fromJson(res['result']);
                  Get.to(() => PartnerProductSubscriptionScreen(id: _subscription.id, lController: Get.find<LanguageController>()));
                }
              } catch (_) {}
            }
            break;

          default:
        }
      }
    }
  }
} 