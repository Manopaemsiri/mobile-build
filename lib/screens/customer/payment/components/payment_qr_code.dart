// import 'dart:async';
// import 'package:coffee2u/apis/api_service.dart';
// import 'package:coffee2u/config/index.dart';
// import 'package:coffee2u/controller/customer_controller.dart';
// import 'package:coffee2u/controller/language_controller.dart';
// import 'package:coffee2u/models/index.dart';
// import 'package:coffee2u/screens/customer/thank_you/read.dart';
// import 'package:coffee2u/utils/index.dart';
// import 'package:coffee2u/widgets/index.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:pgw_sdk/builder/qr_payment_builder.dart';
// import 'package:pgw_sdk/models/payment_code.dart';
// import 'package:pgw_sdk/models/payment_request.dart';
// import 'package:pgw_sdk/models/transaction_result_request_builder.dart';
// import 'package:pgw_sdk/models/transaction_result_response.dart';
// import 'package:pgw_sdk/pgw_sdk.dart';
// import 'package:http/http.dart' as http;

// class PaymentQRCodeScreen extends StatefulWidget {
//   const PaymentQRCodeScreen({
//     super.key,
//     required this.model,
//     required this.response,
//   });

//   final Payment2C2PModel model;
//   final TransactionResultResponse response;

//   @override
//   State<PaymentQRCodeScreen> createState() => _PaymentQRCodeScreenState();
// }

// class _PaymentQRCodeScreenState extends State<PaymentQRCodeScreen> {
//   final LanguageController lController = Get.find<LanguageController>();
//   final CustomerController _customerController = Get.find<CustomerController>();
//   bool isLoading = true;
//   late Payment2C2PModel _model;
//   late TransactionResultResponse _response;

//   Timer? _timer;
//   Duration _duration = const Duration(seconds: 0);

//   void _startTimer(int expiryTimer) {
//     var _s = expiryTimer / 1000;
//     setState(() {
//       _duration = Duration(seconds: _s.toInt());
//       _timer =
//           Timer.periodic(const Duration(seconds: 1), (_) => _setCountDown());
//     });
//   }

//   void _setCountDown() {
//     int _reduceSeconds = 1;
//     setState(() {
//       final _s = _duration.inSeconds - _reduceSeconds;
//       if (_s < 0) {
//         _timer!.cancel();
//       } else {
//         setState(() {
//           _duration = Duration(seconds: _s);
//         });
//       }
//     });
//   }

//   String displayDuration() {
//     String _m = _duration.inMinutes.toString().padLeft(2, '0');
//     String _s = (_duration.inSeconds % 60).toString().padLeft(2, '0');
//     return '$_m:$_s';
//   }

//   @override
//   void initState() {
//     _startTimer(widget.response.expiryTimer ?? 0);
//     setState(() {
//       _model = widget.model;
//       _response = widget.response;
//       isLoading = false;
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _timer!.cancel();
//     super.dispose();
//   }

