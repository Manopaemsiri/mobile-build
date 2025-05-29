import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:coffee2u/screens/customer/thank_you/read.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:image/image.dart' as img;

import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';

import '../../../../apis/api_service.dart';
import '../../../../models/customer_subscription_cart_model.dart';
import '../../../../models/partner_shipping_frontend_model.dart';
import '../../../../models/payment_2c2p_model.dart';
import '../../../customer/payment/components/payment_webview.dart';

class SubscriptionConditionsController extends GetxController {
  CustomerSubscriptionCartModel data;
  PartnerShippingFrontendModel shipping;
  SubscriptionConditionsController({required this.data, required this.shipping});

  late SignatureController controllerWidget;
  SignatureController get controller => controllerWidget;
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;
  
  bool _ended = false;
  bool get ended => _ended;

  String _htmlContent = '';
  String get htmlContent => _htmlContent;

  int _stateStatus = 0;
  int get stateStatus => _stateStatus;

  @override
  void onInit() {
    _onInit();
    super.onInit();
  }

  Future<void> _onInit() async {
    controllerWidget = SignatureController(
      penStrokeWidth: 1,
      penColor: kBlueColor,
      exportBackgroundColor: Colors.transparent,
      exportPenColor: kBlueColor,
    );
    controllerWidget.addListener(() {
      if(controllerWidget.isNotEmpty){
        _ended = true;
      }else{
        _ended = false;
      }
      update();
    });
    _scrollController.addListener(_listener);
    _htmlContent = data.subscription?.agreement ?? ''; 
    _stateStatus = 1;
    update();
  }

  void _listener(){
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && ended == false) {
      // _ended = true;
    }
    update();
  }
  scrollToEndOfList() =>
    _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 450), curve: Curves.easeIn);

  @override
  void onClose() {
    controllerWidget.removeListener(() { });
    controllerWidget.dispose();
    _scrollController.dispose();
    super.onClose();
  }

  redo() =>
    controllerWidget.redo();
  undo() =>
    controllerWidget.undo();
  clear() =>
    controllerWidget.clear();

  onSubmit() async {
    if(!ended) return;
    if(controllerWidget.isEmpty){
      ShowDialog.showErrorToast(
        title: lController.getLang("Error"),
        desc: lController.getLang('text_error_signature_1')
      );
      scrollToEndOfList();
      return;
    }

    final String? signatureBase64 = await exportSignatureBase64();
    if(signatureBase64?.isEmpty == true) return;

    try {
      final Payment2C2PModel res = await ApiService.customerSubscriptionPayment2C2P(
        amount: data.displayGrandTotal(shipping),
        signature: signatureBase64!,
        shippingFrontend: shipping,
        shippingAddressId: data.shippingAddress!.id!,
        billingAddressId: data.billingAddress?.id,
      );
      if(res.isValid()){
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) =>
            PaymentWebviewScreen(
              model: res,
              url: res.webPaymentUrl,
              subscription: true,
            ),
        )).then((value) async {
          ShowDialog.showLoadingDialog();
          dynamic res2;
          bool isFailed = true;
          for(int _ in [0,1,2,3]){
            res2 = await ApiService.customerPayment2C2PCompleted(payload: res.payload);
            if(res2?['orderId'] != null){
              isFailed = false;
              Get.offAll(() => ThankYouScreen(orderTemp: res2, subscription: true));
              break;
            }
            await Future.delayed(const Duration(seconds: 1));
          }
          if(isFailed){
            Get.back();
            if(res2?['error'] != null) ShowDialog.showForceDialog("Payment Failed", "${res2?['error']}", () => Get.back());
          }
        });
      }
    } catch (_) {}
  }

  Future<String?> exportSignatureBase64({int width = 400, int quality = 70}) async {
    try {
      if (controllerWidget.isEmpty) return null;
      int height = (width * 160 / 400).round();

      ui.Image? image = await controllerWidget.toImage();
      if (image == null) return null;

      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;

      Uint8List pngBytes = byteData.buffer.asUint8List();

      img.Image? decodedImage = img.decodePng(pngBytes);
      if (decodedImage == null) return null;

      img.Image resizedImage = img.copyResize(decodedImage, width: width, height: height);
      Uint8List resizedJpeg = Uint8List.fromList(img.encodeJpg(resizedImage, quality: quality));
      String base64String = base64Encode(resizedJpeg);

      while (base64String.length > 8096 && quality > 10) {
        quality -= 10;
        resizedJpeg = Uint8List.fromList(img.encodeJpg(resizedImage, quality: quality));
        base64String = base64Encode(resizedJpeg);
      }

      return base64String.length <= 8096? base64String: null;
    } catch (_) {
      return null;
    }
  }

}