import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/customer/checkout/components/click_and_collect_shops.dart';
import 'package:coffee2u/screens/customer/shipping/components/shipping_item.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../partner/subscription/controllers/subscription_checkout_controller.dart';
import '../../partner/subscription/controllers/subscription_checkout_update_controller.dart';

// subscription == 1: Subscription Checkout
// subscription == 2: Customer Subscription Update

class ShippingMethodsScreen extends StatefulWidget {
  const ShippingMethodsScreen({
    super.key,
    this.subscription,
  });
  final int? subscription;

  @override
  State<ShippingMethodsScreen> createState() => _ShippingMethodsScreenState();
}

class _ShippingMethodsScreenState extends State<ShippingMethodsScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  final CustomerController controllerCustomer = Get.find<CustomerController>();

  List<Map<String, dynamic>> dataModel = [];

  bool isReady = false;
  bool isClearance = false;

  bool onClick = false;

  late int? subscription = widget.subscription;

  @override
  void initState() {
    super.initState();
    _initState();
  }

  Future<void> _initState() async {
    if(subscription != null){
      try {
        final res = await ApiService.processList(subscription == 1 
          ? 'subscription-shipping-methods' 
          : '', input: { 'dataFilter': { 'showClickAndCollect': 1, }});
        int len = res?['result'].length ?? 0;
        for (var i = 0; i < len; i++) {
          dataModel.add({'shipping': PartnerShippingFrontendModel.fromJson(res?['result'][i]) });
        }

        isClearance = controllerCustomer.cart.products.indexWhere((e) => e.status == 3) > -1? true: false;
        if(mounted){
          setState(() {
            dataModel;
            isClearance;
            isReady = true;
          });
        }
      } catch (e) {
        if(kDebugMode) print('$e');
        if(mounted){
          setState(() {
            dataModel = [];
            isClearance;
            isReady = true;
          });
        }
      }
    }else{
      try {
        final res = await ApiService.processList('checkout-shipping-methods', input: { 'dataFilter': { 'showClickAndCollect': 1 }});
        int len = res?['result'].length ?? 0;
        for (var i = 0; i < len; i++) {
          dataModel.add({'shipping': PartnerShippingFrontendModel.fromJson(res?['result'][i]) });
        }
        if(controllerCustomer.isCustomer()) checkCoupons();
        isClearance = controllerCustomer.cart.products.indexWhere((e) => e.status == 3) > -1? true: false;
        if(mounted){
          setState(() {
            dataModel;
            isClearance;
            isReady = true;
          });
        }
      } catch (e) {
        if(kDebugMode) print('$e');
        if(mounted){
          setState(() {
            dataModel = [];
            isClearance;
            isReady = true;
          });
        }
      }
    }
  }

  Future<void> checkCoupons() async {
    final List<Map<String, dynamic>> shippings = dataModel.where((d) {
      final temp = d['shipping'] as PartnerShippingFrontendModel;
      return temp.type != 2 && temp.price > 0 && !temp.hasShortages();
    }).toList();
    if(shippings.isNotEmpty) {
      try {
        final res = await ApiService.processList('checkout-shipping-method-coupons', input: { "dataFilter": {'shippingFrontend': shippings.map((e) => (e['shipping'] as PartnerShippingFrontendModel).toJson()).toList() }});
        final length = res?['result'].length ?? 0;
        for (var i = 0; i < length; i++) {
          final k = (res?['result'][i] as Map).keys.first;
          final index = dataModel.indexWhere((d) => (d['shipping'] as PartnerShippingFrontendModel).id == k);
          if(index > -1) {
            dataModel[index]["coupon"] = PartnerShippingCouponModel.fromJson((res?['result'][i] as Map).values.first);
          }
        }
      } catch (e) {
        if(kDebugMode) printError(info: '$e');
      }
    }
    if(mounted){
      setState(() {
        dataModel;
        isReady = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        title: Text(
          lController.getLang("Choose Shipping Method")
        ),
      ),
      body: !isReady
      ? Loading()
      : dataModel.isEmpty
        ? NoDataCoffeeMug()
        : ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            ListView.builder(
              itemCount: dataModel.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (c, index) {
                PartnerShippingFrontendModel d = dataModel[index]['shipping'] as PartnerShippingFrontendModel;
                PartnerShippingCouponModel? coupon = dataModel[index]['coupon'] as PartnerShippingCouponModel?;

                return ShippingItem(
                  model: d,
                  onSelect: (val, coupon) => _onSelect(val, coupon),
                  lController: lController,
                  shippingCoupon: coupon,
                );
              },
            ),
            if(isClearance)...[
              Padding(
                padding: const EdgeInsets.fromLTRB(kGap, kGap*1.5, kGap, kGap),
                child: Text(
                  lController.getLang('text_clearance_2'),
                  textAlign: TextAlign.center,
                  style: subtitle1.copyWith(
                    color: kDarkColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ]
          ],
        )
    );
  }

  _onSelect(PartnerShippingFrontendModel value, PartnerShippingCouponModel? coupon) async {
    if(!onClick){
      onClick = true;
      ShowDialog.showLoadingDialog();
      // Click and Collect
      controllerCustomer.setDiscountShipping(null, needUpdate: true);
      if(value.type == 2) {
        Get.back();
        onClick = false;
        await Future.delayed(const Duration(milliseconds: 250));
        Get.to(() => ClickAndCollectShops(subscription: subscription));
        return;
      }
      if(subscription == null){
        controllerCustomer.setShippingMethod(value);
        await AppHelpers.updatePartnerShop(controllerCustomer);
        if(coupon != null) controllerCustomer.setDiscountShipping(coupon);
        Get.back();
        Get.back();
        return;
      }else {
        if(subscription == 1){
          await Get.find<SubscriptionCheckoutController>().updateShippingMethod(value);
          Get.back();
          Get.back();
          return;
        }else if(subscription == 2){
          await Get.find<SubscriptionCheckoutUpdateController>().updateShippingMethod(value);
          Get.back();
          Get.back();
          return;
        }
        
      }

    }
  }
  
}