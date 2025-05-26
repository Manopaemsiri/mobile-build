import 'dart:convert';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:html_unescape/html_unescape.dart';

PartnerProductSubCategoryModel partnerProductSubCategoryModelFromJson(String str) 
  => PartnerProductSubCategoryModel.fromJson(json.decode(str));
String partnerProductSubCategoryModelToJson(PartnerProductSubCategoryModel model) 
  => json.encode(model.toJson());

class PartnerProductSubCategoryModel {
  PartnerProductSubCategoryModel({
    this.id,
    this.name = '',
    this.description = '',
    this.url = '',
    this.image,
    this.icon,
    this.category,
    this.order = 1,
    this.status = 0,
  });

  String? id;

  String name;
  String description;
  String url;

  FileModel? image;
  FileModel? icon;

  PartnerProductCategoryModel? category;

  int order;
  int status;

  factory PartnerProductSubCategoryModel.fromJson(Map<String, dynamic> json){
    var unescape = HtmlUnescape();
    return PartnerProductSubCategoryModel(
      id: json["_id"],
      name: json["name"]==null? '': unescape.convert(json["name"]),
      description: json["description"]==null? '': unescape.convert(json["description"]),
      url: json["url"] ?? '',
      image: json["image"] == null || json["image"] is String? null: FileModel.fromJson(json["image"]),
      icon: json["icon"] == null || json["icon"] is String? null: FileModel.fromJson(json["icon"]),
      category: json["category"] == null || json["category"] is String? null: PartnerProductCategoryModel.fromJson(json["category"]),
      order: json["order"] ?? 1,
      status: json["status"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "description": description,
    "url": url,
    "image": image == null ? null : image!.toJson(),
    "icon": icon == null ? null : icon!.toJson(),
    "category": category == null ? null : category!.toJson(),
    "order": order,
    "status": status,
  };

  isValid() {
    return id != null ? true : false;
  }

  String displayStatus(LanguageController controller) {
    if (isValid()) {
      if (status == 1) {
        return controller.getLang("Active");
      } else {
        return controller.getLang("Inactive");
      }
    } else {
      return controller.getLang("Inactive");
    }
  }
}
