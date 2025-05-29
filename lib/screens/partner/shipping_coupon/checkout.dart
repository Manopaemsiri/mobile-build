import 'dart:convert';

import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/partner/product_coupon/checkout.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutPartnerShippingCouponsScreen extends StatefulWidget {
  const CheckoutPartnerShippingCouponsScreen({
    super.key,
  });

  @override
  State<CheckoutPartnerShippingCouponsScreen> createState() => _CheckoutPartnerShippingCouponsScreenState();
}

class _CheckoutPartnerShippingCouponsScreenState extends State<CheckoutPartnerShippingCouponsScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  bool isLoading = true;
  final CustomerController controllerCustomer = Get.find<CustomerController>();
  List<PartnerShippingCouponModel> dataModel = [];
  
  Map<String, dynamic> _settings = {};
  bool allowCode = false;
  TextEditingController cCode = TextEditingController();
  FocusNode fCode = FocusNode();
  String errorStr = "";
  PartnerShippingCouponModel? couponCode;

  Future<void> _initState() async {
    if(mounted) setState(() => isLoading = true);

    var resSettings = await ApiService.processRead('settings');
    _settings = resSettings?['result'];
    allowCode = _settings["APP_ENABLE_FEATURE_PARTNER_SHIPPING_COUPON"] == '1' && _settings["APP_ENABLE_FEATURE_PARTNER_SHIPPING_COUPON_CODE"] == '1';

    String prefKey = "${controllerCustomer.customerModel?.id}";
    prefKey += prefCustomerShippingCoupon;
    List<String> couponIds = await AppHelpers.getAllCoupons(prefKey);

    var res = await ApiService.processList(
      'checkout-partner-shipping-coupons',
      input: {
        "shippingFrontend": controllerCustomer.shippingMethod!.toJson(),
        "dataFilter": couponIds.isNotEmpty? {'localCodeIds': couponIds}: {}
      },
    );
    List<PartnerShippingCouponModel> temp = [];
    if(res != null && res["result"] != null){
      int len = res["result"].length;
      for(int i=0; i<len; i++){
        temp.add(PartnerShippingCouponModel.fromJson(res["result"][i]));
      }
    }
    if(mounted){
      setState(() {
        dataModel = temp;
        allowCode;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _initState();
    super.initState();
  }

  @override
  dispose() {
    cCode.dispose();
    fCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            lController.getLang('Shipping Coupon')
          ),
          bottom: const AppBarDivider(),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                if(allowCode)...[
                  Container(
                    padding: const EdgeInsets.fromLTRB(kGap, kGap, kGap, kGap),
                    width: Get.width,
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: cCode,
                              focusNode: fCode,
                              autofocus: false,
                              maxLines: 1,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: kHalfGap, horizontal: kHalfGap),
                                hintText: lController.getLang('Apply your coupon code'),
                                hintStyle: title.copyWith(
                                  color: kGrayColor
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: kLightColor),
                                  borderRadius: BorderRadius.circular(kRadius)
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: kLightColor),
                                  borderRadius: BorderRadius.circular(kRadius) 
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: kLightColor),
                                  borderRadius: BorderRadius.circular(kRadius)
                                ),
                                suffixIcon: cCode.text.isNotEmpty
                                  ? IconButton(
                                    onPressed: () {
                                      if(mounted){
                                        setState(() {
                                          cCode.clear();
                                          errorStr = "";
                                          couponCode = null;
                                        });
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.cancel_rounded,
                                      color: kLightColor,
                                    )
                                  )
                                  : null,
                              ),
                              inputFormatters: [
                                UpperCaseTextFormatter()
                              ],
                              validator: (str) {
                                return null;
                              },
                              onChanged: (value) {
                                if(mounted){
                                  setState(() {
                                    // cCode.text = value;
                                    // cCode.selection = TextSelection.fromPosition(TextPosition(offset: cCode.text.length));
                                    var cursorPosition = cCode.selection.base.offset;
                                    cCode.text = value;
                                    cCode.selection = TextSelection.fromPosition(TextPosition(offset: cursorPosition));

                                  });
                                }
                              },
                              onFieldSubmitted: (str) => onConfirm(),
                            ),
                          ),
                          const Gap(gap: kHalfGap),
                          GestureDetector(
                            onTap: onConfirm,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.fromLTRB(kGap, kHalfGap, kGap, kHalfGap),
                              decoration: BoxDecoration(
                                color: cCode.text.isNotEmpty && errorStr.isEmpty? kAppColor: kLightColor,
                                borderRadius: BorderRadius.circular(kRadius)
                              ),
                              child: Center(
                                child: Text(
                                  lController.getLang('Apply Code'),
                                  style: title.copyWith(
                                    color: kWhiteColor
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
                if(!isLoading)...[
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _initState,
                      color: kAppColor,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(kGap, allowCode? 0: kGap, kGap, kGap),
                        child: Column(
                          children: [
                            dataModel.isEmpty
                            ? Padding(
                              padding: const EdgeInsets.only(top: 3*kGap),
                              child: NoDataCoffeeMug(),
                            )
                            : ListView.builder(
                              shrinkWrap: true,
                              itemCount: dataModel.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                PartnerShippingCouponModel item = dataModel[index];
                                return CardShippingCoupon3(
                                  model: item,
                                  onPressed: () => _updateCoupon(item),
                                );
                              },
                            ),
                          ],
                        )
                      ),
                    ),
                  ),
                ]
              ],
            ),
            if(isLoading) ...[ Loading() ]
          ],
        ),
      ),
    );
  }

  void _updateCoupon(PartnerShippingCouponModel value, {bool isSaveCoupon = false}) {
    if(isSaveCoupon) _saveCouponToLocal(value.id!);
    controllerCustomer.setDiscountShipping(value, needUpdate: true);
    Get.back();
  }

  void _saveCouponToLocal(String id) {
    String prefKey = "${controllerCustomer.customerModel?.id}";
    prefKey += prefCustomerShippingCoupon;
    AppHelpers.saveCoupon(prefKey, id);
  }

  onConfirm() async {
    ShowDialog.showLoadingDialog();
    try {
      Map<String, dynamic> input = {
        "couponCode": cCode.text.trim(),
        "shippingFrontend": Uri.encodeQueryComponent(jsonEncode(controllerCustomer.shippingMethod!.toJson())),
      };
      
      Map<String, dynamic>? res = await ApiService.processRead('checkout-partner-shipping-coupon', input: input);
      if(Get.isDialogOpen == true) Get.back();
      PartnerShippingCouponModel? model = res?['result'].isNotEmpty == true? PartnerShippingCouponModel.fromJson(res?['result']): null;
      if(model?.availability == 99){
        return _updateCoupon(model!, isSaveCoupon: true);
      }else {
        if(model?.id != null) _saveCouponToLocal(model!.id!);
        final snackBar = SnackBar(
          content: Text(
            model?.displayAvailability(lController) ?? lController.getLang('Invalid coupon code'),
            style: subtitle1.copyWith(
              fontWeight: FontWeight.w500,
              fontFamily: 'Kanit',
            ),
          ),
          behavior: SnackBarBehavior.floating,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
    }catch (e) {
      if(Get.isDialogOpen == true) Get.back();
      await Future.delayed(const Duration(milliseconds: 450));
      final snackBar = SnackBar(
        content: Text(
          lController.getLang('Invalid coupon code'),
          style: subtitle1.copyWith(
            fontWeight: FontWeight.w500,
            fontFamily: 'Kanit',
          ),
        ),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      if(kDebugMode) print('$e');
      return;
    }
  }
}