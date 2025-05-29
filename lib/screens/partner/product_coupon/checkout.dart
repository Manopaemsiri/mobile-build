import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/constants/app_constants.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CheckoutPartnerProductCouponsScreen extends StatefulWidget {
  const CheckoutPartnerProductCouponsScreen({
    super.key,
    this.isCashCoupon = 0,
  });

  final int isCashCoupon;

  @override
  State<CheckoutPartnerProductCouponsScreen> createState() => _CheckoutPartnerProductCouponsScreenState();
}

class _CheckoutPartnerProductCouponsScreenState extends State<CheckoutPartnerProductCouponsScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  bool isLoading = true;
  final CustomerController controllerCustomer = Get.find<CustomerController>();
  List<PartnerProductCouponModel> dataModel = [];

  Map<String, dynamic> _settings = {};
  bool allowCode = false;
  TextEditingController cCode = TextEditingController();
  FocusNode fCode = FocusNode();

  Future<void> _initState() async {
    if(mounted) setState(() => isLoading = true);
    var resSettings = await ApiService.processRead('settings');
    _settings = resSettings?['result'];

    String prefKey = "${controllerCustomer.customerModel?.id}";
    dynamic res;
    if(widget.isCashCoupon == 1) {
      prefKey += prefCustomerCashCoupon;
      List<String> couponIds = await AppHelpers.getAllCoupons(prefKey);
      final Map<String, dynamic> dataInput = couponIds.isNotEmpty? {'dataFilter': {'localCodeIds': couponIds}}: {};

      res = await ApiService.processList('checkout-partner-cash-coupons', input: dataInput);
      allowCode = _settings["APP_ENABLE_FEATURE_PARTNER_CASH_COUPON"] == '1' && _settings["APP_ENABLE_FEATURE_PARTNER_CASH_COUPON_CODE"] == '1';
    }else {
      prefKey += prefCustomerDiscountProduct;
      List<String> couponIds = await AppHelpers.getAllCoupons(prefKey);
      final Map<String, dynamic> dataInput = couponIds.isNotEmpty? {'dataFilter': {'localCodeIds': couponIds}}: {};

      res = await ApiService.processList('checkout-partner-product-coupons', input: dataInput);
      allowCode = _settings["APP_ENABLE_FEATURE_PARTNER_PRODUCT_COUPON"] == '1' && _settings["APP_ENABLE_FEATURE_PARTNER_PRODUCT_COUPON_CODE"] == '1';
    }
    List<PartnerProductCouponModel> temp = [];
    if(res != null && res["result"] != null){
      int len = res["result"].length;
      for(int i=0; i<len; i++){
        temp.add(PartnerProductCouponModel.fromJson(res["result"][i]));
      }
    }
    if(mounted) {
      setState(() {
        dataModel = temp;
        _settings = resSettings?['result'] ?? {};
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
            lController.getLang(
              widget.isCashCoupon == 1? 'Cash Coupon': 'Product Coupon'
            )
          ),
          bottom: const AppBarDivider()
        ),
        body: Stack(
          children: [
            IgnorePointer(
              ignoring: isLoading,
              child: Column(
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
                                    color: kGrayColor,
                                    fontFamily: 'Kanit',
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
                                        if(mounted) setState(() => cCode.clear());
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
                                onChanged: (value) {
                                  if(mounted){
                                    setState(() {
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
                              onTap: cCode.text.isNotEmpty? onConfirm: null,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.fromLTRB(kGap, kHalfGap, kGap, kHalfGap),
                                decoration: BoxDecoration(
                                  color: cCode.text.isNotEmpty? kAppColor: kLightColor,
                                  borderRadius: BorderRadius.circular(kRadius)
                                ),
                                child: Center(
                                  child: Text(
                                    lController.getLang('Apply Code'),
                                    style: title.copyWith(
                                      color: kWhiteColor,
                                      fontFamily: 'Kanit'
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
                                  PartnerProductCouponModel item = dataModel[index];
                                  return CardProductCoupon3(
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
            ),
            if(isLoading) ...[ Loading() ]
          ],
        ),
      ),
    );
  }

  void _updateCoupon(PartnerProductCouponModel value, {bool isSaveCoupon = false}) async {
    if(isSaveCoupon) _saveCouponToLocal(value.id!);
    if(widget.isCashCoupon == 1){
      controllerCustomer.setDiscountCash(value, needUpdate: true);
    }else {
      controllerCustomer.setDiscountProduct(value, needUpdate: true);
    }
    Get.back();
  }

  void _saveCouponToLocal(String id) {
    String prefKey = "${controllerCustomer.customerModel?.id}";
    if(widget.isCashCoupon == 1){
      prefKey += prefCustomerCashCoupon;
      AppHelpers.saveCoupon(prefKey, id);
    }else {
      prefKey += prefCustomerDiscountProduct;
      AppHelpers.saveCoupon(prefKey, id);
    }
  }

  Future<void> onConfirm() async {
    ShowDialog.showLoadingDialog();
    try {
      Map<String, dynamic> input = { "couponCode": cCode.text.trim() };
      Map<String, dynamic>? res;
      if(widget.isCashCoupon == 1){
        res = await ApiService.processRead('checkout-partner-cash-coupon', input: input);
      }else{
        res = await ApiService.processRead('checkout-partner-product-coupon', input: input);
      }
      if(Get.isDialogOpen == true) Get.back();
      PartnerProductCouponModel? model = res?['result'].isNotEmpty == true? PartnerProductCouponModel.fromJson(res?['result']): null;
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
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
} 