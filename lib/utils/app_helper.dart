import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/data/local_storage/local_storage.dart';
import 'package:coffee2u/models/index.dart';

class AppHelpers{

  static Future<void> updatePartnerShop(CustomerController controller) async {
    String shopId = '';
    final clearance = checkProductClearance(controller.cart);
    if(controller.partnerShop == null || clearance || controller.partnerShop?.type == 9){
      final res = await ApiService.processRead('partner-shop-center');
      shopId = res?['result']['_id'];
      await controller.updateCartShop(shopId, needLoading: false);
      return;
    }
    shopId = controller.partnerShop?.id ?? '';
    await controller.updateCartShop(shopId, needLoading: false);
    return;
  }

  static bool checkProductClearance(CustomerCartModel cart) {
    return cart.products.indexWhere((e) => 
      (e.selectedUnit != null && e.selectedUnit?.status == 3)
      || (e.status == 3 && e.selectedUnit == null)
    ) > -1;
  }

  static Future<void> saveCoupon(String key, String id) async {
    List<String> data = await LocalStorage.getStringList(key) ?? [];
    data.add(id);
    data = data.toSet().toList();
    LocalStorage.saveStringList(key, data);
  }
  static Future<List<String>> getAllCoupons(String key) async {
    final List<String> data = await LocalStorage.getStringList(key) ?? [];
    return data;
  }
  static Future<void> reduceCoupon(String key, String id) async {
    final temp = await AppHelpers.getAllCoupons(key);
    final index = temp.indexWhere((d) => d == id);
    if(index > -1) {
      temp.removeAt(index);
      LocalStorage.saveStringList(key, temp);
    }
  }
  static Future<void> clearAllCoupons(String cusId) async {
    String prefKey = "";
    prefKey = "$cusId$prefCustomerCashCoupon";
    await LocalStorage.clear(prefKey);

    prefKey = "";
    prefKey = "$cusId$prefCustomerDiscountProduct";
    await LocalStorage.clear(prefKey);

    prefKey = "";
    prefKey = "$cusId$prefCustomerShippingCoupon";
    await LocalStorage.clear(prefKey);
  }
}