import 'dart:convert';

import 'package:intl/intl.dart';

CustomerNotiModel customerNotiModelFromJson(String str) =>
  CustomerNotiModel.fromJson(json.decode(str));
String customerNotiModelToJson(CustomerNotiModel model) =>
  json.encode(model.toJson());

class CustomerNotiModel {
  CustomerNotiModel({
    this.id,
    this.type = 1,
    
    this.customer = const { "_id": "", "name": "", "icon": "" },
    this.partnerShop = const { "_id": "", "code": "", "name": "", "icon": "" },
    this.order = const { "_id": "", "orderId": "" },
    this.subscription = const { "_id": "", "name": "", "image": "", "description": "" },

    // Firebase Data
    this.isReadCustomer = true,

    this.shippingStatus = '',
    this.shippingSubStatus = '',

    this.updatedAt,
  });

  String? id;
  int? type;

  Map<String, dynamic> customer;
  Map<String, dynamic> partnerShop;
  Map<String, dynamic> order;
  Map<String, dynamic> subscription;

  bool isReadCustomer;

  String shippingStatus;
  String shippingSubStatus;
  
  DateTime? updatedAt;

  factory CustomerNotiModel.fromJson(Map<String, dynamic> json) =>
    CustomerNotiModel(
      id: json["_id"],
      type: json["type"] ?? 1,

      customer: json["customer"] == null
        ? { "_id": "", "name": "", "icon": "" }
        : {
          "_id": json["customer"]["_id"] ?? '',
          "name": "${json["customer"]["firstname"] ?? ''} ${json["customer"]["lastname"] ?? ''}",
          "icon": json["customer"]["avatar"] == null
            ? '': json["customer"]["avatar"]["path"] ?? '',
        },
      partnerShop: json["partnerShop"] == null
        ? { "_id": "", "code": "", "name": "", "icon": "" }
        : {
          "_id": json["partnerShop"]["_id"] ?? '',
          "code": json["partnerShop"]["code"] ?? '',
          "name": json["partnerShop"]["name"] ?? '',
          "icon": json["partnerShop"]["image"] == null
            ? '': json["partnerShop"]["image"]["path"] ?? '',
        },
      order: json["order"] == null
        ? { "_id": "", "orderId": "" }
        : {
          "_id": json["order"]["_id"] ?? '',
          "orderId": json["order"]["orderId"] ?? '',
        },
      subscription: json["subscription"] == null
        ? { "_id": "", "name": "", "image": "", "description": "" }
        : {
          "_id": json["subscription"]["_id"] ?? '',
          "name": json["subscription"]["name"] ?? '',
          "image": json["subscription"]["image"] ?? '',
          "description": json["subscription"]["description"] ?? '',
        },

      // Firebase Data
      isReadCustomer: json["isReadCustomer"] == null
        ? true: json["isReadCustomer"].toString() == 'true',

      shippingStatus: json["shippingStatus"] ?? '',
      shippingSubStatus: json["shippingSubStatus"] ?? '',

      updatedAt: json["updatedAt"] == null
        ? null: DateTime.parse(json["updatedAt"]),
    );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "type": type,
    "customer": customer,
    "partnerShop": partnerShop,
    "order": order,
    "subscription": subscription,
    "isReadCustomer": isReadCustomer,
    "shippingStatus": shippingStatus,
    "shippingSubStatus": shippingSubStatus,
    "updatedAt": updatedAt == null
      ? null: DateFormat('yyyy-MM-ddTHH:mm:ss').format(updatedAt!),
  };

  bool isValid() {
    return id != null? true: false;
  }

  bool get isSubscription => type == 2;
}
