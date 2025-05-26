import 'dart:convert';
import 'package:coffee2u/models/index.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';

/*
  type : Number
    1 = Default
    2 = Use Text
    3 = Use Icon
*/

PartnerProductStatusModel partnerProductStatusModelFromJson(String str) =>
  PartnerProductStatusModel.fromJson(json.decode(str));
String partnerProductStatusModelToJson(PartnerProductStatusModel model) =>
  json.encode(model.toJson());

class PartnerProductStatusModel {
  PartnerProductStatusModel({
    this.id,
    this.productStatus = 0,
    this.type = 1,
    this.name = '',
    this.text = '',
    this.textColor = '',
    this.textBgColor = '',
    this.textColor2,
    this.textBgColor2,
    this.icon,
  });

  final String? id;
  final int productStatus;
  final int type;
  final String name;
  final String text;
  final String textColor;
  final String textBgColor;
  final Color? textColor2;
  final Color? textBgColor2;
  FileModel? icon;

  factory PartnerProductStatusModel.fromJson(Map<String, dynamic> json){
    var unescape = HtmlUnescape();
    return PartnerProductStatusModel(
      id: json["_id"],
      productStatus: json["productStatus"] ?? 0,
      type: json["type"] ?? 0,
      name: json["name"] == null? '': unescape.convert(json["name"]),
      text: json["text"] == null? '': unescape.convert(json["text"]),
      textColor: json["textColor"] == null? '': unescape.convert(json["textColor"]),
      textBgColor: json["textBgColor"] == null? '': unescape.convert(json["textBgColor"]),

      textColor2: json["textColor"] == null? null: Color(int.parse(unescape.convert(json["textColor"]).replaceAll('#', '0xFF'))),
      textBgColor2: json["textBgColor"] == null? null: Color(int.parse(unescape.convert(json["textBgColor"]).replaceAll('#', '0xFF'))),

      icon: json["icon"] != null && json["icon"] is! String? FileModel.fromJson(json["icon"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "productStatus": productStatus,
    "type": type,
    "name": name,
    "text": text,
    "textColor": textColor,
    "textBgColor": textBgColor,

    "textColor2": textColor2,
    "textBgColor2": textBgColor2,

    "icon": icon == null ? null : icon!.toJson(),
  };

  bool isValid() {
    return id != null ? true : false;
  }
}
