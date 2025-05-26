import 'dart:convert';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:html_unescape/html_unescape.dart';

PartnerEventModel partnerEventModelFromJson(String str) =>
  PartnerEventModel.fromJson(json.decode(str));
String partnerEventModelToJson(PartnerEventModel model) =>
  json.encode(model.toJson());

class PartnerEventModel {
  PartnerEventModel({
    this.id,
    this.name = '',
    this.description = '',
    this.url = '',
    this.image,
    this.icon,
    
    this.startAt,
    this.endAt,

    this.order = 1,
    this.status = 0,
  });

  final String? id;
  final String name;
  final String description;
  final String url;
  FileModel? image;
  FileModel? icon;
  
  DateTime? startAt;
  DateTime? endAt;

  final int order;
  final int status;

  factory PartnerEventModel.fromJson(Map<String, dynamic> json){
    var unescape = HtmlUnescape();
    return PartnerEventModel(
      id: json["_id"],
      name: json["name"]==null? '': unescape.convert(json["name"]),
      description: json["description"]==null? '': unescape.convert(json["description"]),
      url: json["url"] ?? '',
      image: json["image"] == null || json["image"] is String
        ? null: FileModel.fromJson(json["image"]),
      icon: json["icon"] == null || json["icon"] is String
        ? null: FileModel.fromJson(json["icon"]),
        
      startAt: json["startAt"] == null
        ? null: DateTime.parse(json["startAt"]),
      endAt: json["endAt"] == null
        ? null: DateTime.parse(json["endAt"]),

      order: json["order"] ?? 1,
      status: json["status"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "description": description,
    "url": url,
    "image": image == null? null: image!.toJson(),
    "icon": icon == null? null: icon!.toJson(),
    
    "startAt": startAt == null? null: startAt!.toIso8601String(),
    "endAt": endAt == null? null: endAt!.toIso8601String(),
    
    "order": order,
    "status": status,
  };

  bool isValid() {
    if(startAt == null || endAt == null) return false;
    final isBetween = DateTime.now().isBetween(startAt!, endAt!) ?? false;
    return id != null && status == 1 && isBetween? true : false;
  }
}
