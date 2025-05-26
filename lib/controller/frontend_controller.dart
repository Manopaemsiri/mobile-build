import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/customer/order/components/order_list.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class FrontendController extends GetxController {
  Duration? youtubeDuration;
  Future<Map<String, dynamic>?>? banners;

  Future<Map<String, dynamic>?>? contentCategories;

  // Products
  Future<Map<String, dynamic>?>? partnerNewProducts;
  Future<Map<String, dynamic>?>? partnerDiscountProducts;
  Future<Map<String, dynamic>?>? partnerFeaturedProducts;
  
  // Categories 
  bool productCategoriesReady= false;
  ValueNotifier<bool> productCategoriesStatus = ValueNotifier<bool>(false);
  List<PartnerProductCategoryModel> productCategories = [];
  
  // Coupons
  Future<Map<String, dynamic>?>? partnerProductCoupons;
  Future<Map<String, dynamic>?>? partnerShippingCoupons;

  List<TabBarModel> tabListshippingStatuses = [];

  @override
  void onClose() {
    productCategoriesStatus.dispose();
    super.onClose();
  }
  Future<void> refreshHomepage({bool needUpdate=true}) async {
    banners = ApiService.processList("cms-banners");
    contentCategories = ApiService.processList("cms-content-categories", input: {
      "dataFilter": { "showOnMobile": 1 }
    });
    productCategoriesReady = false;
    productCategoriesStatus.value = false;

    readCategories();
    partnerNewProducts = ApiService.processList("partner-products", input: {
      "dataFilter": { "statuses": [ 4 ] }, "paginate": { "page": 1, "pp": 10 }
    }, addPartnerShop: true);
    partnerDiscountProducts = ApiService.processList("partner-products", input: {
      "dataFilter": { "statuses": [ 6 ] }, "paginate": { "page": 1, "pp": 10 }
    }, addPartnerShop: true);
    partnerFeaturedProducts = ApiService.processList("partner-products", input: {
      "dataFilter": { "sort": 'desc-salesCount' }, "paginate": { "page": 1, "pp": 10 }
    }, addPartnerShop: true);

    partnerProductCoupons = ApiService.processList("partner-product-coupons", input: {
      "paginate": { "page": 1, "pp": 10 }
    });
    partnerShippingCoupons = ApiService.processList("partner-shipping-coupons",
      input: { "paginate": { "page": 1, "pp": 10 } }
    );
    await shippingStatus();
    if(needUpdate) update();
  }

  readCategories() async {
    try {
      List<PartnerProductCategoryModel> items = [
        PartnerProductCategoryModel.fromJson({
          "_id": null,
          "name": 'All Products',
          "icon": FileModel(path: 'assets/images/aroma-logo.png').toJson(),
        })
      ];
      final res1 = await ApiService.processList('partner-events');
      for (var i = 0; i < (res1?["result"]?.length ?? 0); i++) {
        PartnerProductCategoryModel model 
          = PartnerProductCategoryModel.fromJson(res1?["result"][i]);
        items.add(model);
      }

      final res2 = await ApiService.processList("partner-product-categories");
      for (var i = 0; i < (res2?["result"]?.length ?? 0); i++) {
        PartnerProductCategoryModel model 
          = PartnerProductCategoryModel.fromJson(res2?["result"][i]);
        items.add(model);
      }

      productCategories = items;
      List<Map<String, dynamic>> sortedCates = productCategories.asMap().map((i, d) {
      int displayOrder = i == 0 ? 0 
        : i == 4? 1 
        : i == 1? 2 
        : i == 5? 3 
        : i == 2? 4 
        : i == 6? 5 
        : i == 3? 6 
        : i == 7? 7 
        : i;
        return MapEntry(i, { "value": d, "displayOrder": displayOrder });
      }).values.toList();
      sortedCates.sort((a, b) => a["displayOrder"].compareTo(b["displayOrder"]));
      productCategories = sortedCates.map<PartnerProductCategoryModel>((entry) => entry["value"]).toList();
      productCategoriesReady = true;
      productCategoriesStatus.value = true;
      update();
    } catch (e) {
      if(kDebugMode) print('$e');
      productCategories = [];
      productCategoriesReady = true;
      productCategoriesStatus.value = true;
      update();
    }
  }

  Future<Map<String, dynamic>?> futurePartnerProducts({bool isDiscounted=false}) {
    return ApiService.processList(
      "partner-products",
      input: {
        "paginate": { "page": 1, "pp": 10 },
        "dataFilter": {
          "statuses": isDiscounted? [5]: [2,3,4],
          "sort": isDiscounted? "": "desc-salesCount",
        }
      },
    );
  }

  Future<Map<String, dynamic>?> futureCmsContents(String categoryUrl) {
    return ApiService.processList(
      "cms-contents",
      input: {
        "paginate": { "page": 1, "pp": 5 },
        "dataFilter": { "categoryUrl": categoryUrl }
      },
    );
  }

  Future<void> shippingStatus({bool needUpdate = true}) async {
    try {
      LanguageController lc = Get.find<LanguageController>();
      List<TabBarModel> items = [];

      final res = await ApiService.processList("shipping-statuses");
      final len = res?["result"].length ?? 0;
      items.add(
        TabBarModel(
          titleText: lc.getLang("All"),
          body: const OrderList(order: 0, trimDigits: true),
        )
      );
      for (var i = 0; i < len; i++) {
        ShippingStatusModel model = ShippingStatusModel.fromJson(res?["result"][i]);
        items.add(
          TabBarModel(
            titleText: model.name,
            body: OrderList(order: model.order, trimDigits: true),
          )
        );
      }
      tabListshippingStatuses = items;
      if(needUpdate) update();
    } catch (e) {
      if(kDebugMode) print('$e');
    }
  }


  updateYoutubeDuration(Duration? duration, { bool needUpdate = true}) {
    youtubeDuration = duration;
    if(needUpdate) update();
  }
}
