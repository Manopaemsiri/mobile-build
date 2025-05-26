import 'dart:math';
import 'dart:developer' as customerLog;

import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/data/local_storage/local_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerController extends GetxController {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  CustomerModel? customerModel;
  CustomerTierModel? tier;
  PartnerShopModel? partnerShop;

  CustomerCartModel cart = CustomerCartModel();
  CustomerShippingAddressModel? shippingAddress;
  CustomerBillingAddressModel? billingAddress;
  PartnerShippingFrontendModel? shippingMethod;
  PaymentMethodModel? paymentMethod;

  PartnerShippingCouponModel? discountShipping;
  PartnerProductCouponModel? discountProduct;
  PartnerProductCouponModel? discountCash;
  CustomerPointFrontendModel? discountPoint;

  List<PartnerProductModel> fbProducts = [];
  List<PartnerProductModel> frProducts = [];

  syncData() async {
    customerModel = null;
    partnerShop = null;
    cart = CustomerCartModel();
    shippingAddress = null;
    billingAddress = null;
    fbProducts = [];
    frProducts = [];

    await LocalStorage.clear(prefCustomerCart);
    await LocalStorage.clear(prefCustomerShippingAddress);
    await LocalStorage.clear(prefCustomerBillingAddress);

    // await LocalStorage.save(PREF_SKIP_INTRO, false);

    final prefs = await SharedPreferences.getInstance();
    // prefs.remove(PREF_CUSTOMER);

    String? strCustomer = prefs.getString(prefCustomer);
    if (strCustomer != null) {
      CustomerModel customer = customerModelFromJson(strCustomer);
      await ApiService.guestInit(customerId: customer.id ?? '');
    } else {
      await ApiService.guestInit();
    }

    update();
  }

  bool isCustomer() {
    if (customerModel != null && customerModel?.isGuest == 0) {
      return true;
    } else {
      return false;
    }
  }
  Future<void> updateCustomer(CustomerModel? model, { PartnerShopModel? value }) async {
    if (model != null) {
      final _m = model;
      customerModel = _m;
      customerModel?.partnerShop = value;
      partnerShop = value;
      if(partnerShop?.type == 9) {
        final tempPartnerShop = await ApiService.processRead('partner-shop-center');
        partnerShop = tempPartnerShop != null
        ? PartnerShopModel.fromJson(tempPartnerShop['result'])
        : null;
        customerModel?.partnerShop = partnerShop;
      }
      await LocalStorage.save(prefCustomer, customerModelToJson(customerModel!));
    } else {
      customerModel = null;
      partnerShop = null;
      cart = CustomerCartModel();
      shippingAddress = null;
      billingAddress = null;

      await LocalStorage.clear(prefCustomer);
      await LocalStorage.clear(prefCustomerCart);
      await LocalStorage.clear(prefCustomerShippingAddress);
      await LocalStorage.clear(prefCustomerBillingAddress);
    }
    update();
  }
  void updateCustomerAccount({
    String firstname='', String lastname='',
    String email='', FileModel? avatar,
  }){
    if(isCustomer()){
      customerModel!.firstname = firstname;
      customerModel!.lastname = lastname;
      customerModel!.email = email;
      if(avatar != null){
        customerModel!.avatar = avatar;
      }
      update();
    }
  }
  bool isShowStock() {
    if(customerModel == null) return false;
    bool isCenterShop = partnerShop?.type == 1 || partnerShop == null || partnerShop?.type == 9;
    bool isOpenClickAndCollect = partnerShop?.isOpenClickAndCollect() == true;
    return !isCenterShop && isOpenClickAndCollect;
  }

  Future<void> updateShippingAddress(CustomerShippingAddressModel? model) async {
    if(model?.id != shippingAddress?.id){
      shippingMethod = null;
      discountShipping = null;
      discountProduct = null;
      discountCash = null;
    }
    if (model != null) {
      shippingAddress = model;
      await LocalStorage.save(
        prefCustomerShippingAddress, 
        customerShippingAddressModelToJson(model)
      );
    } else {
      shippingAddress = null;
      await LocalStorage.clear(prefCustomerShippingAddress);
    }
    update();
  }

  Future<void> updateBillingAddress(CustomerBillingAddressModel? model) async {
    if (model != null) {
      billingAddress = model;
      await LocalStorage.save(prefCustomerBillingAddress, customerBillingAddressModelToJson(model));
    } else {
      billingAddress = null;
      await LocalStorage.clear(prefCustomerBillingAddress);
    }
    update();
  }

  Future<void> clear() async {
    customerModel = null;
    cart = CustomerCartModel();
    shippingAddress = null;
    billingAddress = null;
    partnerShop = null;
    fbProducts = [];
    frProducts = [];
    await LocalStorage.clear(prefCustomer);
    await LocalStorage.clear(prefCustomerCart);
    await LocalStorage.clear(prefCustomerShippingAddress);
    await LocalStorage.clear(prefCustomerBillingAddress);

    await LocalStorage.clearAll();
    update();
  }


  // START: Cart
  Future<void> updateCart(CustomerCartModel? model) async {
    customerLog.log("CUSTOMER: Update Cart");
    if (model != null) {
      cart = model;
      await LocalStorage.save(prefCustomerCart, customerCartModelToJson(model));
    } else {
      cart = CustomerCartModel();
      await LocalStorage.clear(prefCustomerCart);
    }
    update();
  }
  Future<void> readCart({bool needLoading = true}) async {
    await ApiService.readCart(needLoading: needLoading);
    update();
  }

  Future<bool> addCart(PartnerProductModel product, int quantity, {
    PartnerProductUnitModel? unit,
    required bool isClearance,
    String? eventId, String? eventName
  }) async {
    String shopId = '';
    List<Map<String, dynamic>> products = [];

    var len = cart.products.length;
    for(var i=0; i<len; i++){
      PartnerProductModel item = cart.products[i];
      products.add({
        "_id": item.id,
        "inCart": item.inCart,
        "selectedUnitId": item.selectedUnit != null ? item.selectedUnit!.id : '',
        "eventId": item.eventId,
        "eventName": item.eventName,
        "status": item.status,
      });
    }
    products.add({
      "_id": product.id,
      "inCart": quantity,
      "selectedUnitId": unit == null ? '' : unit.id,
      "eventId": eventId,
      "eventName": eventName,
      "status": product.status,
    });

    if(partnerShop != null && partnerShop?.type != 9 && !isClearance){
      shopId = partnerShop!.id ?? '';
    }else {
      var data1 = await ApiService.processRead('partner-shop-center');
      shopId = data1!['result']['_id'];
    }
    await calculateCart(shopId, products);
    return true;
  }

  removeCartProduct(int index) async {
    String shopId = cart.shop!.id ?? '';
    List<Map<String, dynamic>> products = [];

    var len = cart.products.length;
    for(var i=0; i<len; i++){
      if(i != index){
        PartnerProductModel item = cart.products[i];
        products.add({
          "_id": item.id,
          "inCart": item.inCart,
          "selectedUnitId": item.selectedUnit != null 
            ? item.selectedUnit!.id : '',
          "eventId": item.eventId,
          "eventName": item.eventName,
          "status": item.status,
        });
      }
    }
    await calculateCart(shopId, products);
  }
  updateCartProduct(int index, int inCart) async {
    String shopId = cart.shop!.id ?? '';
    List<Map<String, dynamic>> products = [];

    var len = cart.products.length;
    for(var i=0; i<len; i++){
      PartnerProductModel item = cart.products[i];
      if(i != index){
        products.add({
          "_id": item.id,
          "inCart": item.inCart,
          "selectedUnitId": item.selectedUnit != null
            ? item.selectedUnit!.id: '',
          "eventId": item.eventId,
          "eventName": item.eventName,
          "status": item.status,
        });
      }else if(inCart > 0){
        products.add({
          "_id": item.id,
          "inCart": inCart,
          "selectedUnitId": item.selectedUnit != null
            ? item.selectedUnit!.id: '',
          "eventId": item.eventId,
          "eventName": item.eventName,
          "status": item.status,
        });
      }
    }
    await calculateCart(shopId, products);
  }

  updateCartShop(String shopId, { bool needLoading = true}) async {
    List<Map<String, dynamic>> products = [];
    var len = cart.products.length;
    for(var i=0; i<len; i++){
      PartnerProductModel item = cart.products[i];
      products.add({
        "_id": item.id,
        "inCart": item.inCart,
        "selectedUnitId": item.selectedUnit != null
          ? item.selectedUnit!.id: '',
        "eventId": item.eventId,
        "eventName": item.eventName,
        "status": item.status,
      });
    }
    await calculateCart(shopId, products, needLoading: needLoading);
  }
  
  updateCartBuyAgain(String shopId, List<PartnerProductModel> items) async {
    List<Map<String, dynamic>> products = [];
    var len = items.length;
    for(var i=0; i<len; i++){
      PartnerProductModel item = items[i];
      products.add({
        "_id": item.id,
        "inCart": item.inCart,
        "selectedUnitId": item.selectedUnit != null
          ? item.selectedUnit!.id: '',
        "status": item.status,
        // "eventId": item.eventId,
        // "eventName": item.eventName,
      });
    }
    await calculateCart(shopId, products);
  }

  Future<void> calculateCart(String shopId, List<Map<String, dynamic>> products, { bool needLoading = true}) async {
    await ApiService.updateCart(shopId, products, needLoading: needLoading);
    update();
  }

  int countCartProducts() {
    int temp = 0;
    List<PartnerProductModel> _products = cart.products.where((d) => d.status != -2).toList();
    var len = _products.length;
    for (var i = 0; i < len; i++) {
      PartnerProductModel item = _products[i];
      temp += item.inCart;
    }
    return temp;
  }
  String displayCartTotal(LanguageController controller, { bool trimDigits = false }) {
    return priceFormat(cart.total, controller ,digits: 2, trimDigits: trimDigits);
  }
  // END: Cart


  // START: Personal
  Future<void> updateTier() async {
    var res = await ApiService.processRead('tier');
    if(res!['result'] != null && res['result']!['data'] != null){
      tier = CustomerTierModel.fromJson(res['result']['data']);
    }else{
      tier = null;
    }
    update();
  }
  // END: Personal


  // START: Checkout
  Future<void> clearStateToNull() async {
    shippingMethod = null;
    discountShipping = null;
    discountProduct = null;
    discountCash = null;
    update();
  }
  Future<void> setShippingMethod(PartnerShippingFrontendModel? method) async {
    shippingMethod = method;
    if(method != null && method.isValid()){
      update();
    }
  }
  setPaymentMethod(PaymentMethodModel? method) {
    paymentMethod= method;
    if(method != null && method.isValid()){
      update();
    }
  }
  
  Future<void> setDiscountShipping(PartnerShippingCouponModel? value, {bool needUpdate=false}) async {
    discountShipping = value;
    if(needUpdate) update();
  }
  Future<void> setDiscountProduct(PartnerProductCouponModel? value, {bool needUpdate=false}) async {
    discountProduct = value;
    if(needUpdate) update();
  }
  Future<void> setDiscountCash(PartnerProductCouponModel? value, {bool needUpdate=false}) async {
    discountCash = value;
    if(needUpdate) update();
  }
  Future<void> setDiscountPoint(CustomerPointFrontendModel? value, {bool needUpdate=false}) async {
    discountPoint = value;
    if(needUpdate) update();
  }

  double checkoutTotal() {
    return max(0, double.parse((
      cart.total 
        - (discountProduct == null? 0: discountProduct!.actualDiscount) 
        + (shippingMethod == null? 0: shippingMethod!.price) 
        - (discountShipping == null || shippingMethod?.type == 2? 0: discountShipping!.actualDiscount) 
        - (discountCash == null? 0: discountCash!.actualDiscount) 
        - (discountPoint == null? 0: discountPoint!.discount) 
    ).toStringAsFixed(2)));
  }
  double cartMissingPayment() {
    return max(0, double.parse((
      cart.missingPayment 
        - (discountProduct != null && discountProduct!.hasMissingPaymentDiscount() 
          ? discountProduct!.missingPaymentDiscount: 0) 
        - (discountCash != null && discountCash!.hasMissingPaymentDiscount() 
          ? discountCash!.missingPaymentDiscount: 0) 
    ).toStringAsFixed(2)));
  }
  double cartDiffInstallmentDiscount() {
    return max(0, double.parse((
      discountProduct != null && discountProduct!.hasIntallmentDiscount() 
        ? discountProduct!.diffInstallmentDiscount: 0 
    ).toStringAsFixed(2)));
  }
  
  int pointEarn() {
    if(!isCustomer() || customerModel?.tier == null){
      return 0;
    }else{
      return cart.pointEarn.floor();
    }
  }
  // END: Checkout


  // START: Frequently Bought Products
  Future<void> updateFrequentlyProducts({PartnerShopModel? shop}) async {
    List<PartnerProductModel> temp = [];
    var res = await ApiService.processList('frequently-bought-products', input: {
      "dataFilter": { "partnerShopId": shop?.id ?? partnerShop?.id }
    });
    if(res!['result'] != null){
      var len = res['result'].length;
      for (var i = 0; i < len; i++) {
        PartnerProductModel model = PartnerProductModel.fromJson(res['result'][i]);
        temp.add(model);
      }
    }
    fbProducts = temp;
    update();
  }
  updateFrequentlyProduct(int index, int inCart) {
    fbProducts[index].inCart = inCart;
    update();
  }
  
  Future<bool> checkoutFrequentlyProducts(PartnerShopModel? shop) async {
    if(shop != null && shop.isValid()){
      List<Map<String, dynamic>> products = [];
      var len = fbProducts.length;
      for(var i=0; i<len; i++){
        PartnerProductModel item = fbProducts[i];
        if(item.inCart > 0){
          products.add({
            "_id": item.id,
            "inCart": item.inCart,
            "selectedUnitId": item.selectedUnit != null
              ? item.selectedUnit!.id: '',
            "status": item.status,
            // "eventId": item.eventId,
            // "eventName": item.eventName,
          });
        }
      }
      if(products.isNotEmpty){
        await calculateCart(shop.id ?? '', products);
        return true;
      }
    }
    return false;
  }

  int countFrequentlyProducts() {
    int temp = 0;
    var len = fbProducts.length;
    for (var i = 0; i < len; i++) {
      PartnerProductModel item = fbProducts[i];
      temp += item.inCart;
    }
    return temp;
  }
  double getFrequentlyTotal() {
    double temp = 0;
    var len = fbProducts.length;
    for (var i = 0; i < len; i++) {
      PartnerProductModel item = fbProducts[i];
      if(item.selectedUnit == null){
        if(item.isValidDownPayment()){
          temp += item.inCart * item.getDownPayment();
        }else if(item.isDiscounted()){
          temp += item.inCart * item.getDiscountPrice();
        }else{
          temp += item.inCart * item.getMemberPrice();
        }
      }else{
        if(item.selectedUnit!.isValidDownPayment()){
          temp += item.inCart * item.selectedUnit!.getDownPayment();
        }else if(item.selectedUnit!.isDiscounted()){
          temp += item.inCart * item.selectedUnit!.getDiscountPrice();
        }else{
          temp += item.inCart * item.selectedUnit!.getMemberPrice();
        }
      }
    }
    return temp;
  }
  String displayFrequentlyTotal(LanguageController controller, {bool showSymbol = true, bool trimDigits = false}) {
    double temp = 0;
    var len = fbProducts.length;
    for (var i = 0; i < len; i++) {
      PartnerProductModel item = fbProducts[i];
      if(item.selectedUnit == null){
        if(item.isDiscounted()){
          temp += item.inCart * item.getDiscountPrice();
        }else{
          temp += item.inCart * item.getMemberPrice();
        }
      }else{
        if(item.selectedUnit!.isDiscounted()){
          temp += item.inCart * item.selectedUnit!.getDiscountPrice();
        }else{
          temp += item.inCart * item.selectedUnit!.getMemberPrice();
        }
      }
    }
    return priceFormat(temp, controller, digits: 2, showSymbol: showSymbol, trimDigits: trimDigits);
  }
  // END: Frequently Bought Products

  // START: Favorite Products
  Future<void> updateFavoriteProducts({PartnerShopModel? shop}) async {
    List<PartnerProductModel> temp = [];
    var res = await ApiService.processList('favorite-products', input: {
      "dataFilter": { "partnerShopId": shop?.id ?? partnerShop?.id }
    });
    if(res!['result'] != null){
      var len = res['result'].length;
      for (var i = 0; i < len; i++) {
        PartnerProductModel model = PartnerProductModel.fromJson(res['result'][i]);
        temp.add(model);
      }
    }
    frProducts = temp;
    update();
  }
  Future<void> toggleFavoriteProduct(String productId) async {
    if(productId != ''){
      await ApiService.processUpdate(
        'favorite-product', input: { "productId": productId }
      );
      await updateFavoriteProducts();
    }
  }
  bool isFavoriteProduct(PartnerProductModel model) {
    bool temp = false;
    var len = frProducts.length;
    for (var i=0; i<len; i++) {
      PartnerProductModel item = frProducts[i];
      if(item.id == model.id){
        temp = true;
      }
    }
    return temp;
  }
  // END: Favorite Products

  // 
  clearCheckout() async {
    await Future.wait([
      updateTier(),
      updateBillingAddress(null),
      setShippingMethod(null),
      setDiscountShipping(null),
      setDiscountProduct(null),
      setDiscountCash(null),
      setDiscountPoint(null),
    ]);
  }
}