//   Future<bool> _saveImage() async {
//     var response = await http.get(Uri.parse(_response.data ?? ''));
//     final result = await ImageGallerySaver.saveImage(
//       Uint8List.fromList(response.bodyBytes),
//       quality: 80,
//     );
//     if (result["isSuccess"] == true) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kWhiteColor,
//       appBar: AppBar(
//         title: Text(_customerController.paymentMethod?.name ?? ''),
//       ),
//       body: isLoading
//         ? Center(child: Loading())
//         : Container(
//           padding: kPadding,
//           width: double.infinity,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ImageProduct(
//                 imageUrl: _response.data ?? '',
//                 width: Get.width * 0.7,
//                 height: Get.width * 0.7,
//               ),
//               const SizedBox(height: kGap),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(lController.getLang("Time Left"), style: title),
//                   SizedBox(
//                     width: 64,
//                     child: Text(
//                       displayDuration(),
//                       textAlign: TextAlign.center,
//                       style: title.copyWith(
//                         fontWeight: FontWeight.w600,
//                         color: kAppColor,
//                       ),
//                     ),
//                   ),
//                   Text(lController.getLang("Minutes"), style: title),
//                 ],
//               ),
//               const SizedBox(height: kGap + kHalfGap),
//               Column(
//                 children: [
//                   ButtonCustom(
//                     title: lController.getLang("Download"),
//                     width: 180,
//                     height: 2.5*kGap,
//                     onPressed: () async {
//                       ShowDialog.showLoadingDialog();
//                       final res = await _saveImage();
//                       Get.back();
//                       if (res) {
//                         ShowDialog.showSuccessToast(
//                           title: lController.getLang("Successed"),
//                           desc: lController.getLang('text_save_qr_1')
//                         );
//                       } else {
//                         ShowDialog.showErrorToast(
//                           title: lController.getLang("Error"),
//                           desc: lController.getLang('text_save_qr_2')
//                         );
//                       }
//                     },
//                   ),
//                   const SizedBox(height: kHalfGap),
//                   ButtonCustom(
//                     title: lController.getLang("New QR Code"),
//                     width: 180,
//                     height: 2.5*kGap,
//                     isOutline: true,
//                     onPressed: () => _generateNewQRCode(_customerController),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       bottomNavigationBar: isLoading
//         ? const SizedBox.shrink()
//         : Padding(
//           padding: kPaddingSafeButton,
//           child: ButtonFull(
//             color: kAppColor,
//             title: lController.getLang("Verify Payment"),
//             onPressed: () => _onTapComfirm(),
//           ),
//         ),
//     );
//   }

//   void _generateNewQRCode(CustomerController _controller) async {
//     ShowDialog.showForceDialog(
//       lController.getLang("Request a new QR Code"),
//       lController.getLang("text_qr_1"),
//       () {
//         Get.back();
//         _paymentQRCode(_controller);
//       },
//       onCancel: () => Get.back(),
//       confirmText: lController.getLang("Yes"),
//       cancelText: lController.getLang("No"),
//     );
//   }

//   Future<void> _paymentQRCode(CustomerController _controller) async {
//     _timer!.cancel();
//     Payment2C2PModel model = await ApiService.customerPayment2C2P(
//       // amount: _controller.checkoutTotal(),
//       amount: 1,
//       shippingAddressId: _controller.shippingAddress?.id ?? '',
//       shippingFrontend: _controller.shippingMethod?.toJson(),
//       paymentMethodId: _controller.paymentMethod?.id ?? '',
//       billingAddressId: _controller.billingAddress?.id ?? '',
//       shippingCouponFrontend: _controller.discountShipping == null
//         ? '': _controller.discountShipping?.toJson(),
//       couponFrontend: _controller.discountProduct == null
//         ? '': _controller.discountProduct?.toJson(),
//       cashCouponFrontend: _controller.discountCash == null
//         ? '': _controller.discountCash?.toJson(),
//       pointBurn: _controller.discountPoint?.points ?? 0,
//     );

//     ShowDialog.showLoadingDialog();
//     try {
//       PaymentCode paymentCode = PaymentCode(channelCode: 'PPQR');
//       PaymentRequest paymentRequest = QRPaymentBuilder(paymentCode: paymentCode)
//         .setType(QRTypeCode.url)
//         // .setName('Sarun Seepun')
//         // .setEmail(_customerController.customerModel?.email ?? '')
//         // .setMobileNo(_customerController.customerModel?.telephone ?? '')
//         .build();
//       var request = TransactionResultRequestBuilder(
//         paymentToken: model.paymentToken,
//         paymentRequest: paymentRequest,
//       );
//       TransactionResultResponse response = await PGWSDK.proceedTransaction(request);

//       _startTimer(response.expiryTimer ?? 0);
//       setState(() {
//         _model = model;
//         _response = response;
//       });

//       Get.back();
//     } on PlatformException catch (e) {
//       Get.back();
//       ShowDialog.showForceDialog(lController.getLang("Payment Failed"), e.message ?? '', () => Get.back());
//     } catch (e) {
//       Get.back();
//       ShowDialog.showForceDialog(lController.getLang("Payment Failed"), e.toString(), () => Get.back());
//     }
//   }

//   void _onTapComfirm() async {
//     dynamic res = await ApiService.customerPayment2C2PCompleted(payload: _model.payload);
//     if(res['orderId'] != null){
//       Get.offAll(() => ThankYouScreen(orderTemp: res));
//     }
//   }
// }