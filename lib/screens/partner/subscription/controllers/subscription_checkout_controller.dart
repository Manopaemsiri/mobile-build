import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:get/get.dart';

import '../../../../controller/customer_controller.dart';
import '../../../../models/index.dart';
import '../../../customer/address/list.dart';
import '../../../customer/billing_address/list.dart';
import '../../../customer/shipping/list.dart';
import '../../subscription_conditions/read.dart';

class SubscriptionCheckoutController extends GetxController {
  SubscriptionCheckoutController();

  int stateStatus = 0;

  CustomerSubscriptionCartModel? dataModel;
  CustomerSubscriptionCartModel? get data => dataModel;

  List<PartnerProductModel> dataProducts = [];
  List<PartnerProductModel> get products => dataProducts;

  PartnerShippingFrontendModel? _shippingMethod;
  PartnerShippingFrontendModel? get shippingMethod => _shippingMethod;


  @override
  void onInit() {
    _onInit();
    super.onInit();
  }
  
  Future<void> _onInit() async {
    Get.find<CustomerController>().updateBillingAddress(null);
    Get.find<CustomerController>().updateShippingAddress(null);
    try {
      final res = await ApiService.processRead('subscription-cart');
      if(res?['result']?.isNotEmpty == true){
        dataModel = CustomerSubscriptionCartModel.fromJson(res?['result']);
        await Future.wait([
          _getShippingAddress(),
          _getProducts(),
        ]);
        stateStatus = 1;
        update();
        return;
      }
    } catch (_) {}
    stateStatus = 3;
    update();   
    return;
  }
  Future<void> _getShippingAddress() async {
    try {
      final res = await ApiService.processRead('shipping-address-get-selected');
      if(res?['result']?.isNotEmpty == true){
        final CustomerShippingAddressModel shippingAddress = CustomerShippingAddressModel.fromJson(res?['result']);
        Get.find<CustomerController>().updateShippingAddress(shippingAddress);
        dataModel = dataModel?.copyWith( shippingAddress: shippingAddress );
        await updateShippingAddress(shippingAddress);
      }
    } catch (_) {}
    update();
  }

  Future<void> _getProducts() async {
    List<RelatedProduct> dataSteps = (dataModel?.selectionSteps ?? [])
      .map((d) => d.products)
      .expand((d) => d)
      .where((d) => d.inCart > 0)
      .toList();
    if(dataModel?.relatedProducts.isNotEmpty == true){
      dataSteps.insertAll(0, dataModel!.relatedProducts);
      dataSteps = dataSteps.where((d) => d.inCart > 0).toList();
    }

    dataProducts = dataSteps.map((d) {
      PartnerProductModel k = d.product!;
      k.inCart = d.inCart;
      k.addPriceInVAT = d.addPriceInVAT > 0? d.addPriceInVAT: 0;
      return k;
    }).toList();
  }


  updateShippingAddress(CustomerShippingAddressModel? value) async {
    if(value != null){
      final res = await ApiService.processUpdate('subscription-cart', input: { 'type': 2, 'shippingAddressId': value.id });
      if(res) dataModel = dataModel?.copyWith( shippingAddress: value );
    }else { dataModel = dataModel?.copyWith( shippingAddress: value ); }
    update();
  }
  updateBillingAddress(CustomerBillingAddressModel? value) async {
    if(value != null){
      final res = await ApiService.processUpdate('subscription-cart', input: { 'type': 3, 'billingAddressId': value.id });
      if(res) dataModel = dataModel?.copyWith( billingAddress: value );
    }else { dataModel = dataModel?.copyWith( billingAddress: value ); }
    update();
  }
  updateShippingMethod(PartnerShippingFrontendModel? value) {
    _shippingMethod = value;
    update();
  }

  int countCartProducts() => dataProducts.fold(0, (prev, d) => prev + d.inCart);
  double checkoutTotal() => dataModel?.displayGrandTotal(shippingMethod) ?? 0;
  void onSubmit() {
    if(dataModel == null || dataProducts.isEmpty){
      ShowDialog.showErrorToast(
        title: lController.getLang("Error"),
        desc: lController.getLang("please try again later"), 
      );
      return;
    }
    if(dataModel?.shippingAddress == null || dataModel?.shippingAddress?.isValid() != true){
      ShowDialog.showForceDialog(
        lController.getLang("Missing shipping address"),
        lController.getLang("Please choose a shipping address"), 
        () {
          Get.back();
          Get.to(() => const AddressScreen(subscription: 1));
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
          Get.to(() => const ShippingMethodsScreen(subscription: 1));
        }
      );
      return;
    }
    if(dataModel?.billingAddress == null || dataModel?.billingAddress?.isValid() != true){
      ShowDialog.showForceDialog(
        lController.getLang("Missing Billing Address"),
        lController.getLang("Continue without billing address"), 
        () {
          Get.back();
          Get.to(() => SubscriptionConditionsScreen(data: dataModel!, shipping: shippingMethod!));
        },
        onCancel: () {
          Get.back();
          Get.to(() => const BillingAddressesScreen(subscription: 1));
        },
        confirmText: lController.getLang("Yes"),
        cancelText: lController.getLang("No"),
      );
      return;
    }
    Get.to(() => SubscriptionConditionsScreen(data: dataModel!, shipping: shippingMethod!));
  }
}