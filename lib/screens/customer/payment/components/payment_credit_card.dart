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

// import 'package:pgw_sdk/builder/card_payment_builder.dart';
// import 'package:pgw_sdk/models/payment_code.dart';
// import 'package:pgw_sdk/models/payment_request.dart';
// import 'package:pgw_sdk/models/transaction_result_request_builder.dart';
// import 'package:pgw_sdk/models/transaction_result_response.dart';
// import 'package:pgw_sdk/pgw_sdk.dart';

// class FormatterCardNumber extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
//     var text = newValue.text;
//     if (newValue.selection.baseOffset == 0) {
//       return newValue;
//     }
//     var buffer = StringBuffer();
//     for (int i = 0; i < text.length; i++) {
//       buffer.write(text[i]);
//       var nonZeroIndex = i + 1;
//       if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
//         buffer.write('  '); // Add double spaces.
//       }
//     }
//     var string = buffer.toString();
//     return newValue.copyWith(
//       text: string,
//       selection: TextSelection.collapsed(offset: string.length)
//     );
//   }
// }
// class FormatterCardExpired extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
//     var newText = newValue.text;
//     if (newValue.selection.baseOffset == 0) {
//       return newValue;
//     }
//     var buffer = StringBuffer();
//     bool needSlash = true;
//     for (int i = 0; i < newText.length; i++) {
//       buffer.write(newText[i]);
//       var nonZeroIndex = i + 1;
//       if (needSlash && nonZeroIndex % 2 == 0 && nonZeroIndex != newText.length) {
//         needSlash = false;
//         buffer.write('/');
//       }
//     }
//     var string = buffer.toString();
//     return newValue.copyWith(
//       text: string,
//       selection: TextSelection.collapsed(offset: string.length)
//     );
//   }
// }

// enum CardType {
//   master,
//   visa,
//   discover,
//   americanExpress,
//   jcb,
//   others,
//   invalid
// }


// class PaymentCreditCardScreen extends StatefulWidget {
//   const PaymentCreditCardScreen({
//     super.key,
//     required this.model,
//   });

//   final Payment2C2PModel model;

//   @override
//   State<PaymentCreditCardScreen> createState() => _PaymentCreditCardScreenState();
// }

// class _PaymentCreditCardScreenState extends State<PaymentCreditCardScreen> {
//   final LanguageController lController = Get.find<LanguageController>();
//   final CustomerController controllerCustomer = Get.find<CustomerController>();
//   Widget? _cardIcon;

//   // Form Key
//   final _formKey = GlobalKey<FormState>();

//   // Text Controller
//   final TextEditingController _cNumber = TextEditingController();
//   final TextEditingController _cName = TextEditingController();
//   final TextEditingController _cCvv = TextEditingController();
//   final TextEditingController _cExpired = TextEditingController();

//   // Focus Node
//   final FocusNode _fNumber = FocusNode();
//   final FocusNode _fName = FocusNode();
//   final FocusNode _fCvv = FocusNode();
//   final FocusNode _fExpired = FocusNode();

//   bool _isValid() {
//     return controllerCustomer.paymentMethod != null 
//       && controllerCustomer.paymentMethod!.isValid() 
//       && _cNumber.text != '' && _cName.text != '' && _cCvv.text != '' 
//       && _cExpired.text != '' && _cExpired.text.length == 5;
//   }
  
//   void getCardIcon(String input) {
//     input = input.replaceAll(' ', '');
//     CardType cardType;
//     if (input.startsWith(RegExp(r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))'))) {
//       cardType = CardType.master;
//     } else if (input.startsWith(RegExp(r'[4]'))) {
//       cardType = CardType.visa;
//     } else if (input.startsWith(RegExp(r'((34)|(37))'))) {
//       cardType = CardType.americanExpress;
//     } else if (input.startsWith(RegExp(r'((6[45])|(6011))'))) {
//       cardType = CardType.discover;
//     } else if (input.startsWith(RegExp(r'(352[89]|35[3-8][0-9])'))) {
//       cardType = CardType.jcb;
//     } else if (input.length <= 8) {
//       cardType = CardType.others;
//     } else {
//       cardType = CardType.invalid;
//     }

