import 'dart:convert';

PaymentStripeModel paymentStripeModelFromJson(String str) =>
  PaymentStripeModel.fromJson(json.decode(str));
String paymentStripeModelToJson(PaymentStripeModel model) => 
  json.encode(model.toJson());

class PaymentStripeModel {
  PaymentStripeModel({
    this.id = '',
    this.object = '',
    this.clientSecret = '',
    this.amount = 0,
    this.orderId2C2P = '',
    this.publishKey = '',
  });

  String id;
  String object;
  String clientSecret;
  double amount;
  String orderId2C2P;
  String publishKey;

  factory PaymentStripeModel.fromJson(Map<String, dynamic> json) => 
    PaymentStripeModel(
      id: json["id"] ?? '',
      object: json["object"] ?? '',
      clientSecret: json["clientSecret"] ?? '',
      amount: json["amount"] == null
        ? 0: double.parse(json["amount"].toString()),
      orderId2C2P: json["orderId2C2P"] ?? '',
      publishKey: json["publishKey"] ?? '',
    );

  Map<String, dynamic> toJson() => {
    "id": id,
    "object": object,
    "clientSecret": clientSecret,
    "amount": amount,
    "orderId2C2P": orderId2C2P,
    "publishKey": publishKey,
  };
  

  bool isValid() {
    return id != '' && clientSecret != '' 
      && orderId2C2P != '' && publishKey != ''? true: false;
  }
}
