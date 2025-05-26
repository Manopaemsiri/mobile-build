import 'dart:convert';
import 'package:coffee2u/models/index.dart';

CmsBannerModel cmsBannerModelFromJson(String str) =>
  CmsBannerModel.fromJson(json.decode(str));
String cmsBannerModelToJson(CmsBannerModel model) =>
  json.encode(model.toJson());

class CmsBannerModel {
  CmsBannerModel({
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

  factory CmsBannerModel.fromJson(Map<String, dynamic> json) => 
    CmsBannerModel(
      id: json["_id"],
      type: json["type"] ?? 'C2U',
      image: json["image"] != null && json["image"] is! String
        ? FileModel.fromJson(json["image"])
        : null,
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
    "updatedAt": updatedAt == null
      ? null: updatedAt!.toIso8601String(),
    "createdAt": createdAt == null
      ? null: createdAt!.toIso8601String(),
  };
}