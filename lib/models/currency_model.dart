
import 'dart:convert';

import 'package:coffee2u/models/index.dart';

CurrencyModel currencyModelFromJson(String str) =>
  CurrencyModel.fromJson(json.decode(str));
String currencyModelToJson(CurrencyModel model) => 
  json.encode(model.toJson());

class CurrencyModel{
   CurrencyModel({
    this.id = "",
    this.code = "",
    this.icon = "",
    this.unit = "",
    this.name = "",
    this.exchangeRate = 1,
    this.image,
    this.isDefault = 0,
    this.order = 1,
    this.status = 0,
   });
  String id;

  String code;
  String icon;
  String unit;

  String name;
  double exchangeRate;

  FileModel? image;

  int isDefault;
  int order;
  int status;

  factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
    id: json["_id"] ?? "",
    code: json["code"] ?? "",
    icon: json["icon"] ?? "",
    unit: json["unit"] ?? "",
    name: json["name"] ?? "",
    exchangeRate: json["exchangeRate"] != null? double.parse(json["exchangeRate"].toString()): 1.0,
    image: json["image"] != null && json["image"] is! String? FileModel.fromJson(json["image"]): null,
    isDefault: json["isDefault"] != null? int.parse(json["isDefault"].toString()): 0,
    order: json["order"] != null? int.parse(json["order"].toString()): 1,
    status: json["status"] != null? int.parse(json["status"].toString()): 0,

  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "code": code,
    "icon": icon,
    "unit": unit,
    "name": name,
    "exchangeRate": exchangeRate,
    "image": image?.toJson(),
    "isDefault": isDefault,
    "order": order,
    "status": status,
  };

  isValid() {
    return id != ''? true: false;
  }

}