// import 'package:coffee2u/apis/api_service.dart';
// import 'package:coffee2u/config/index.dart';
// import 'package:coffee2u/controller/customer_controller.dart';
// import 'package:coffee2u/controller/language_controller.dart';
// import 'package:coffee2u/models/index.dart';
// import 'package:coffee2u/screens/customer/payment/components/payment_webview.dart';
// import 'package:coffee2u/screens/customer/thank_you/read.dart';
// import 'package:coffee2u/utils/index.dart';
// import 'package:coffee2u/widgets/index.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:pgw_sdk/builder/digital_payment_builder.dart';
// import 'package:pgw_sdk/models/payment_code.dart';
// import 'package:pgw_sdk/models/payment_request.dart';
// import 'package:pgw_sdk/models/transaction_result_request_builder.dart';
// import 'package:pgw_sdk/models/transaction_result_response.dart';
// import 'package:pgw_sdk/pgw_sdk.dart';

// class PaymentTrueMoneyWalletScreen extends StatefulWidget {
//   const PaymentTrueMoneyWalletScreen({
//     super.key,
//     required this.model,
//   });

//   final Payment2C2PModel model;

//   @override
//   State<PaymentTrueMoneyWalletScreen> createState() => _PaymentTrueMoneyWalletScreenState();
// }

// class _PaymentTrueMoneyWalletScreenState extends State<PaymentTrueMoneyWalletScreen> {
//   final LanguageController lController = Get.find<LanguageController>();
//   final CustomerController controllerCustomer = Get.find<CustomerController>();
//   Widget? _cardIcon;

//   // Form Key
//   final _formKey = GlobalKey<FormState>();

//   // Text Controller
//   final TextEditingController _cName = TextEditingController();
//   final TextEditingController _cPhone = TextEditingController();

//   // Focus Node
//   final FocusNode _fName = FocusNode();
//   final FocusNode _fPhone = FocusNode();

//   bool _isValid() {
//     return controllerCustomer.paymentMethod != null 
//       && controllerCustomer.paymentMethod!.isValid() 
//       && _cName.text != '' && _cPhone.text != '';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kWhiteColor,
//       appBar: AppBar(
//         title: Text(controllerCustomer.paymentMethod?.name ?? ''),
//       ),
//       body: !widget.model.isValid() 
//         ? Center(child: NoDataCoffeeMug())
//         : GestureDetector(
//           onTap: () => FocusScope.of(context).unfocus(),
//           child: Form(
//             key: _formKey,
//             child: ListView(
//               padding: kPadding,
//               children: [
//                 TextFormField(
//                   controller: _cName,
//                   focusNode: _fName,
//                   keyboardType: TextInputType.name,
//                   decoration: InputDecoration(
//                     border: const OutlineInputBorder(),
//                     hintText: lController.getLang('Wallet Holder Name'),
//                     prefixIcon: const Icon(
//                       Icons.person_outline,
//                       size: 26,
//                       color: Color(0xFFB8B5C3),
//                     ),
//                   ),
//                   validator: (value) => Utils.validateString(value),
//                   onFieldSubmitted: (str) => _fPhone.requestFocus(),
//                 ),

//                 const SizedBox(height: kGap),
//                 TextFormField(
//                   controller: _cPhone,
//                   focusNode: _fPhone,
//                   keyboardType: TextInputType.number,
//                   textInputAction: TextInputAction.done,
//                   decoration: InputDecoration(
//                     border: const OutlineInputBorder(),
//                     hintText: lController.getLang('Telephone Number'),
//                     prefixIcon: const Icon(
//                       Icons.phone_outlined,
//                       size: 26,
//                       color: Color(0xFFB8B5C3),
//                     ),
//                   ),
//                   validator: (value) => Utils.validateString(value),
//                   onFieldSubmitted: (str) => FocusScope.of(context).unfocus(),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       bottomNavigationBar: Padding(
//         padding: kPaddingSafeButton,
//         child: IgnorePointer(
//           ignoring: !_isValid(),
//           child: ButtonFull(
//             color: !_isValid()? kGrayColor: kAppColor,
//             title: lController.getLang("Pay Now"),
//             onPressed: () => _onTapComfirm(),
//           )
//         ),
//       ),
//     );
//   }

//   void _onTapComfirm() async {
//     if(_isValid()){
//       ShowDialog.showLoadingDialog();
//       try {
//         PaymentCode paymentCode = PaymentCode(channelCode: 'TRUEMONEY');
//         PaymentRequest paymentRequest = DigitalPaymentBuilder(paymentCode: paymentCode)
//           .setName(_cName.text)
//           .setMobileNo(_cPhone.text)
//           .build();
//         var request = TransactionResultRequestBuilder(
//           paymentToken: widget.model.paymentToken,
//           paymentRequest: paymentRequest,
//         );
//         TransactionResultResponse response = await PGWSDK.proceedTransaction(request);
        
//         Get.back();
//         if(response.responseCode == '1001' && response.data != null){
//           await Navigator.of(context).push(
//             MaterialPageRoute(builder: (context) =>
//               PaymentWebviewScreen(
//                 model: widget.model,
//                 url: response.data ?? '',
//               ),
//           )).then((value) async {
//             dynamic res = await ApiService.customerPayment2C2PCompleted(payload: widget.model.payload);
//             if(res['orderId'] != null){
//               Get.offAll(() => ThankYouScreen(orderTemp: res));
//             }
//           });
//         }else{
//           ShowDialog.showForceDialog("${lController.getLang("Payment Failed")} 1", response.responseDescription!, () => Get.back());
//         }
//       } on PlatformException catch (e) {
//         Get.back();
//         ShowDialog.showForceDialog("${lController.getLang("Payment Failed")} 2", e.message ?? '', () => Get.back());
//       } catch (e) {
//         Get.back();
//         ShowDialog.showForceDialog("${lController.getLang("Payment Failed")} 3", e.toString(), () => Get.back());
//       }
//     }
//   }
// }