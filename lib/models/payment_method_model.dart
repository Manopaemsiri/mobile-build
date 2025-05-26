import 'dart:convert';
import 'package:coffee2u/models/file_model.dart';
import 'package:html_unescape/html_unescape.dart';

/*
  type
    1 = 2C2P - บัตรเครดิต/เดบิต
    2 = 2C2P - จ่ายโดย QR Code
    3 = 2C2P - ทรูมันนี่ วอลเล็ท
    4 = Kerry - เก็บเงินปลายทาง
    5 = Stripe - บัตรเครดิต/เดบิต
    6 = Stripe - PromptPay

  status
    0 = Inactive
    1 = Active
*/

PaymentMethodModel paymentMethodModelFromJson(String str) =>
  PaymentMethodModel.fromJson(json.decode(str));
String paymentMethodModelToJson(PaymentMethodModel model) => 
  json.encode(model.toJson());

class PaymentMethodModel {
  PaymentMethodModel({
    this.id,
    this.name = '',
    this.icon,
    this.type = 0,
    this.order = 1,
    this.status = 0,

    this.payNow = 0,
    this.payLater = 0,
    this.diffInstallment = 0,

    this.customDownPayment,
    this.payNowDefault,
    this.payLaterDefault,
  });

  String? id;
  String name;
  FileModel? icon;
  int type;
  int order;
  int status;

  double payNow;
  double payLater;
  double diffInstallment;

  int? customDownPayment;
  double? payNowDefault;
  double? payLaterDefault;

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json){
    var unescape = HtmlUnescape();
    return PaymentMethodModel(
      id: json["_id"],
      name: json["name"] == null? '': unescape.convert(json["name"]),
      icon: json["icon"] == null || json["icon"] is String? null :FileModel.fromJson(json["icon"]),
      type: json["type"] ?? 0,
      order: json["order"] ?? 1,
      status: json["status"] ?? 0,
      
      payNow: json["payNow"] == null? 0: double.parse(json["payNow"].toString()),
      payLater: json["payLater"] == null? 0: double.parse(json["payLater"].toString()),
      diffInstallment: json["diffInstallment"] == null 
        ? 0: double.parse(json["diffInstallment"].toString()),

      customDownPayment: json["customDownPayment"] == null 
        ? null: int.parse(json["customDownPayment"].toString()),
      payNowDefault: json["payNowDefault"] == null 
        ? null: double.parse(json["payNowDefault"].toString()),
      payLaterDefault: json["payLaterDefault"] == null 
        ? null: double.parse(json["payLaterDefault"].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "icon": icon == null? null: icon!.toJson(),
    "type": type,
    "order": order,
    "status": status,

    "payNow": payNow,
    "payLater": payLater,
    "diffInstallment": diffInstallment,

    "customDownPayment": customDownPayment,
    "payNowDefault": payNowDefault,
    "payLaterDefault": payLaterDefault,
  };

  bool isValid() {
    return id != null? true: false;
  }

  bool hasDownPayment() {
    return isValid() && payLater > 0;
  }
  bool hasCustomDownPayment() {
    return hasDownPayment() && customDownPayment != null 
      && (payNowDefault != null || payLaterDefault != null);
  }
}
