// ignore_for_file: prefer_null_aware_operators
import 'dart:convert';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/models/index.dart';
import 'package:html_unescape/html_unescape.dart';

CustomerShippingAddressModel customerShippingAddressModelFromJson(String str) =>
  CustomerShippingAddressModel.fromJson(json.decode(str));
String customerShippingAddressModelToJson(CustomerShippingAddressModel model) => 
  json.encode(model.toJson());

class CustomerShippingAddressModel {
  CustomerShippingAddressModel({
    this.id,
    this.customer,

    this.shippingFirstname = '',
    this.shippingLastname = '',

    this.address = '',
    this.subdistrict,
    this.district,
    this.province,
    this.country,
    this.zipcode = '',

    this.lat,
    this.lng,

    this.addressText = '',
    this.telephone = '',
    this.instruction = '',

    this.isPrimary = 0,
    this.isSelected = 0,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomerShippingAddressModel 
      && other.id == id 
      && other.customer?.id == customer?.id
      && other.shippingFirstname == shippingFirstname
      && other.shippingLastname == shippingLastname
      && other.address == address
      && other.subdistrict?.id == subdistrict?.id
      && other.district?.id == district?.id
      && other.province?.id == province?.id
      && other.country?.id == country?.id
      && other.zipcode == zipcode
      && other.lat == lat
      && other.lng == lng
      && other.addressText == addressText
      && other.telephone == telephone
      && other.instruction == instruction;
  }

  @override
  int get hashCode => id.hashCode ^ (customer?.id).hashCode;

  String? id;
  CustomerModel? customer;

  String shippingFirstname;
  String shippingLastname;

  String address;
  SubdistrictModel? subdistrict;
  DistrictModel? district;
  ProvinceModel? province;
  CountryModel? country;
  String zipcode;

  double? lat;
  double? lng;

  String addressText;
  String telephone;
  String instruction;

  int isPrimary;
  int isSelected;

  factory CustomerShippingAddressModel.fromJson(Map<String, dynamic> json){
    var unescape = HtmlUnescape();
    return CustomerShippingAddressModel(
      id: json["_id"],
      shippingFirstname: json["shippingFirstname"]==null
        ? '': unescape.convert(json["shippingFirstname"]),
      shippingLastname: json["shippingLastname"]==null
        ? '': unescape.convert(json["shippingLastname"]),
      customer: json["customer"] != null && json["customer"] is! String
        ? CustomerModel.fromJson(json["customer"]) 
        : null,
        
      address: json["address"]==null? '': unescape.convert(json["address"]),
      subdistrict: json["subdistrict"] != null && json["subdistrict"] is! String
        ? SubdistrictModel.fromJson(json["subdistrict"]) 
        : null,
      district: json["district"] != null && json["district"] is! String
        ? DistrictModel.fromJson(json["district"]) 
        : null,
      province: json["province"] != null && json["province"] is! String
        ? ProvinceModel.fromJson(json["province"]) 
        : null,
      country: json["country"] != null && json["country"] is! String
        ? CountryModel.fromJson(json["country"]) 
        : null,
      zipcode: json["zipcode"] ?? '',
      lat: json["lat"],
      lng: json["lng"],
      
      addressText: json["addressText"]==null? '': unescape.convert(json["addressText"]),
      telephone: json["telephone"] ?? '',
      instruction: json["instruction"]==null? '': unescape.convert(json["instruction"]),

      isPrimary: json["isPrimary"] ?? 0,
      isSelected: json["isSelected"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "shippingFirstname": shippingFirstname,
    "shippingLastname": shippingLastname,
    "customer": customer?.toJson(),
    "address": address,
    "subdistrict": subdistrict?.toJson(),
    "district": district?.toJson(),
    "province": province?.toJson(),
    "country": country?.toJson(),
    "zipcode": zipcode,
    "lat": lat,
    "lng": lng,
    "addressText": addressText,
    "telephone": telephone,
    "instruction": instruction,
    "isPrimary": isPrimary,
    "isSelected": isSelected,
  };


  bool isValid() {
    return id != null ? true : false;
  }
  
  bool isValidAddress() {
    if(subdistrict?.name != '' && district?.name != '' 
    && province?.name != '' && zipcode != ''){
      return true;
    }else{
      return false;
    }
  }
  String displayAddress(LanguageController controller, {bool withCountry=false, String sep=' '}) {
    if(isValidAddress()){
      if(withCountry){
        return address
          +sep+prefixSubdistrict(controller)+(subdistrict?.name ?? '-')
          +' '+prefixDistrict(controller)+(district?.name ?? '-')
          +sep+controller.getLang('Province')+(province?.name ?? '-')
          +' '+controller.getLang("Country")+(country?.name ?? '-')
          +' '+zipcode;
      }else{
        return address
          +sep+prefixSubdistrict(controller)+(subdistrict?.name ?? '-')
          +' '+prefixDistrict(controller)+(district?.name ?? '-')
          +sep+controller.getLang('Province')+(province?.name ?? '-')
          +' '+zipcode;
      }
    }else{
      return '';
    }
  }

  String prefixSubdistrict(LanguageController controller) {
    if (province?.name == '') {
      return controller.getLang('subdistrict');
    } else if (province?.name.contains('กรุงเทพ') == true) {
      return controller.getLang('subdistrict_1');
    } else {
      return controller.getLang('subdistrict_2');
    }
  }
  String prefixDistrict(LanguageController controller) {
    if (province?.name == '') {
      return controller.getLang('district');
    } else if (province?.name.contains('กรุงเทพ') == true) {
      return controller.getLang('district_1');
    } else {
      return controller.getLang('district_2');
    }
  }

  bool isSelectedToggle() {
    if (isPrimary == 1) {
      return true;
    } else {
      return false;
    }
  }


  Future<List<ProvinceModel>> loadProvinces() async {
    String _dataStr = await DefaultAssetBundle.of(context).loadString("assets/data/thai-provinces.json");
    var _data = List<Map<String, dynamic>>.from(jsonDecode(_dataStr));
    return List<ProvinceModel>
      .from(_data.map((_d) => ProvinceModel.fromJson(_d)));
  }
  Future<List<DistrictModel>> loadDistricts() async {
    String _dataStr = await DefaultAssetBundle.of(context).loadString("assets/data/thai-districts.json");
    var _data = List<Map<String, dynamic>>.from(jsonDecode(_dataStr));
    return List<DistrictModel>
      .from(_data.map((_d) => DistrictModel.fromJson(_d)));
  }
  Future<List<SubdistrictModel>> loadSubdistricts() async {
    String _dataStr = await DefaultAssetBundle.of(context).loadString("assets/data/thai-subdistricts.json");
    var _data = List<Map<String, dynamic>>.from(jsonDecode(_dataStr));
    return List<SubdistrictModel>
      .from(_data.map((_d) => SubdistrictModel.fromJson(_d)));
  }

  
  
}