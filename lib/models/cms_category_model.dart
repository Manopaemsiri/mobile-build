import 'package:coffee2u/models/index.dart';
import 'package:html_unescape/html_unescape.dart';

class CmsCategoryModel {
  CmsCategoryModel({
    this.id,
    this.type = 'C2U',
    this.title = '',
    this.description = '',
    this.url = '',
    this.image,
    this.order = 1,
    this.status = 0,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String type;
  String title;
  String description;
  String url;
  FileModel? image;
  int order;
  int status;

  DateTime? updatedAt;
  DateTime? createdAt;

  factory CmsCategoryModel.fromJson(Map<String, dynamic> json){
    var unescape = HtmlUnescape();
    return CmsCategoryModel(
      id: json["_id"],
      type: json["type"] ?? '',
      title: json["title"]==null? '': unescape.convert(json["title"]),
      description: json["description"]==null? '': unescape.convert(json["description"]),
      url: json["url"] ?? '',
      image: json["image"] != null && json["image"] is! String
        ? FileModel.fromJson(json["image"])
        : null,
      order: json["order"] ?? 1,
      status: json["status"] ?? 0,
      updatedAt: json["updatedAt"] == null
        ? null: DateTime.parse(json["updatedAt"]),
      createdAt: json["createdAt"] == null
        ? null: DateTime.parse(json["createdAt"]),
    );
  }
  
  Map<String, dynamic> toJson() => {
    "_id": id,
    "type": type,
    "title": title,
    "description": description,
    "url": url,
    "image": image == null? null: image!.toJson(),
    "order": order,
    "status": status,
    "updatedAt": updatedAt == null? null: updatedAt!.toIso8601String(),
    "createdAt": createdAt == null? null: createdAt!.toIso8601String(),
  };
}
