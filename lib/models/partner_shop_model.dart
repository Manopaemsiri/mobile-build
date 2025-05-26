import 'dart:convert';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';

/*
  type :
    1 = Center
    2 = CoCo
    3 = Dealer
    9 = External

  status :
    0 = ปิดใช้งาน
    1 = เปิดใช้งาน

  workingHours : Array
    workingHour : Object
      dayIndex :
        0 = วันอาทิตย์
        1 = วันจันทร์
        2 = วันอังคาร
        3 = วันพุธ
        4 = วันพฤหัสบดี
        5 = วันศุกร์
        6 = วันเสาร์
      isOpened : Number
        1 = เปิดทำการ
        0 = ปิดทำการ
      startTime
      endTime
*/

PartnerShopModel partnerShopModelFromJson(String str) =>
  PartnerShopModel.fromJson(json.decode(str));
String partnerShopModelToJson(PartnerShopModel model) =>
  json.encode(model.toJson());

class PartnerShopModel {
  PartnerShopModel({
    this.id,
    this.code,
    this.erpCode,
    this.erpEmployeeCode,
    this.name,
    this.nameEN,
    this.description,
    this.type,
    this.url,
    this.image,
    this.gallery,
    this.email,
    this.address,
    this.telephones,
    this.line,
    this.facebook,
    this.instagram,
    this.website,
    this.workingHours,
    this.availableShippingTypes = const [],
    this.status,
    this.distance,
  });

  String? id;

  String? code;
  String? erpCode;
  String? erpEmployeeCode;

  String? name;
  String? nameEN;
  String? description;

  int? type;
  String? url;

  FileModel? image;
  List<FileModel>? gallery;

  String? email;
  CustomerShippingAddressModel? address;

  List<String>? telephones;
  String? line;
  String? facebook;
  String? instagram;
  String? website;

  List<WorkingHourModel>? workingHours;

  List<int> availableShippingTypes;

  int? status;

  double? distance;

  factory PartnerShopModel.fromJson(Map<String, dynamic> json){
    var unescape = HtmlUnescape();
    return PartnerShopModel(
      id: json["_id"],
      code: json["code"] ?? '',
      erpCode: json["erpCode"] ?? '',
      erpEmployeeCode: json["erpEmployeeCode"] ?? '',
      
      name: json["name"]==null? '': unescape.convert(json["name"]),
      nameEN: json["nameEN"]==null? '': unescape.convert(json["nameEN"]),
      description: json["description"]==null? '': unescape.convert(json["description"]),
      
      type: json["type"] ?? 0,
      url: json["url"] ?? '',
      
      image: json["image"] == null || json["image"] is String
        ? null: FileModel.fromJson(json["image"]),
      gallery: json["gallery"] == null || json["gallery"] is String? null
        : List<FileModel>.from(json["gallery"]
          .where((e) => e is! String)
          .map((e) => FileModel.fromJson(e))),
      
      email: json["email"],
      address: json["address"] != null && json["address"] is! String
        ? CustomerShippingAddressModel.fromJson(json["address"]) 
        : null,
      telephones: json["telephones"] == null || json["telephones"] is String
        ? null: List<String>.from(json["telephones"].map((x) => x)),
      line: json["line"] ?? '',
      facebook: json["facebook"] ?? '',
      instagram: json["instagram"] ?? '',
      website: json["website"] ?? '',
      
      workingHours: json["workingHours"] != null && json["workingHours"] is! String
        ? List<WorkingHourModel>.from(
          json["workingHours"].map((x) => WorkingHourModel.fromJson(x)))
        : [],
      
      availableShippingTypes: json["availableShippingTypes"] != null && json["availableShippingTypes"] is List
        ? List<int>.from(json["availableShippingTypes"].map((e) => e)).toList()
        : [],

      status: json["status"],
      distance: json["distance"] == null || json["distance"] == 999999
        ? null: double.parse(json["distance"].toStringAsFixed(1)),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "code": code,
    "erpCode": erpCode,
    "erpEmployeeCode": erpEmployeeCode,
    "name": name,
    "nameEN": nameEN,
    "description": description,
    "type": type,
    "url": url,
    "image": image == null ? null : image!.toJson(),
    "gallery": gallery == null? null
      : List<Map<String, dynamic>>
        .from(gallery!.map((x) => x.toJson())),
    "email": email,
    "address": address == null ? null : address!.toJson(),
    "telephones": telephones == null
      ? null: List<String>.from(telephones!.map((e) => e)),
    "line": line,
    "facebook": facebook,
    "instagram": instagram,
    "website": website,
    "workingHours": workingHours == null? null
      : List<Map<String, dynamic>>
        .from(workingHours!.map((x) => x.toJson())),
    "availableShippingTypes": availableShippingTypes.isNotEmpty == true? availableShippingTypes: [],

    "status": status,
    "distance": distance,
  };

  bool isValid() {
    return id != null? true: false;
  }

  bool isOpen() {
    if (workingHours == null || workingHours!.isEmpty) {
      return false;
    } else {
      DateTime _now = DateTime.now();
      int index = workingHours!.indexWhere((x) => x.dayIndex == _now.weekday % 7 && x.isOpened == 1);
      if (index < 0) {
        return false;
      } else {
        WorkingHourModel wh = workingHours![index];
        String startH = wh.startTime!.substring(0, 2);
        String startM = wh.startTime!.substring(3, 5);
        String endH = wh.endTime!.substring(0, 2);
        String endM = wh.endTime!.substring(3, 5);

        TimeOfDay startTime = TimeOfDay(hour: int.parse(startH), minute: int.parse(startM));
        TimeOfDay endTime = TimeOfDay(hour: int.parse(endH), minute: int.parse(endM));

        return ((_now.hour > startTime.hour) ||
                (_now.hour == startTime.hour &&
                  _now.minute >= startTime.minute)) &&
            ((_now.hour < endTime.hour) ||
              (_now.hour == endTime.hour && _now.minute <= endTime.minute));
      }
    }
  }

  String todayOpenRange() {
    if (workingHours == null || workingHours!.isEmpty) {
      return '';
    } else {
      DateTime _now = DateTime.now();
      int index = workingHours!.indexWhere((x) => x.dayIndex == _now.weekday % 7 && x.isOpened == 1);
      if (index < 0) {
        return '';
      } else {
        WorkingHourModel wh = workingHours![index];
        return '${wh.startTime} - ${wh.endTime}';
      }
    }
  }

  Widget displayIsOpen(TextStyle textStyle, LanguageController lController){
    var title = 'CLOSED';
    var color = kRedColor;
    if (isOpen()) {
      title = 'OPEN';
      color = kGreenColor;
    }
    return Text(
      lController.getLang(title),
      style: textStyle.copyWith(color: color, fontWeight: FontWeight.w500),
    );
  }

  bool isOpenClickAndCollect() =>
    availableShippingTypes.contains(2);
}