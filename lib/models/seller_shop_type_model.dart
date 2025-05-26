import 'dart:convert';
import 'package:coffee2u/models/index.dart';
import 'package:html_unescape/html_unescape.dart';

SellerShopTypeModel sellerShopTypeModelFromJson(String str) =>
  SellerShopTypeModel.fromJson(json.decode(str));
String sellerShopTypeModelToJson(SellerShopTypeModel model) =>
  json.encode(model.toJson());

class SellerShopTypeModel {
  SellerShopTypeModel({
    this.id,
    this.name = '',
    this.description = '',
    this.url = '',
    this.icon,
    this.order = 1,
    this.status = 0,
  });

  final String? id;
  final String name;
  final String description;
  final String url;
  FileModel? icon;
  final int order;
  final int status;

  factory SellerShopTypeModel.fromJson(Map<String, dynamic> json){
    var unescape = HtmlUnescape();
    return SellerShopTypeModel(
      id: json["_id"],
      name: json["name"]==null? '': unescape.convert(json["name"]),
      description: json["description"]==null? '': unescape.convert(json["description"]),
      url: json["url"] ?? '',
      icon: json["icon"] == null || json["icon"] is String
        ? null: FileModel.fromJson(json["icon"]),
      order: json["order"] ?? 1,
      status: json["status"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "description": description,
    "url": url,
    "icon": icon == null? null: icon!.toJson(),
    "order": order,
    "status": status,
  };
}