import 'dart:convert';

/*
  status
    0 = ไม่แสดง
    1 = แสดง
*/

ShippingSubStatusModel shippingSubStatusModelFromJson(String str) =>
  ShippingSubStatusModel.fromJson(json.decode(str));
String shippingSubStatusModelToJson(ShippingSubStatusModel data) => 
  json.encode(data.toJson());

class ShippingSubStatusModel {
  ShippingSubStatusModel({
    this.id,
    this.name = '',
    this.description = '',
    this.order = 0,
    this.status = 0,
  });

  String? id;
  String name;
  String description;
  int order;
  int status;

  factory ShippingSubStatusModel.fromJson(Map<String, dynamic> json) => 
    ShippingSubStatusModel(
      id: json["id"],
      name: json["name"] ?? '',
      description: json["description"] ?? '',
      order: json["order"] ?? 0,
      status: json["status"] ?? 0
    );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "description": description,
    "order": order,
    "status": status
  };

  bool isValid() {
    return id != null? true: false;
  }
}
