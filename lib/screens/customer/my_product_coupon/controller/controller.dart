import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class MyProductCouponController extends GetxController {
  // with StateMixin<PartnerProductCouponModel> {
  final String _id;
  MyProductCouponController(this._id);

  PartnerProductCouponModel? _data;
  List<CustomerTierModel> _customerTiers = [];
  
  StateStatus widgetStatus = StateStatus.Loading;
  String _errorMsg = "";

  PartnerProductCouponModel? get data => _data;
  List<CustomerTierModel> get customerTiers => _customerTiers;
  StateStatus get status => widgetStatus;
  String get errorMsg => _errorMsg;
  
  @override
  void onInit() {
    super.onInit();
    _onInit();
  }

  Future<void> _onInit() async {
    widgetStatus = StateStatus.Loading;
    _errorMsg = "";

    try {
      Map<String, dynamic> input = { "_id": _id };
      final res = await ApiService.processRead("my-partner-product-coupon", input: input );

      _data = PartnerProductCouponModel.fromJson(res?["result"]);

      if(_data?.forAllCustomerTiers == 1){
        var res2 = await ApiService.processList('customer-tiers');
        if(res2!["result"] != null){
          List<CustomerTierModel> temp = [];
          var len = res2['result'].length;
          for(var i = 0; i < len; i++){
            CustomerTierModel model = CustomerTierModel.fromJson(res2["result"][i]);
            temp.add(model);
          }
          _customerTiers = temp;
        }
      }

      if(_data != null){
        widgetStatus = StateStatus.Success;
      }
    } catch (e) {
      widgetStatus = StateStatus.Error;
      _errorMsg = "Error";
    }
    update();
  }
}