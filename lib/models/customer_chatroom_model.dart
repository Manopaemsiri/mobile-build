import 'dart:convert';

import 'package:intl/intl.dart';

CustomerChatroomModel customerChatroomModelFromJson(String str) =>
  CustomerChatroomModel.fromJson(json.decode(str));
String customerChatroomModelToJson(CustomerChatroomModel model) =>
  json.encode(model.toJson());

class CustomerChatroomModel {
  CustomerChatroomModel({
    this.id,
    
    this.customer = const { "_id": "", "name": "", "icon": "" },
    this.partnerShop = const { "_id": "", "code": "", "name": "", "icon": "" },
    this.firebaseChatroomId = '',

    // Firebase Data
    this.isReadAdmin = true,
    this.isReadPartner = true,
    this.isReadSalesManager = true,
    this.isReadCustomer = true,

    this.recentMessage = const {
      "text": "",
      "images": [],
      "sender": { "id": "", "name": "", "icon": "" },
      "createdAt": null,
      "fromCustomer": false
    },

    this.createdAt,
    this.updatedAt,
  });

  String? id;

  Map<String, dynamic> customer;
  Map<String, dynamic> partnerShop;
  String firebaseChatroomId;

  bool isReadAdmin;
  bool isReadPartner;
  bool isReadSalesManager;
  bool isReadCustomer;

  Map<String, dynamic> recentMessage;
  
  DateTime? createdAt;
  DateTime? updatedAt;

  factory CustomerChatroomModel.fromJson(Map<String, dynamic> json) =>
    CustomerChatroomModel(
      id: json["_id"],

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
      firebaseChatroomId: json["firebaseChatroomId"] ?? '',

      // Firebase Data
      isReadAdmin: json["isReadAdmin"] == null
        ? true: json["isReadAdmin"].toString() == 'true',
      isReadPartner: json["isReadPartner"] == null
        ? true: json["isReadPartner"].toString() == 'true',
      isReadSalesManager: json["isReadSalesManager"] == null
        ? true: json["isReadSalesManager"].toString() == 'true',
      isReadCustomer: json["isReadCustomer"] == null
        ? true: json["isReadCustomer"].toString() == 'true',

      recentMessage: json["recentMessage"] == null
        ? {
          "text": "",
          "images": [],
          "sender": { "_id": null, "name": "", "icon": "" },
          "createdAt": null,
          "fromCustomer": false
        }
        : {
          "text": json["recentMessage"]["text"] ?? '',
          "images": json["recentMessage"]["images"] == null
            ? []: json["recentMessage"]["images"].toList(),
          "sender": json["recentMessage"]["sender"] == null
            ? { "_id": "", "name": "", "icon": "" }
            : {
              "_id": json["recentMessage"]["sender"]["_id"] ?? '',
              "name": json["recentMessage"]["sender"]["name"] ?? '',
              "icon": json["recentMessage"]["sender"]["icon"] ?? ''
            },
          "createdAt": json["recentMessage"]["sender"]["createdAt"] == null
            ? null: DateTime.parse(json["recentMessage"]["sender"]["createdAt"]),
          "fromCustomer": json["recentMessage"]["sender"]["fromCustomer"] == null
            ? false: json["recentMessage"]["sender"]["fromCustomer"].toString() == 'true'
        },

      createdAt: json["createdAt"] == null
        ? null: DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null
        ? null: DateTime.parse(json["updatedAt"]),
    );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "customer": customer,
    "partnerShop": partnerShop,
    "firebaseChatroomId": firebaseChatroomId,
    "isReadAdmin": isReadAdmin,
    "isReadPartner": isReadPartner,
    "isReadSalesManager": isReadSalesManager,
    "isReadCustomer": isReadCustomer,
    "recentMessage": recentMessage,
    "createdAt": createdAt == null
      ? null: DateFormat('yyyy-MM-ddTHH:mm:ss').format(createdAt!),
    "updatedAt": updatedAt == null
      ? null: DateFormat('yyyy-MM-ddTHH:mm:ss').format(updatedAt!),
  };

  bool isValid() {
    return id != null? true: false;
  }
}
