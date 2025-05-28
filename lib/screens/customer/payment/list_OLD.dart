// import 'package:coffee2u/apis/api_service.dart';
// import 'package:coffee2u/config/index.dart';
// import 'package:coffee2u/controller/customer_controller.dart';
// import 'package:coffee2u/controller/language_controller.dart';
// import 'package:coffee2u/models/index.dart';
// import 'package:coffee2u/screens/customer/payment/components/payment_credit_card.dart';
// import 'package:coffee2u/screens/customer/payment/components/payment_item.dart';
// import 'package:coffee2u/screens/customer/payment/components/payment_qr_code.dart';
// import 'package:coffee2u/screens/customer/payment/components/payment_true_money_wallet.dart';
// import 'package:coffee2u/screens/customer/thank_you/read.dart';
// import 'package:coffee2u/utils/index.dart';
// import 'package:coffee2u/widgets/index.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';

// import 'package:pgw_sdk/builder/qr_payment_builder.dart';
// import 'package:pgw_sdk/models/payment_code.dart';
// import 'package:pgw_sdk/models/payment_request.dart';
// import 'package:pgw_sdk/models/transaction_result_request_builder.dart';
// import 'package:pgw_sdk/models/transaction_result_response.dart';
// import 'package:pgw_sdk/pgw_sdk.dart';


// class PaymentMethodsScreen extends StatefulWidget {
//   const PaymentMethodsScreen({
//     super.key,
//   });

//   @override
//   State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
// }

// class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
//   final LanguageController lController = Get.find<LanguageController>();
//   final CustomerController _customerController = Get.find<CustomerController>();
//   late Future<Map<String, dynamic>?> _future;
//   PaymentMethodModel? _selected;

//   @override
//   void initState() {
//     _customerController.setPaymentMethod(null);
//     _future = ApiService.processList(
//       'checkout-payment-methods',
//       input: {
//         "shippingId": _customerController.shippingMethod!.id,
//         "total": _customerController.cart.total
//       }
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kWhiteColor,
//       appBar: AppBar(
//         title: Text(
//           lController.getLang("Choose Payment Method")
//         ),
//       ),
//       body: FutureBuilder<Map<String, dynamic>?>(
//         future: _future,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             List<PaymentMethodModel> _data = [];

//             if(snapshot.data!['result'] != null){
//               var len = snapshot.data!['result'].length;
//               for (var i = 0; i < len; i++) {
//                 PaymentMethodModel model = PaymentMethodModel.fromJson(snapshot.data!['result'][i]);
//                 _data.add(model);
//               }
//             }

//             if(_data.isEmpty){
//               return NoDataCoffeeMug();
//             }else{
//               return ListView.builder(
//                 itemCount: _data.length,
//                 itemBuilder: (c, index) {
//                   PaymentMethodModel d = _data[index];
//                   return PaymentItem(
//                     model: d,
//                     selected: _selected,
//                     onSelect: (PaymentMethodModel? model) {
//                       setState(() {
//                         _selected = model;
//                       });
//                       _customerController.setPaymentMethod(model);
//                     },
//                     lController: lController
//                   );
//                 },
//               );
//             }
//           } else if (snapshot.hasError || snapshot.connectionState == ConnectionState.none) {
//             return NoDataCoffeeMug();
//           }

//           return Loading();
//         },
//       ),
//       bottomNavigationBar: GetBuilder<CustomerController>(builder: (controller) {
//         return Padding(
//           padding: kPaddingSafeButton,
//           child: IgnorePointer(
//             ignoring: controller.paymentMethod == null || !controller.paymentMethod!.isValid(),
//             child: ButtonFull(
//               color: controller.paymentMethod == null || !controller.paymentMethod!.isValid()
//                 ? kGrayColor: kAppColor,
//               title: lController.getLang("Pay Now"),
//               onPressed: () => _onTapComfirm(controller),
//             )
//           ),
//         );
//       })
//     );
//   }

