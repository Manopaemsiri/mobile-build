import 'dart:convert';
import 'package:coffee2u/models/index.dart';
import 'package:html_unescape/html_unescape.dart';

/*
  type :
    1 = จัดส่งโดยส่วนกลาง
    2 = Click & Collect
    3 = Delivery by 3rd Party
      subtype :
        1 = Grab
        2 = Kerry Express
    4 = By Appointment
*/

PartnerShippingModel partnerShippingModelFromJson(String str) =>
  PartnerShippingModel.fromJson(json.decode(str));
String partnerShippingModelToJson(PartnerShippingModel model) =>
  json.encode(model.toJson());

class PartnerShippingModel {
  PartnerShippingModel({
    this.id,

    this.name = '',
    this.displayName = '',
    this.description = '',
    this.icon,

    this.minimumOrder,
    this.maximumOrder,

    this.type = 0,
    this.subtype = 0,
    this.lfWeightFactor = 0,

    this.kerryMaximumOrder,
    this.kerryEnableCOD = 0,
    this.kerryMaximumCOD,

    this.packingDays = const [],
    this.forAllProvinces = 0,
    this.forProvinces = const [],

    this.order = 1,
    this.status = 0,
  });

  String? id;

  String name;
  String displayName;
  String description;
  FileModel? icon;

  double? minimumOrder;
  double? maximumOrder;

  int type;
  int subtype;
  double lfWeightFactor;

  double? kerryMaximumOrder;
  int kerryEnableCOD;
  double? kerryMaximumCOD;

  List<PackingDayModel> packingDays;

  int forAllProvinces;
  List<ProvinceModel> forProvinces;

  int order;
  int status;

  factory PartnerShippingModel.fromJson(Map<String, dynamic> json){
    var unescape = HtmlUnescape();
    return PartnerShippingModel(
      id: json["_id"],

      name: json["name"]==null? '': unescape.convert(json["name"]),
      displayName: json["displayName"]==null? '': unescape.convert(json["displayName"]),
      description: json["description"]==null? '': unescape.convert(json["description"]),
      
      icon: json["icon"] == null || json["icon"] is String? null: FileModel.fromJson(json["icon"]),

      minimumOrder: json["minimumOrder"] == null
        ? null: double.parse(json["minimumOrder"].toString()),
      maximumOrder: json["maximumOrder"] == null
        ? null: double.parse(json["maximumOrder"].toString()),

      type: json["type"] ?? 0,
      subtype: json["subtype"] ?? 0,
      lfWeightFactor: json["lfWeightFactor"] == null
        ? 0: double.parse(json["lfWeightFactor"].toString()),

      kerryMaximumOrder: json["kerryMaximumOrder"] == null
        ? null: double.parse(json["kerryMaximumOrder"].toString()),
      kerryEnableCOD: json["kerryEnableCOD"] ?? 0,
      kerryMaximumCOD: json["kerryMaximumCOD"] == null
        ? null: double.parse(json["kerryMaximumCOD"].toString()),

      packingDays: json["packingDays"] == null? []
        : List<PackingDayModel>.from(json["packingDays"]
          .where((e) => e is! String)
          .map((e) => PackingDayModel.fromJson(e))),

      forAllProvinces: json["forAllProvinces"] ?? 0,
      forProvinces: json['forProvinces'] == null || json['forProvinces'] is String? []
        : List<ProvinceModel>.from(json['forProvinces']
          .where((e) => e is! String)
          .map((e) => ProvinceModel.fromJson(e))),
        
      order: json["order"] ?? 1,
      status: json["status"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "displayName": displayName,
    "description": description,
    "icon": icon?.toJson(),
    "minimumOrder": minimumOrder,
    "maximumOrder": maximumOrder,
    "type": type,
    "subtype": subtype,
    "lfWeightFactor": lfWeightFactor,
    "kerryMaximumOrder": kerryMaximumOrder,
    "kerryEnableCOD": kerryEnableCOD,
    "kerryMaximumCOD": kerryMaximumCOD,
    "packingDays": List<PackingDayModel>
      .from(packingDays.map((e) => e.toJson())),
    "forAllProvinces": forAllProvinces,
    'forProvinces': forProvinces.isEmpty? []: forProvinces.map((e) => e.toJson()).toList(),
    "order": order,
    "status": status,
  };
}