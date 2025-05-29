import 'dart:convert';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:html_unescape/html_unescape.dart';

PartnerProductBrandModel partnerProductBrandModelFromJson(String str) =>
    PartnerProductBrandModel.fromJson(json.decode(str));
String partnerProductBrandModelToJson(PartnerProductBrandModel model) =>
    json.encode(model.toJson());

class PartnerProductBrandModel {
  PartnerProductBrandModel({
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

  factory PartnerProductBrandModel.fromJson(Map<String, dynamic> json){
    var unescape = HtmlUnescape();
    return PartnerProductBrandModel(
      id: json["_id"],
      name: json["name"] == null? '': unescape.convert(json["name"]),
      description: json["description"]==null? '': unescape.convert(json["description"]),
      url: json["url"] ?? '',
      image: json["image"] != null && json["image"] is! String? FileModel.fromJson(json["image"]) : null,
      icon: json["icon"] != null && json["icon"] is! String? FileModel.fromJson(json["icon"]) : null,
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

  bool isValid() {
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
