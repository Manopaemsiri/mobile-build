import 'dart:convert';
import 'package:coffee2u/models/index.dart';
import 'package:html_unescape/html_unescape.dart';

CustomerTierModel customerTierModelFromJson(String str) =>
  CustomerTierModel.fromJson(json.decode(str));
String customerTierModelToJson(CustomerTierModel model) =>
  json.encode(model.toJson());

class CustomerTierModel {
  CustomerTierModel({
    this.id,
    
    this.name = '',
    this.description = '',
    this.url = '',
    this.icon,

    this.pointBurnStep = 1000,

    this.pointEarnRate = 0,
    this.pointBurnRate = 0,
    this.minOrderMonthly = 0,

    this.order = 1,
    this.isDefault = 0,
    this.status = 0,
  });

  final String? id;

  final String name;
  final String description;
  final String url;
  final FileModel? icon;

  final double pointBurnStep;

  final double pointEarnRate;
  final double pointBurnRate;
  final double minOrderMonthly;

  final int order;
  final int isDefault;
  final int status;

  factory CustomerTierModel.fromJson(Map<String, dynamic> json){
    var unescape = HtmlUnescape();
    return CustomerTierModel(
      id: json["_id"],
      name: json["name"]==null? '': unescape.convert(json["name"]),
      description: json["description"]==null? '': unescape.convert(json["description"]),
      url: json["url"] ?? '',
      icon: json["icon"] == null || json["icon"] is String? null :FileModel.fromJson(json["icon"]),
      pointBurnStep: json["pointBurnStep"] == null
        ? 1000.0: double.parse(json["pointBurnStep"].toString()),
      pointEarnRate: json["pointEarnRate"] == null
        ? 0.0: double.parse(json["pointEarnRate"].toString()),
      pointBurnRate: json["pointBurnRate"] == null
        ? 0.0: double.parse(json["pointBurnRate"].toString()),
      minOrderMonthly: json["minOrderMonthly"] == null
        ? 0.0: double.parse(json["minOrderMonthly"].toString()),
      order: json["order"] ?? 1,
      isDefault: json["isDefault"] ?? 0,
      status: json["status"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "description": description,
    "url": url,
    "icon": icon == null? null: icon!.toJson(),
    "pointBurnStep": pointBurnStep,
    "pointEarnRate": pointEarnRate,
    "pointBurnRate": pointBurnRate,
    "minOrderMonthly": minOrderMonthly,
    "order": order,
    "isDefault": isDefault,
    "status": status,
  };
}
