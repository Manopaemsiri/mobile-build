import 'dart:convert';

Payment2C2PModel payment2C2PModelFromJson(String str) =>
  Payment2C2PModel.fromJson(json.decode(str));
String payment2C2PModelToJson(Payment2C2PModel model) => 
  json.encode(model.toJson());

class Payment2C2PModel {
  Payment2C2PModel({
    this.webPaymentUrl = '',
    this.paymentToken = '',
    this.orderId2C2P = '',
    this.payload = '',
  });

  String webPaymentUrl;
  String paymentToken;
  String orderId2C2P;
  String payload;

  factory Payment2C2PModel.fromJson(Map<String, dynamic> json) => 
    Payment2C2PModel(
      webPaymentUrl: json["webPaymentUrl"] ?? '',
      paymentToken: json["paymentToken"] ?? '',
      orderId2C2P: json["orderId2C2P"] ?? '',
      payload: json["payload"] ?? '',
    );

  Map<String, dynamic> toJson() => {
    "webPaymentUrl": webPaymentUrl,
    "paymentToken": paymentToken,
    "orderId2C2P": orderId2C2P,
    "payload": payload,
  };
  

  bool isValid() {
    return webPaymentUrl != '' && paymentToken != ''
      && orderId2C2P != '' && payload != ''? true: false;
  }
}
