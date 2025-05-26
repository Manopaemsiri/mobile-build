import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/controller/app_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CustomerGroupAddressController extends GetxController {
  final CustomerGroupModel group;
  CustomerGroupAddressController(this.group);

  final AppController _appController = Get.find<AppController>();
  bool _enabledCustomerGroup = false;
  bool get enabledCustomerGroup => _enabledCustomerGroup;
  
  final LanguageController _lController = Get.find<LanguageController>();
  LanguageController get lController => _lController;

  List<CustomerShippingAddressModel> _addresses = [];
  List<CustomerShippingAddressModel> get addresses => _addresses;
  bool get canUpdateShipping => group.canUpdateShipping == 1;

  List<CustomerBillingAddressModel> _billingAddresses = [];
  List<CustomerBillingAddressModel> get billingAddresses => _billingAddresses;
  bool get canUpdateBilling => group.canUpdateBilling == 1;

  bool isReday = false;

  @override
  void onInit() {
    _onInit();
    super.onInit();
  }
  @override
  void onClose() {
    super.onClose();
  }

  Future<void> _onInit() async {
    await Future.wait([
      _getShippingAddresses(),
      _getBillingAddresses(),
      _appController.getSetting(),
    ]);
    _enabledCustomerGroup = _appController.enabledCustomerGroup;
    isReday = true;
    update();
  }

  Future<void> _getShippingAddresses() async {
    try {
      Map<String, dynamic>? res = await ApiService.processList('shipping-addresses');
      if(res?['result'].isNotEmpty == true){
        final int len = res?['result'].length ?? 0;
        for (var i = 0; i < len; i++) {
          _addresses.add(CustomerShippingAddressModel.fromJson(res!['result'][i]));
        }
      }
    } catch (e) {
      if(kDebugMode) printError(info: e.toString());
    }
  }
  Future<void> _getBillingAddresses() async {
    try {
      Map<String, dynamic>? res = await ApiService.processList('billing-addresses');
      if(res?['result'].isNotEmpty == true){
        final int len = res?['result'].length ?? 0;
        for (var i = 0; i < len; i++) {
          _billingAddresses.add(CustomerBillingAddressModel.fromJson(res!['result'][i]));
        }
      }
    } catch (e) {
      if(kDebugMode) printError(info: e.toString());
    }
  }

}