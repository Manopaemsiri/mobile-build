// ignore_for_file: prefer_null_aware_operators
import 'dart:convert';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:flutter/material.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:html_unescape/html_unescape.dart';

/*
  type
    0 = บุคคลธรรมดา
    1 = ห้างหุ้นส่วนจำกัด
    2 = บริษัทจำกัด

  branchType
    0 = บุคคลธรรมดา
    1 = สาขาใหญ่
    2 = สาขาย่อย
*/

CustomerBillingAddressModel customerBillingAddressModelFromJson(String str) =>
  CustomerBillingAddressModel.fromJson(json.decode(str));
String customerBillingAddressModelToJson(CustomerBillingAddressModel model) =>
  json.encode(model.toJson());

class CustomerBillingAddressModel {
  CustomerBillingAddressModel({
    this.id,
    this.customer,

    this.billingName = '',
    this.taxId = '',
    this.type = 0,
    this.branchType = 0,
    this.branchId = '',
    
    this.address = '',
    this.subdistrict,
    this.district,
    this.province,
    this.country,
    this.zipcode = '',

    this.addressText = '',
    this.telephone = '',
    this.instruction = '',

    this.isPrimary = 0,
    this.isSelected = 0,
    this.sameAsShipping = 0,
  });

  String? id;
  CustomerModel? customer;

  String billingName;
  String taxId;
  int type;
  int branchType;
  String branchId;

  String address;
  SubdistrictModel? subdistrict;
  DistrictModel? district;
  ProvinceModel? province;
  CountryModel? country;
  String zipcode;

  String addressText;
  String telephone;
  String instruction;

  int isPrimary;
  int isSelected;
  int sameAsShipping;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomerBillingAddressModel 
      && other.id == id 
      && other.customer?.id == customer?.id
      && other.billingName == billingName
      && other.taxId == taxId
      && other.type == type
      && other.branchType == branchType
      && other.branchId == branchId
      && other.address == address
      && other.subdistrict?.id == subdistrict?.id
      && other.district?.id == district?.id
      && other.province?.id == province?.id
      && other.country?.id == country?.id
      && other.zipcode == zipcode
      && other.addressText == addressText
      && other.telephone == telephone
      && other.instruction == instruction;
  }

  @override
  int get hashCode => id.hashCode ^ (customer?.id).hashCode;

  factory CustomerBillingAddressModel.fromJson(Map<String, dynamic> json){
    var unescape = HtmlUnescape();

    return CustomerBillingAddressModel(
      id: json["_id"],
      customer: json["customer"] != null && json["customer"] is! String
        ? CustomerModel.fromJson(json["customer"]) 
        : null,

      billingName: json["billingName"]==null? '': unescape.convert(json["billingName"]),
      taxId: json["taxId"] ?? '',
      type: json["type"] ?? 0,
      branchType: json["branchType"] ?? 0,
      branchId: json["branchId"] ?? '',

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

      addressText: json["addressText"]==null? '': unescape.convert(json["addressText"]),
      telephone: json["telephone"]?? '',
      instruction: json["instruction"]==null? '': unescape.convert(json["instruction"]),

      isPrimary: json["isPrimary"] ?? 0,
      isSelected: json["isSelected"] ?? 0,
      sameAsShipping: json["sameAsShipping"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "customer": customer?.toJson(),
    "billingName": billingName,
    "taxId": taxId,
    "type": type,
    "branchType": branchType,
    "branchId": branchId,
    "address": address,
    "subdistrict": subdistrict?.toJson(),
    "district": district?.toJson(),
    "province": province?.toJson(),
    "country": country?.toJson(),
    "zipcode": zipcode,
    "addressText": addressText,
    "telephone": telephone,
    "instruction": instruction,
    "isPrimary": isPrimary,
    "isSelected": isSelected,
    "sameAsShipping": sameAsShipping,
  };


  bool isValid() {
    return id != null ? true : false;
  }
  
  bool isValidAddress() {
    if(address != '' && subdistrict != null && district != null
    && province != null && zipcode != ''){
      return true;
    }else{
      return false;
    }
  }
  String displayAddress(LanguageController controller ,{withCountry=false, String sep=' '}) {
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
    String dataStr = await DefaultAssetBundle.of(context).loadString("assets/data/thai-provinces.json");
    var dataModel = List<Map<String, dynamic>>.from(jsonDecode(dataStr));
    return List<ProvinceModel>
      .from(dataModel.map((tempData) => ProvinceModel.fromJson(tempData)));
  }
  Future<List<DistrictModel>> loadDistricts() async {
    String dataStr = await DefaultAssetBundle.of(context).loadString("assets/data/thai-districts.json");
    var dataModel = List<Map<String, dynamic>>.from(jsonDecode(dataStr));
    return List<DistrictModel>
      .from(dataModel.map((tempData) => DistrictModel.fromJson(tempData)));
  }
  Future<List<SubdistrictModel>> loadSubdistricts() async {
    String dataStr = await DefaultAssetBundle.of(context).loadString("assets/data/thai-subdistricts.json");
    var dataModel = List<Map<String, dynamic>>.from(jsonDecode(dataStr));
    return List<SubdistrictModel>
      .from(dataModel.map((tempData) => SubdistrictModel.fromJson(tempData)));
  }
}