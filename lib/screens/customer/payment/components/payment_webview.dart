import 'dart:async';
// import 'dart:convert';
import 'dart:io';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebviewScreen extends StatefulWidget {
  const PaymentWebviewScreen({
    super.key,
    required this.model,
    required this.url,
    this.title = 'Payment Confirmation',
    this.subscription = false,
  });

  final Payment2C2PModel model;
  final String url;
  final String title;
  final bool subscription;

  @override
  State<PaymentWebviewScreen> createState() => _PaymentWebviewScreenState();
}

class _PaymentWebviewScreenState extends State<PaymentWebviewScreen> {
  final LanguageController lController = Get.find<LanguageController>();
  // final Completer<WebViewController> _webviewController = Completer<WebViewController>();
  late WebViewController controllerWidget;

  @override
  void initState() {
    super.initState();
    controllerWidget = WebViewController()
    ..enableZoom(false)
    ..setBackgroundColor(const Color(0xFFFFFFFF))
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        // onWebViewCreated: (WebViewController controllerWidget) =>
        //   _webviewController.complete(controllerWidget),
        onPageFinished: (String url) async {
          if(url.contains('checkout-payment-2c2p-validate') || url.contains('payment/success/')){
            if(widget.subscription){
              Get.until((route) => Get.currentRoute == '/SubscriptionConditionsScreen');
            }else{
              Get.until((route) => Get.currentRoute == '/PaymentMethodsScreen');
            }
          }
        },
        onNavigationRequest: Platform.isAndroid
        ? (NavigationRequest request) async {
          if (request.url.startsWith('data:image/')) {
            await _downloadFile(request.url);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        }: null,
        
        onProgress: (int progress) {},
        onPageStarted: (String url) {},
        onHttpError: (HttpResponseError error) {},
      ),
    )
    ..loadRequest(Uri.parse(widget.url));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        title: Text(lController.getLang(widget.title)),
      ),
      body: WebViewWidget(
        controller: controllerWidget,
        
      ),
    );
  }

  Future<void> _downloadFile(String url) async {
    try {
      // final data = url.split(',')[1];
      // final bytes = base64.decode(data);
      // final result = await ImageGallerySaver.saveImage(
      //   bytes,
      //   quality: 80,
      // );
      // String snackBarText = lController.getLang("text_save_qr_2");
      // if (result["isSuccess"] == true) snackBarText = lController.getLang("text_save_qr_1");
      
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(
      //     snackBarText,
      //     style: subtitle1.copyWith(
      //       fontWeight: FontWeight.w500,
      //       fontFamily: 'Kanit'
      //     ),
      //   ),
      //   behavior: SnackBarBehavior.floating,
      // ));
    }catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          lController.getLang("text_save_qr_2"),
          style: subtitle1.copyWith(
            fontWeight: FontWeight.w500,
            fontFamily: 'Kanit'
          ),
        ),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }
}