import 'dart:convert';
import 'package:coffee2u/models/index.dart';

CmsPopupModel cmsPopupModelFromJson(String str) =>
  CmsPopupModel.fromJson(json.decode(str));
String cmsPopupModelToJson(CmsPopupModel model) =>
  json.encode(model.toJson());

class CmsPopupModel {
  CmsPopupModel({
    this.id,
    this.type = 'C2U',
    this.image,
    this.content,
    this.order = 1,
    this.status = 0,
    this.isExternal = 0,
    this.externalUrl,
    this.updatedAt,
    this.createdAt,
  });

  String? id;
  String type;
  FileModel? image;
  CmsContentModel? content;
  int order;
  int status;
  int isExternal;
  String? externalUrl;
  DateTime? updatedAt;
  DateTime? createdAt;

  factory CmsPopupModel.fromJson(Map<String, dynamic> json) => 
    CmsPopupModel(
      id: json["_id"],
      type: json["type"] ?? 'C2U',
      image: json["image"] == null || json["image"] is String? null: FileModel.fromJson(json["image"]),
      content: json["content"] != null && json["content"] is! String
        ? CmsContentModel.fromJson(json["content"]) 
        : null,
      order: json["order"] ?? 1,
      status: json["status"] ?? 0,
      isExternal: json["isExternal"] ?? 0,
      externalUrl: json["externalUrl"],
      updatedAt: json["updatedAt"] == null
        ? null: DateTime.parse(json["updatedAt"]),
      createdAt: json["createdAt"] == null
        ? null: DateTime.parse(json["createdAt"]),
    );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "type": type,
    "image": image?.toJson(),
    "content": content?.toJson(),
    "order": order,
    "status": status,
    "isExternal": isExternal,
    "externalUrl": externalUrl,
    "updatedAt": updatedAt?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
  };

  bool isValid() => id != null && content?.isValid() == true;
}