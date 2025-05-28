import 'dart:convert';
import 'package:coffee2u/models/index.dart';
import 'package:html_unescape/html_unescape.dart';

PartnerProductCategoryModel partnerProductCategoryModelFromJson(String str) =>
  PartnerProductCategoryModel.fromJson(json.decode(str));
String partnerProductCategoryModelToJson(PartnerProductCategoryModel model) =>
  json.encode(model.toJson());

class PartnerProductCategoryModel {
  PartnerProductCategoryModel({
    this.id,
    this.name = '',
    this.description = '',
    this.url = '',
    this.image,
    this.icon,
    this.order = 1,
    this.status = 0,
  });

  final String? id;
  final String name;
  final String description;
  final String url;
  FileModel? image;
  FileModel? icon;
  final int order;
  final int status;

  factory PartnerProductCategoryModel.fromJson(Map<String, dynamic> json){
    var unescape = HtmlUnescape();
    return PartnerProductCategoryModel(
      id: json["_id"],
      name: json["name"]==null? '': unescape.convert(json["name"]),
      description: json["description"]==null? '': unescape.convert(json["description"]),
      url: json["url"] ?? '',
      image: json["image"] == null || json["image"] is String
        ? null: FileModel.fromJson(json["image"]),
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
    "image": image?.toJson(),
    "icon": icon?.toJson(),
    "order": order,
    "status": status,
  };
}
