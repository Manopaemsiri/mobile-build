import 'dart:convert';

/*
  order
    1 = ที่ต้องจัดส่ง
    2 = กำลังจัดส่ง
    3 = ส่งสินค้าสำเร็จ
    4 = ยกเลิก/คืนสินค้า
    
  status
    0 = ไม่แสดง
    1 = แสดง
*/

ShippingStatusModel shippingStatusModelFromJson(String str) =>
  ShippingStatusModel.fromJson(json.decode(str));
String shippingStatusModelToJson(ShippingStatusModel data) => 
  json.encode(data.toJson());

class ShippingStatusModel {
  ShippingStatusModel({
    this.id,
    this.name = '',
    this.order = 0,
    this.status = 0,
  });

  String? id;
  String name;
  int order;
  int status;

  factory ShippingStatusModel.fromJson(Map<String, dynamic> json) => 
    ShippingStatusModel(
      id: json["id"],
      name: json["name"] ?? '',
      order: json["order"] ?? 0,
      status: json["status"] ?? 0
    );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "order": order,
    "status": status
  };

  bool isValid() {
    return id != null? true: false;
  }
}
