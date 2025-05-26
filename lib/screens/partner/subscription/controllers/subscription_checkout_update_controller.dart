import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:get/get.dart';

import '../../../../controller/customer_controller.dart';
import '../../../../models/index.dart';
import '../../../customer/address/list.dart';
import '../../../customer/billing_address/list.dart';
import '../../../customer/shipping/list.dart';

class SubscriptionCheckoutUpdateController extends GetxController {
  final CustomerSubscriptionModel subscription;
  final List<SelectionSteps> productStep;
  SubscriptionCheckoutUpdateController({
    required this.subscription, 
    required this.productStep 
  }): super();

  int stateStatus = 0;

  CustomerSubscriptionCartModel? _data;
  CustomerSubscriptionCartModel? get data => _data;

  List<PartnerProductModel> _products = [];
  List<PartnerProductModel> get products => _products;

  PartnerShippingFrontendModel? _shippingMethod;
  PartnerShippingFrontendModel? get shippingMethod => _shippingMethod;
  

  @override
  void onInit() {
    _onInit();
    super.onInit();
  }
  
  Future<void> _onInit() async {
    Get.find<CustomerController>().updateBillingAddress(subscription.billingAddress);
    Get.find<CustomerController>().updateShippingAddress(subscription.shippingAddress);
    _shippingMethod = subscription.shippingFrontend;
    try {
      final res = await ApiService.processList('subscription-plans', input: {
        'dataFilter': { 'subscriptionId': subscription.id }
      });
      var len = res?['result'].length;
      CustomerSubscriptionPlanModel _temp 
        = CustomerSubscriptionPlanModel.fromJson(res!['result'][len-1]);

      _data = CustomerSubscriptionCartModel(
        subscription: subscription.subscription,
        shippingAddress: subscription.shippingAddress,
        billingAddress: subscription.billingAddress,
        relatedProducts: subscription.relatedProducts,
        total: _temp.total,
        grandTotal: _temp.total,
      );
      await _getProducts();
      stateStatus = 1;
      update();
      return;
    } catch (_) {}
    stateStatus = 3;
    update();
    return;
  }

  Future<void> _getProducts() async {
    List<RelatedProduct> _steps = productStep
      .map((d) => d.products)
      .expand((d) => d)
      .where((d) => d.quantity > 0)
      .toList();

    _products = _steps.map((d) {
      PartnerProductModel k = d.product!;
      k.inCart = d.quantity;
      k.quantity = d.quantity;
      k.addPriceInVAT = d.addPriceInVAT > 0? d.addPriceInVAT: 0;
      return k;
    }).toList();
  }

  updateShippingAddress(CustomerShippingAddressModel? value) async {
    if(value != null){
      final res = await ApiService.processUpdate('subscription-cart', input: { 'type': 2, 'shippingAddressId': value.id });
      if(res) _data = _data?.copyWith( shippingAddress: value );
    }else { _data = _data?.copyWith( shippingAddress: value ); }
    update();
  }
  updateBillingAddress(CustomerBillingAddressModel? value) async {
    if(value != null){
      final res = await ApiService.processUpdate('subscription-cart', input: { 'type': 3, 'billingAddressId': value.id });
      if(res) _data = _data?.copyWith( billingAddress: value );
    }else { _data = _data?.copyWith( billingAddress: value ); }
    update();
  }
  updateShippingMethod(PartnerShippingFrontendModel? value) {
    _shippingMethod = value;
    update();
  }

  int countCartProducts() => _products.fold(0, (prev, d) => prev + d.inCart);
  double checkoutTotal() => _data?.displayGrandTotal(shippingMethod) ?? 0;
  void onSubmit() {
    if(_data == null || _products.isEmpty){
      ShowDialog.showErrorToast(
        title: lController.getLang("Error"),
        desc: lController.getLang("please try again later"), 
      );
      return;
    }
    if(_data?.shippingAddress == null || _data?.shippingAddress?.isValid() != true){
      ShowDialog.showForceDialog(
        lController.getLang("Missing shipping address"),
        lController.getLang("Please choose a shipping address"), 
        () {
          Get.back();
          Get.to(() => const AddressScreen(subscription: 2));
        }
      );
      return;
    }
    if(_shippingMethod == null || _shippingMethod?.isValid() != true){
      ShowDialog.showForceDialog(
        lController.getLang("Missing Shipping Method"),
        lController.getLang("Please choose a shipping method"), 
        () {
          Get.back();
          Get.to(() => const ShippingMethodsScreen(subscription: 2));
        }
      );
      return;
    }
    if(_data?.billingAddress == null || _data?.billingAddress?.isValid() != true){
      ShowDialog.showForceDialog(
        lController.getLang("Missing Billing Address"),
        lController.getLang("Continue without billing address"), 
        () {
          Get.until((route) => route.settings.name == '/CustomerSubscriptionScreen');
        },
        onCancel: () {
          Get.back();
          Get.to(() => const BillingAddressesScreen(subscription: 2));
        },
        confirmText: lController.getLang("Yes"),
        cancelText: lController.getLang("No"),
      );
      return;
    }
    Get.until((route) => route.settings.name == '/CustomerSubscriptionScreen');
    return;
  }


}