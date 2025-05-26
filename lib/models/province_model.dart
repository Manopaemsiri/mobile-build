import 'dart:convert';

import 'package:coffee2u/controller/language_controller.dart';

ProvinceModel provinceModelFromJson(String str) =>
  ProvinceModel.fromJson(json.decode(str));
String provinceModelToJson(ProvinceModel model) => 
  json.encode(model.toJson());

class ProvinceModel {
  ProvinceModel({
    this.id = '',
    this.countryId = '',
    this.name = '',
    this.lat,
    this.lng ,

  });
  String id;
  String countryId;
  String name;
  double? lat;
  double? lng;

  factory ProvinceModel.fromJson(Map<String, dynamic> json) => ProvinceModel(
    id: json['_id'] ?? '',
    countryId: json['countryId'] ?? '',
    name: json['name'] ?? '',
    lat: json["lat"] == null || json["lat"] == "\\N"
      ? null: double.parse(json["lat"].toString()),
    lng: json["lng"] == null || json["lng"] == "\\N"
      ? null: double.parse(json["lat"].toString()),
  );
  
  Map<String, dynamic> toJson() => {
    '_id': id,
    'countryId': countryId,
    'name': name,
    'lat': lat,
    'lng': lng,
  };

  bool isValid() {
    return id != ''? true: false;
  }

  String prefixDistrict(LanguageController controller) {
    if (name == '') {
      return controller.getLang('district');
    } else if (name.contains('กรุงเทพ') == true) {
      return controller.getLang('district_1');
    } else {
      return controller.getLang('district_2');
    }
  }
   String prefixSubdistrict(LanguageController controller) {
    if (name == '') {
      return controller.getLang('subdistrict');
    } else if (name.contains('กรุงเทพ') == true) {
      return controller.getLang('subdistrict_1');
    } else {
      return controller.getLang('subdistrict_2');
    }
  }
}