//     String img = '';
//     Icon? icon;
//     switch (cardType) {
//       case CardType.master:
//         img = 'assets/icons/payment/mastercard.png';
//         break;
//       case CardType.visa:
//         img = 'assets/icons/payment/visa.png';
//         break;
//       case CardType.americanExpress:
//         img = 'assets/icons/payment/american-express.png';
//         break;
//       case CardType.discover:
//         img = 'assets/icons/payment/discover.png';
//         break;
//       case CardType.jcb:
//         img = 'assets/icons/payment/jcb.png';
//         break;
//       case CardType.others:
//         icon = const Icon(
//           Icons.credit_card,
//           size: 28,
//           color: Color(0xFFB8B5C3),
//         );
//         break;
//       default:
//         icon = const Icon(
//           Icons.warning,
//           size: 28,
//           color: Color(0xFFB8B5C3),
//         );
//         break;
//     }
//     Widget? widget;
//     if (img.isNotEmpty) {
//       widget = Padding(
//         padding: const EdgeInsets.only(right: 12.0),
//         child: Image.asset(img, width: 36.0),
//       );
//     } else {
//       widget = Padding(
//         padding: const EdgeInsets.only(right: 6.0),
//         child: icon,
//       );
//     }
//     setState(() => _cardIcon = widget);
//   }

//   @override
//   void initState() {
//     _cNumber.addListener(() => getCardIcon(_cNumber.text));
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _cNumber.dispose();
//     super.dispose();
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
//                   controller: _cNumber,
//                   focusNode: _fNumber,
//                   keyboardType: TextInputType.number,
//                   textInputAction: TextInputAction.done,
//                   inputFormatters: [
//                     FilteringTextInputFormatter.digitsOnly,
//                     LengthLimitingTextInputFormatter(19),
//                     FormatterCardNumber(),
//                   ],
//                   decoration: InputDecoration(
//                     border: const OutlineInputBorder(),
//                     hintText: lController.getLang("Card Number"),
//                     prefixIcon: const Icon(
//                       Icons.credit_card,
//                       size: 26,
//                       color: Color(0xFFB8B5C3),
//                     ),
//                     suffixIcon: _cardIcon,
//                   ),
//                   validator: (value) => Utils.validateString(value),
//                   onFieldSubmitted: (str) => _fName.requestFocus(),
//                 ),
                
//                 const SizedBox(height: kGap),
//                 TextFormField(
//                   controller: _cName,
//                   focusNode: _fName,
//                   keyboardType: TextInputType.name,
//                   decoration: InputDecoration(
//                     border: const OutlineInputBorder(),
//                     hintText: lController.getLang("Card Holder"),
//                     prefixIcon: const Icon(
//                       Icons.person_outline,
//                       size: 26,
//                       color: Color(0xFFB8B5C3),
//                     ),
//                   ),
//                   validator: (value) => Utils.validateString(value),
//                   onFieldSubmitted: (str) => _fCvv.requestFocus(),
//                 ),

//                 const SizedBox(height: kGap),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         controller: _cCvv,
//                         focusNode: _fCvv,
//                         keyboardType: TextInputType.number,
//                         textInputAction: TextInputAction.done,
//                         obscureText: true,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.digitsOnly,
//                           LengthLimitingTextInputFormatter(4),
//                         ],
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           hintText: 'CVV',
//                           prefixIcon: Icon(
//                             Icons.security,
//                             size: 24,
//                             color: Color(0xFFB8B5C3),
//                           ),
//                         ),
//                         validator: (value) => Utils.validateString(value),
//                         onFieldSubmitted: (str) => _fExpired.requestFocus(),
//                       ),
//                     ),
//                     const SizedBox(width: kGap),
//                     Expanded(
//                       child: TextFormField(
//                         controller: _cExpired,
//                         focusNode: _fExpired,
//                         keyboardType: TextInputType.number,
//                         textInputAction: TextInputAction.done,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.digitsOnly,
//                           LengthLimitingTextInputFormatter(4),
//                           FormatterCardExpired(),
//                         ],
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           hintText: 'MM/YY',
//                           prefixIcon: Icon(
//                             Icons.calendar_month_outlined,
//                             size: 26,
//                             color: Color(0xFFB8B5C3),
//                           ),
//                         ),
//                         validator: (value) => Utils.validateString(value),
//                         onFieldSubmitted: (str) => FocusScope.of(context).unfocus(),
//                       ),
//                     ),
//                   ],
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
//         List<String> _expired = _cExpired.text.split('/');
//         PaymentCode paymentCode = PaymentCode(channelCode: 'CC');
//         PaymentRequest paymentRequest = CardPaymentBuilder(paymentCode: paymentCode)
//           .setCardNo(_cNumber.text.replaceAll(' ', ''))
//           .setName(_cName.text)
//           .setSecurityCode(_cCvv.text)
//           .setExpiryMonth(int.parse(_expired[0]))
//           .setExpiryYear(int.parse(_expired[1]) + 2000)
//           .setEmail(controllerCustomer.customerModel?.email ?? '')
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