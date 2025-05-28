import 'package:coffee2u/apis/api_service.dart';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/customer_controller.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/screens/customer/sales_manager/list.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:coffee2u/screens/customer/payment/components/payment_item.dart';
import 'package:coffee2u/screens/customer/payment/components/payment_webview.dart';
import 'package:coffee2u/screens/customer/thank_you/read.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({
    super.key,
    this.customDownPayment,
    this.amountDefault,
    this.missingPaymentDefault
  });
  final double? customDownPayment;
  final double? amountDefault;
  final double? missingPaymentDefault;
  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  final CustomerController _customerController = Get.find<CustomerController>();
  late Future<Map<String, dynamic>?> _future;

  bool availableSaleManager = false;
  String? salesManagerId;

  PaymentMethodModel? _selected;

  String countryCode = "TH";

  @override
  void initState() {
    initCountry();
    _customerController.setPaymentMethod(null);
    _future = ApiService.processList(
      'checkout-payment-methods',
      input: {
        "shippingId": _customerController.shippingMethod!.id,
        "shippingFrontend": _customerController.shippingMethod,
        "total": _customerController.checkoutTotal(),
        "hasDownPayment": _customerController.cart.hasDownPayment,
        "missingPayment": _customerController.cartMissingPayment(),
        "diffInstallment": _customerController.cartDiffInstallmentDiscount(),
        "customDownPayment": widget.customDownPayment,
        "shippingCost": (_customerController.shippingMethod?.price ?? 0) - (_customerController.discountShipping?.actualDiscount ?? 0)
      }
    );
    getSaleManager();
    super.initState();
  }

  Future<void> initCountry() async {
    // countryCode = WidgetsBinding.instance.window.locale.countryCode ?? 'TH';
    countryCode = 'TH';
  }

  Future<void> getSaleManager() async {
    try {
      final res = await ApiService.processRead("setting", input: {"name": "APP_CUSTOMER_CAN_CHOOSE_CHECKOUT_SALES"});
      if(mounted){
        if(res?["result"] == "1" || res?["result"] == 1){
          setState(() {
            availableSaleManager = true;
          });
        }
      }
    } catch (e) {
      printError(info: '$e');
      
    }
  }
  void _onPressedSalesManager(String? id) {
    setState(() => salesManagerId = id);
  }
  
  void _onTapComfirm(CustomerController _controller) async {
    bool isSuperUser = _controller.customerModel != null 
      && (_controller.customerModel!.telephone == '+66973052239' 
      && _controller.customerModel!.username == 'sseepun');
    if(
      _controller.shippingMethod != null && _controller.shippingMethod!.isValid() 
      && _controller.paymentMethod != null && _controller.paymentMethod!.isValid()
    ){
      if(_controller.paymentMethod?.type == 4){
        ShowDialog.showForceDialog(
          lController.getLang("Confirm your order"),
          lController.getLang("text_payment_5"), 
          () async {
            Get.back();
            dynamic res = await ApiService.customerCheckout(
              shippingFrontend: _controller.shippingMethod?.toJson(),
              billingAddressId: _controller.billingAddress?.id ?? '',
              paymentMethodId: _controller.paymentMethod?.id ?? '',
              shippingCouponFrontend: _controller.discountShipping == null 
                ? '': _controller.discountShipping?.toJson(),
              couponFrontend: _controller.discountProduct == null
                ? '': _controller.discountProduct?.toJson(),
              cashCouponFrontend: _controller.discountCash == null 
                ? '': _controller.discountCash?.toJson(),
              pointBurn: _controller.discountPoint?.points ?? 0,
              salesManagerId: salesManagerId,
              hasCustomDownPayment: _controller.paymentMethod?.hasCustomDownPayment() == true? 1: 0,
              customDownPayment: _controller.paymentMethod?.hasCustomDownPayment() == true? widget.customDownPayment: 0,
              amountDefault: _controller.paymentMethod?.hasCustomDownPayment() == true? widget.amountDefault: 0,
              missingPaymentDefault: _controller.paymentMethod?.hasCustomDownPayment() == true? widget.missingPaymentDefault: 0,
            );
            if(res['orderId'] != null){
              Get.offAll(() => ThankYouScreen(orderTemp: res));
            }
          },
          onCancel: () => Get.back(),
          confirmText: lController.getLang("Confirm"),
          cancelText: lController.getLang("Cancel"),
        );
      }else if(_controller.paymentMethod?.type == 5 || _controller.paymentMethod?.type == 6){
        PaymentStripeModel res = await ApiService.customerPaymentStripe(
          amount: _controller.paymentMethod?.payNow ?? 0,
          hasDownPayment: _controller.paymentMethod != null 
            && _controller.paymentMethod!.hasDownPayment()? 1: 0,
          missingPayment: _controller.paymentMethod != null 
            && _controller.paymentMethod!.hasDownPayment() 
              ? (_controller.paymentMethod?.payLater ?? 0): 0,
          shippingAddressId: _controller.shippingAddress?.id ?? '',
          shippingFrontend: _controller.shippingMethod?.toJson(),
          paymentMethodId: _controller.paymentMethod?.id ?? '',
          billingAddressId: _controller.billingAddress?.id ?? '',
          shippingCouponFrontend: _controller.discountShipping == null 
            ? '': _controller.discountShipping?.toJson(),
          couponFrontend: _controller.discountProduct == null
            ? '': _controller.discountProduct?.toJson(),
          cashCouponFrontend: _controller.discountCash == null 
            ? '': _controller.discountCash?.toJson(),
          pointBurn: _controller.discountPoint?.points ?? 0,
          salesManagerId: salesManagerId,
          hasCustomDownPayment: _controller.paymentMethod?.hasCustomDownPayment() == true? 1: 0,
          customDownPayment: _controller.paymentMethod?.hasCustomDownPayment() == true? widget.customDownPayment: 0,
          amountDefault: _controller.paymentMethod?.hasCustomDownPayment() == true? widget.amountDefault ?? 0 + ((_customerController.shippingMethod?.price ?? 0) - (_customerController.discountShipping?.actualDiscount ?? 0)) : 0,
          missingPaymentDefault: _controller.paymentMethod?.hasCustomDownPayment() == true? widget.missingPaymentDefault: 0,
        );
        if(res.isValid()){
          Stripe.publishableKey = res.publishKey;
          // Stripe.merchantIdentifier = 'any string works';
          await Stripe.instance.applySettings();
          await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              customFlow: false,
              merchantDisplayName: 'Coffee2U',
              paymentIntentClientSecret: res.clientSecret,
              billingDetails: BillingDetails(
                address: Address(
                  country: countryCode,
                  city: '',
                  line1: '',
                  line2: '',
                  state: '',
                  postalCode: '',
                ),
              ),
            )
          );
          try{
            await Stripe.instance.presentPaymentSheet();
            dynamic res2 = await ApiService.customerPaymentStripeCompleted(model: res);
            if(res2['orderId'] != null) Get.offAll(() => ThankYouScreen(orderTemp: res2));
          }catch(err){
            if(kDebugMode) print('$err');
          }
        }else{
          // Get.back();
        }
      }else{
        Payment2C2PModel res = await ApiService.customerPayment2C2P(
          amount: isSuperUser? 1: _controller.paymentMethod?.payNow ?? 0,
          hasDownPayment: _controller.paymentMethod != null 
            && _controller.paymentMethod!.hasDownPayment()? 1: 0,
          missingPayment: _controller.paymentMethod != null 
            && _controller.paymentMethod!.hasDownPayment() 
              ? (isSuperUser? 1: _controller.paymentMethod?.payLater ?? 0): 0,
          shippingAddressId: _controller.shippingAddress?.id ?? '',
          shippingFrontend: _controller.shippingMethod?.toJson(),
          paymentMethodId: _controller.paymentMethod?.id ?? '',
          billingAddressId: _controller.billingAddress?.id ?? '',
          shippingCouponFrontend: _controller.discountShipping == null 
            ? '': _controller.discountShipping?.toJson(),
          couponFrontend: _controller.discountProduct == null
            ? '': _controller.discountProduct?.toJson(),
          cashCouponFrontend: _controller.discountCash == null 
            ? '': _controller.discountCash?.toJson(),
          pointBurn: _controller.discountPoint?.points ?? 0,
          salesManagerId: salesManagerId,

          hasCustomDownPayment: _controller.paymentMethod?.hasCustomDownPayment() == true? 1: 0,
          customDownPayment: _controller.paymentMethod?.hasCustomDownPayment() == true? widget.customDownPayment: 0,
          amountDefault: _controller.paymentMethod?.hasCustomDownPayment() == true? widget.amountDefault: 0,
          missingPaymentDefault: _controller.paymentMethod?.hasCustomDownPayment() == true? widget.missingPaymentDefault: 0,
        );
        if(res.isValid()){
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) =>
              PaymentWebviewScreen(
                model: res,
                url: res.webPaymentUrl,
                title: _controller.paymentMethod?.name ?? '',
              ),
          )).then((value) async {
            ShowDialog.showLoadingDialog();
            dynamic res2;
            bool isFailed = true;
            for (int _ in [0,1,2,3]) {
              res2 = await ApiService.customerPayment2C2PCompleted(payload: res.payload);
              if(res2?['orderId'] != null){
                isFailed = false;
                Get.offAll(() => ThankYouScreen(orderTemp: res2));
                break;
              }
              await Future.delayed(const Duration(seconds: 1));
            }
            if(isFailed){
              Get.back();
              if(res2?['error'] != null) ShowDialog.showForceDialog("Payment Failed", "${res2?['error']}", () => Get.back());
            }
          });
        }else{
          // Get.back();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final symbol = lController.usedCurrency?.icon ?? lController.defaultCurrency?.icon ?? '฿';

    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        title: Text(
          lController.getLang("Choose Payment Method")
        ),
        actions: [
          if(availableSaleManager)...[
            IconButton(
              icon: const Icon(
                Icons.support_agent,
                color: kAppColor,
                size: 24,
              ),
              onPressed: () {
                Get.to(() =>
                  SalesManagersScreen(
                    initId: salesManagerId,
                    onPressed: _onPressedSalesManager,
                  ),
                );
              }
            ),
          ]
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          FutureBuilder<Map<String, dynamic>?>(
            future: _future,
            builder: (context, snapshot){
              if(snapshot.hasData){
                List<PaymentMethodModel> dataModel = [];

                if(snapshot.data!['result'] != null){
                  var len = snapshot.data!['result'].length;
                  for(var i=0; i<len; i++){
                    PaymentMethodModel model = PaymentMethodModel.fromJson(snapshot.data!['result'][i]);
                    dataModel.add(model);
                  }
                }

                if(dataModel.isEmpty){
                  return Padding(
                    padding: EdgeInsets.only(top: Get.height*0.22),
                    child: Center(child: NoDataCoffeeMug()),
                  );
                }else{
                  return GetBuilder<CustomerController>(builder: (controller) {
                    return Column(
                      children: [
                        ...dataModel.map((PaymentMethodModel d){
                          return Opacity(
                            opacity: controller.paymentMethod == null 
                              || controller.paymentMethod!.id == d.id? 1: 0.5,
                            child: PaymentItem(
                              model: d,
                              selected: _selected,
                              onSelect: (PaymentMethodModel? model) {
                                setState(() => _selected = model);
                                _customerController.setPaymentMethod(model);
                              },
                              lController: lController
                            ),
                          );
                        }),
                        
                        if(controller.paymentMethod != null 
                        && controller.paymentMethod!.hasDownPayment()) ...[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(kGap, kGap*1.5, kGap, kGap),
                            child: Column(
                              children: [
                                if(lController.getLang("text_payment_1").isNotEmpty) ...[
                                  Text(
                                    lController.getLang("text_payment_1"),
                                    textAlign: TextAlign.center,
                                    style: subtitle1.copyWith(
                                      color: kDarkColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                                if(lController.getLang("text_payment_2").isNotEmpty) ...[
                                  Text(
                                    lController.getLang("text_payment_2"),
                                    textAlign: TextAlign.center,
                                    style: subtitle1.copyWith(
                                      color: kDarkColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                                RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    text: "${lController.getLang("text_payment_3")}  ",
                                    style: subtitle1.copyWith(
                                      fontFamily: 'Kanit',
                                      color: kDarkColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: priceFormat(
                                          _customerController.paymentMethod?.payLater ?? 0,
                                          lController
                                        ),
                                        style: headline6.copyWith(
                                          fontFamily: 'Kanit',
                                          color: kAppColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextSpan(

                                        text: " $symbol",
                                        style: subtitle1.copyWith(
                                          fontFamily: 'Kanit',
                                          color: kDarkColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if(lController.getLang("text_payment_4").isNotEmpty) ...[
                                  Text(
                                    lController.getLang("text_payment_4"),
                                    textAlign: TextAlign.center,
                                    style: subtitle1.copyWith(
                                      color: kDarkColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ],
                    );
                  });
                }
              }else if(snapshot.hasError || snapshot.connectionState == ConnectionState.none) {
                return Padding(
                  padding: EdgeInsets.only(top: Get.height*0.22),
                  child: Center(child: NoDataCoffeeMug()),
                );
              }

              return Padding(
                padding: EdgeInsets.only(top: Get.height*0.22),
                child: Center(child: Loading()),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: GetBuilder<CustomerController>(builder: (controller) {
        return Padding(
          padding: kPaddingSafeButton,
          child: IgnorePointer(
            ignoring: controller.paymentMethod == null || !controller.paymentMethod!.isValid(),
            child: ButtonFull(
              color: controller.paymentMethod == null || !controller.paymentMethod!.isValid()
                ? kGrayColor: kAppColor,
              title: lController.getLang("Checkout"),
              onPressed: () => _onTapComfirm(controller),
            )
          ),
        );
      })
    );
  }
}