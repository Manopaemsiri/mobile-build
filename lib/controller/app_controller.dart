import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/models/index.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AppController extends GetxController {
  bool enabledMultiPartnerShops = true;
  bool enabledMultiCustomerShops = true;
  List<PartnerProductStatusModel> productStatuses = [];

  Map<String, dynamic> _settings = {};
  dynamic settings({required String key}){
    if(key.isEmpty) return '';
    try {
      return _settings[key];
    }catch (_){}
    return '';
  }

  bool _enabledCustomerGroup = false;
  bool get enabledCustomerGroup => _enabledCustomerGroup;

  @override
  onInit() {
    refreshData();
    super.onInit();
  }

  Future<void> refreshData() async {
    enabledMultiPartnerShops = true;
    enabledMultiCustomerShops = true;
    productStatuses = [];

    await Future.wait([
      _readEnabledMultiPartnerShops(),
      _readEnabledMultiCustomerShops(),
      _listPartnerProductStatuses(),
      // _getSettingValue(key: 'APP_MODULE_PARTNER_SUBSCRIPTION'),
      _getSettings(),
      _getSetting(),
    ]);

    update();
  }

  Future<void> _readEnabledMultiPartnerShops() async {
    try{
      Map<String, dynamic>? res = await ApiService.processRead("enabled-multi-partner-shops");
      if(res!["result"] != null && res["result"]["enabled"] != null){
        enabledMultiPartnerShops = res["result"]["enabled"] as bool;
      }
    } catch(e) {
      if(kDebugMode) print('$e');
    }
  }

  Future<void> _readEnabledMultiCustomerShops() async {
    try{
      Map<String, dynamic>? res = await ApiService.processRead("enabled-multi-customer-shops");
      if(res!["result"] != null && res["result"]["enabled"] != null){
        enabledMultiCustomerShops = res["result"]["enabled"] as bool;
      }
    } catch(e) {
      if(kDebugMode) print('$e');
    }
  }

  Future<void> _listPartnerProductStatuses() async {
    try{
      Map<String, dynamic>? res = await ApiService.processList("partner-product-statuses");
      if(res?["result"].isNotEmpty == true){
        int _len = res?['result'].length ?? 0;
        for(int i=0; i<_len; i++){
          productStatuses.add(PartnerProductStatusModel.fromJson(res!['result'][i]));
        }
      }
    } catch(e) {
      if(kDebugMode) print('$e');
    }
  }

  // Future<void> _getSettingValue({required String key}) async {
  //   if(key.isNotEmpty){
  //     try{
  //       Map<String, dynamic>? res = await ApiService.processRead("setting", input: { 'name': key });
  //       if(res?["result"].isNotEmpty == true){
  //         if(key == 'APP_MODULE_PARTNER_SUBSCRIPTION'){
  //           _enabledPartnerSubscription = res?["result"] == '1';
  //         }else if(key == 'APP_MODULE_CUSTOMER_GROUP'){
  //           _enabledCustomerGroup = res?["result"] == '1';
  //         }
  //         update();
  //       }
  //     } catch(_) {}
  //   }
  // }
  Future<void> _getSettings() async {
    try{
      Map<String, dynamic>? res = await ApiService.processRead("settings");
      if(res?["result"].isNotEmpty == true){
        _settings = res?["result"];
        update();
      }
    } catch(_) {}
  }
  Future<void> getSetting() => _getSetting();
  Future<void> _getSetting() async {
    try{
      Map<String, dynamic>? res = await ApiService.processRead("setting", input: { 'name': 'APP_MODULE_CUSTOMER_GROUP' });
      if(res?["result"].isNotEmpty == true) _enabledCustomerGroup = res?["result"] == '1';
      
    } catch(_) {}
    update();
  }

  Future<void> refreshSettings() async {
    // _getSettings();
  }

}