//   void _onTapComfirm(CustomerController _controller) async {
//     if(
//       _controller.shippingMethod != null && _controller.shippingMethod!.isValid() 
//       && _controller.paymentMethod != null && _controller.paymentMethod!.isValid()
//     ){
//       if(_controller.paymentMethod?.type == 4){
//         dynamic res = await ApiService.customerCheckout(
//           shippingFrontend: _controller.shippingMethod?.toJson(),
//           billingAddressId: _controller.billingAddress?.id ?? '',
//           paymentMethodId: _controller.paymentMethod?.id ?? '',
//           shippingCouponFrontend: _controller.discountShipping == null 
//             ? '': _controller.discountShipping?.toJson(),
//           couponFrontend: _controller.discountProduct == null
//             ? '': _controller.discountProduct?.toJson(),
//           cashCouponFrontend: _controller.discountCash == null 
//             ? '': _controller.discountCash?.toJson(),
//           pointBurn: _controller.discountPoint?.points ?? 0,
//         );
//         if(res['orderId'] != null){
//           Get.offAll(() => ThankYouScreen(orderTemp: res));
//         }
//       }else{
//         Payment2C2PModel res = await ApiService.customerPayment2C2P(
//           // amount: _controller.checkoutTotal(),
//           amount: 1,
//           shippingAddressId: _controller.shippingAddress?.id ?? '',
//           shippingFrontend: _controller.shippingMethod?.toJson(),
//           paymentMethodId: _controller.paymentMethod?.id ?? '',
//           billingAddressId: _controller.billingAddress?.id ?? '',
//           shippingCouponFrontend: _controller.discountShipping == null 
//             ? '': _controller.discountShipping?.toJson(),
//           couponFrontend: _controller.discountProduct == null
//             ? '': _controller.discountProduct?.toJson(),
//           cashCouponFrontend: _controller.discountCash == null 
//             ? '': _controller.discountCash?.toJson(),
//           pointBurn: _controller.discountPoint?.points ?? 0,
//         );
//         if(res.isValid()){
//           if(_controller.paymentMethod?.type == 2){
//             await _paymentQRCode(res);
//           }else if(_controller.paymentMethod?.type == 3){
//             Get.to(() => PaymentTrueMoneyWalletScreen(model: res));
//           }else{
//             Get.to(() => PaymentCreditCardScreen(model: res));
//           }
//         }else{
//           Get.back();
//         }
//       }
//     }
//   }

//   Future<void> _paymentQRCode(Payment2C2PModel _model) async {
//     ShowDialog.showLoadingDialog();
//     try {
//       PaymentCode paymentCode = PaymentCode(channelCode: 'PPQR');
//       PaymentRequest paymentRequest = QRPaymentBuilder(paymentCode: paymentCode)
//         .setType(QRTypeCode.url)
//         // .setName('Sarun Seepun')
//         // .setEmail(_customerController.customerModel?.email ?? '')
//         // .setMobileNo(_customerController.customerModel?.telephone ?? '')
//         .build();
//       TransactionResultRequestBuilder request = TransactionResultRequestBuilder(
//         paymentToken: _model.paymentToken,
//         paymentRequest: paymentRequest,
//       );
//       TransactionResultResponse response = await PGWSDK.proceedTransaction(request);
//       Get.back();
//       if(response.responseCode == '1005' && response.data != null){
//         Get.to(() => PaymentQRCodeScreen(
//           model: _model,
//           response: response,
//         ));
//       }else{
//         ShowDialog.showForceDialog("${lController.getLang("Payment Failed")} 1", response.responseDescription!, () => Get.back());
//       }
//     } on PlatformException catch (e) {
//       Get.back();
//       ShowDialog.showForceDialog("${lController.getLang("Payment Failed")} 2", e.message ?? '', () => Get.back());
//     } catch (e) {
//       Get.back();
//       ShowDialog.showForceDialog("${lController.getLang("Payment Failed")} 3", e.toString(), () => Get.back());
//     }
//   }
// }