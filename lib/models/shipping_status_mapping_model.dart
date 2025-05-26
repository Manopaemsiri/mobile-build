import 'dart:convert';

import 'package:coffee2u/models/index.dart';

/*
  type
    - C2U
    - SAP
    - LF
    - Kerry = Kerry / Kerry Express
    - Grab

  status
    0 = ไม่แสดง
    1 = แสดง
*/

ShippingStatusMappingModel shippingStatusMappingModelFromJson(String str) =>
  ShippingStatusMappingModel.fromJson(json.decode(str));

String shippingStatusMappingModelToJson(ShippingStatusMappingModel data) => 
  json.encode(data.toJson());

class ShippingStatusMappingModel {
  ShippingStatusMappingModel({
    this.id,
    this.type = '',
    this.externalStatus = '',
    this.externalSubStatus = '',
    this.externalDescription = '',
    this.shippingStatus,
    this.shippingSubStatus,
    this.status = 0,
    this.createdAt,
    this.updatedAt
  });

  String? id;
  String type;
  String externalStatus;
  String externalSubStatus;
  String externalDescription;
  ShippingStatusModel? shippingStatus;
  ShippingSubStatusModel? shippingSubStatus;
  int status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory ShippingStatusMappingModel.fromJson(Map<String, dynamic> json) => 
    ShippingStatusMappingModel(
      id: json["id"],
      type: json["type"] ?? '',
      externalStatus: json["externalStatus"] ?? '',
      externalSubStatus: json["externalSubStatus"] ?? '',
      externalDescription: json["externalDescription"] ?? '',
      shippingStatus: json["shippingStatus"] != null && json["shippingStatus"] is! String
        ? ShippingStatusModel.fromJson(json["shippingStatus"]) 
        : null,
      shippingSubStatus: json["shippingSubStatus"] != null && json["shippingSubStatus"] is! String
        ? ShippingSubStatusModel.fromJson(json["shippingSubStatus"]) 
        : null,
      status: json["status"] ?? 0,
      createdAt: json["createdAt"] == null
        ? null: DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null
        ? null: DateTime.parse(json["updatedAt"]),
    );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "type": type,
    "externalStatus": externalStatus,
    "externalSubStatus": externalSubStatus,
    "externalDescription": externalDescription,
    "shippingStatus": shippingStatus == null
      ? null: shippingStatus!.toJson(),
    "shippingSubStatus": shippingSubStatus == null
      ? null: shippingSubStatus!.toJson(),
    "status": status,
    "updatedAt": updatedAt == null? null: updatedAt!.toIso8601String(),
    "createdAt": createdAt == null? null: createdAt!.toIso8601String(),
  };
  
  bool isValid() {
    return id != null? true: false;
  }
}
