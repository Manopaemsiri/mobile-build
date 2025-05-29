import 'dart:convert';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';

/*
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

  priceRange :
    0 = 
    1 = ฿ = ต่ำกว่า 100 บาท
    2 = ฿฿ = 100-150 บาท
    3 = ฿฿฿ = 150-200 บาท
    4 = ฿฿฿฿ = มากกว่า 200 บาท
*/

SellerShopModel sellerShopModelFromJson(String str) =>
  SellerShopModel.fromJson(json.decode(str));
String sellerShopModelToJson(SellerShopModel model) =>
  json.encode(model.toJson());

class SellerShopModel {
  SellerShopModel({
    this.id,
    this.type,
    this.code = '',
    this.businessId = '',

    this.name = '',
    this.description = '',
    this.url = '',
    this.youtubeVideoId = '',
    
    this.logo,
    this.image,
    this.gallery,

    this.email = '',
    this.address,
    this.telephones = const [],
    this.line = '',
    this.facebook = '',
    this.instagram = '',
    this.website = '',
    this.workingHours,

    this.averageRating,
    this.status = 0,

    this.capacity = '',
    this.priceRange = 0,
    this.hasParkingSpace = 0,
    this.hasWifi = 0,
    this.acceptCreditCards = 0,
    this.hasDelivery = 0,
    this.isAromaShopMember = 0,

    this.nameEN = '',
    this.descriptionEN = '',

    this.distance,
  });

  String? id;
  SellerShopTypeModel? type;
  String code;
  String businessId;

  String name;
  String description;
  String? url;
  String youtubeVideoId;

  FileModel? logo;
  FileModel? image;
  List<FileModel>? gallery;

  String email;
  CustomerShippingAddressModel? address;
  List<String> telephones;
  String line;
  String facebook;
  String instagram;
  String website;
  List<WorkingHourModel>? workingHours;

  double? averageRating;
  int status;
  
  String capacity;
  int priceRange;
  int hasParkingSpace;
  int hasWifi;
  int acceptCreditCards;
  int hasDelivery;
  int isAromaShopMember;

  String nameEN;
  String descriptionEN;

  double? distance;

