import 'dart:convert';
import 'package:coffee2u/models/index.dart';
import 'package:html_unescape/html_unescape.dart';

PartnerProductCategoryGroupModel partnerProductCategoryGroupModelFromJson(String str) =>
  PartnerProductCategoryGroupModel.fromJson(json.decode(str));
String partnerProductCategoryGroupModelToJson(PartnerProductCategoryGroupModel model) =>
  json.encode(model.toJson());

class PartnerProductCategoryGroupModel {
  PartnerProductCategoryGroupModel({
    this.id,
    this.name = '',
    this.description = '',
    this.categories = const [],
    this.url = '',
    this.image,
    this.icon,
    this.order = 1,
    this.status = 0,
  });

  final String? id;
  final String name;
  final String description;
  final List<PartnerProductCategoryModel> categories;
  final String url;
  FileModel? image;
  FileModel? icon;
  final int order;
  final int status;

  factory PartnerProductCategoryGroupModel.fromJson(Map<String, dynamic> json){
    var unescape = HtmlUnescape();
    return PartnerProductCategoryGroupModel(
      id: json["_id"],
      name: json["name"]==null? '': unescape.convert(json["name"]),
      description: json["description"]==null? '': unescape.convert(json["description"]),
      categories: json["categories"] == null || json["categories"] is String? []
        : List<PartnerProductCategoryModel>.from(json["categories"]
          .where((x) => x is! String)
          .map((x) => PartnerProductCategoryModel.fromJson(x))),
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
    "categories": List<PartnerProductCategoryModel>
      .from(categories.map((e) => e.toJson())),
    "url": url,
    "image": image?.toJson(),
    "icon": icon?.toJson(),
    "order": order,
    "status": status,
  };
}