  factory SellerShopModel.fromJson(Map<String, dynamic> json){
    var unescape = HtmlUnescape();
    return SellerShopModel(
      id: json["_id"],
      type: json["type"] != null && json["type"] is! String
        ? SellerShopTypeModel.fromJson(json["type"]) 
        : null,
      code: json["code"] ?? '',
      businessId: json["businessId"] ?? '',

      name: json["name"]==null? '': unescape.convert(json["name"]),
      description: json["description"]==null? '': unescape.convert(json["description"]),
      
      url: json["url"] ?? '',
      youtubeVideoId: json["youtubeVideoId"] ?? '',

      logo: json["logo"] == null || json["logo"] is String? null: FileModel.fromJson(json["logo"]),
      image: json["image"] == null || json["image"] is String? null: FileModel.fromJson(json["image"]),
      gallery: json["gallery"] == null || json["gallery"] is String? null
        : List<FileModel>.from(json["gallery"]
          .where((e) => e is! String)
          .map((e) => FileModel.fromJson(e))),

      email: json["email"] ?? '',
      address: json["address"] != null && json["address"] is! String
        ? CustomerShippingAddressModel.fromJson(json["address"]) 
        : null,
      telephones: json["telephones"] == null || json["telephones"] is String? []
        : List<String>.from(json["telephones"].map((x) => x)),
      line: json["line"] ?? '',
      facebook: json["facebook"] ?? '',
      instagram: json["instagram"] ?? '',
      website: json["website"] ?? '',
      workingHours: json["workingHours"] != null && json["workingHours"] is! String
        ? List<WorkingHourModel>.from(json["workingHours"]
          .where((e) => e is! String)
          .map((x) => WorkingHourModel.fromJson(x))) 
        : [],

      averageRating: json["averageRating"] == null
        ? null: double.parse(json["averageRating"].toString()),
      status: json["status"] ?? 0,

      capacity: json["capacity"] ?? '',
      priceRange: json["priceRange"] ?? 0,
      hasParkingSpace: json["hasParkingSpace"] ?? 0,
      hasWifi: json["hasWifi"] ?? 0,
      acceptCreditCards: json["acceptCreditCards"] ?? 0,
      hasDelivery: json["hasDelivery"] ?? 0,
      isAromaShopMember: json["isAromaShopMember"] ?? 0,

      nameEN: json["nameEN"]==null? '': unescape.convert(json["nameEN"]),
      descriptionEN: json["descriptionEN"]==null? '': unescape.convert(json["descriptionEN"]),

      distance: json["distance"] == null || json["distance"] == 999999
        ? null: double.parse(json["distance"].toStringAsFixed(1)),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "type": type?.toJson(),
    "code": code,
    "businessId": businessId,

    "name": name,
    "description": description,
    "url": url,
    "youtubeVideoId": youtubeVideoId,

    "logo": logo?.toJson(),
    "image": image?.toJson(),
    "gallery": gallery == null? null
      : List<Map<String, dynamic>>.from(gallery!.map((x) => x.toJson())),

    "email": email,
    "address": address?.toJson(),
    "telephones": telephones,
    "line": line,
    "facebook": facebook,
    "instagram": instagram,
    "website": website,
    "workingHours": workingHours == null? null
      : List<Map<String, dynamic>>.from(workingHours!.map((x) => x.toJson())),

    "averageRating": averageRating,
    "status": status,
    
    "capacity": capacity,
    "priceRange": priceRange,
    "hasParkingSpace": hasParkingSpace,
    "hasWifi": hasWifi,
    "acceptCreditCards": acceptCreditCards,
    "hasDelivery": hasDelivery,
    "isAromaShopMember": isAromaShopMember,

    "nameEN": nameEN,
    "descriptionEN": descriptionEN,

    "distance": distance,
  };

  bool isValid() {
    return id != null? true: false;
  }

  bool isOpen() {
    if (workingHours == null || workingHours!.isEmpty) {
      return false;
    } else {
      DateTime now = DateTime.now();
      int index = workingHours!.indexWhere((x) => x.dayIndex == now.weekday % 7 && x.isOpened == 1);
      if (index < 0) {
        return false;
      } else {
        WorkingHourModel wh = workingHours![index];
        if(wh.startTime?.length != 5 || wh.endTime?.length != 5){
          return false;
        }else{
          String startH = wh.startTime!.substring(0, 2);
          String startM = wh.startTime!.substring(3, 5);
          String endH = wh.endTime!.substring(0, 2);
          String endM = wh.endTime!.substring(3, 5);

          TimeOfDay startTime = TimeOfDay(hour: int.parse(startH), minute: int.parse(startM));
          TimeOfDay endTime = TimeOfDay(hour: int.parse(endH), minute: int.parse(endM));

          return ((now.hour > startTime.hour) ||
                (now.hour == startTime.hour &&
                  now.minute >= startTime.minute)) &&
            ((now.hour < endTime.hour) ||
              (now.hour == endTime.hour && now.minute <= endTime.minute));
        }
      }
    }
  }

  String todayOpenRange() {
    if (workingHours == null || workingHours!.isEmpty) {
      return '';
    } else {
      DateTime now = DateTime.now();
      int index = workingHours!.indexWhere((x) => x.dayIndex == now.weekday % 7 && x.isOpened == 1);
      if (index < 0) {
        return '';
      } else {
        WorkingHourModel wh = workingHours![index];
        return '${wh.startTime} - ${wh.endTime}';
      }
    }
  }

  Widget displayIsOpen(TextStyle textStyle) {
    var title = 'CLOSED';
    var color = kRedColor;
    if (isOpen()) {
      title = 'OPEN';
      color = kGreenColor;
    }
    return Text(
      title,
      style: textStyle.copyWith(color: color, fontWeight: FontWeight.w500),
    );
  }

  String displayPriceRange(LanguageController controller) {
    final symbol = controller.usedCurrency?.unit ?? controller.defaultCurrency?.unit ?? 'THB';

    if(isValid()){
      if(priceRange == 1){
        return '${controller.getLang("less than")} 100 $symbol';
      }else if(priceRange == 2){
        return '100-150 $symbol';
      }else if(priceRange == 3){
        return '150-200 $symbol';
      }else if(priceRange == 4){
        return '${controller.getLang("more than")} 200 $symbol';
      }else{
        return '';
      }
    }else{
      return '';
    }
  }
}
