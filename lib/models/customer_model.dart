import 'dart:convert';
import 'package:coffee2u/models/index.dart';

/*
  type : String
    - C2U
    - Store
    
  status :
    -1 = ขอลบบัญชี
    0  = ปิดใช้งาน
    1  = เปิดใช้งาน

  gender :
    0 = ไม่ระบุ
    1 = ชาย
    2 = หญิง
    3 = อื่นๆ
*/

CustomerModel customerModelFromJson(String str) => CustomerModel.fromJson(json.decode(str));
String customerModelToJson(CustomerModel model) => json.encode(model.toJson());

class CustomerModel {
  CustomerModel({
    this.id,
    this.type,
    this.channel,
    this.group,
    this.groupTier,
    this.tier,
    this.partnerShop,
    this.salesManager,
    this.code,
    this.erpCode,
    this.posCode,
    this.firstname,
    this.lastname,
    this.username,
    this.email,
    this.avatar,
    this.apple,
    this.facebook,
    this.google,
    this.line,
    this.points,
    this.telephone,
    this.fcmToken,
    this.accessToken,
    this.refreshToken,
    this.nickname,
    this.socialId,
    this.birthDate,
    this.gender,
    this.isConsent = 0,
    this.consentDate,
    this.isPrivacy = 0,
    this.privacyDate,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.isGuest,
    this.pointExpirationDate,
    this.pointResetDate,
  });
  String? id;

  String? type;
  String? channel;

  CustomerGroupModel? group;
  CustomerGroupTierModel? groupTier;
  CustomerTierModel? tier;
  PartnerShopModel? partnerShop;
  UserModel? salesManager;

  String? code;
  String? erpCode;
  String? posCode;

  String? firstname;
  String? lastname;
  String? username;
  String? email;
  FileModel? avatar;

  String? apple;
  String? facebook;
  String? google;
  String? line;

  int? points;

  String? telephone;

  String? fcmToken;
  String? accessToken;
  String? refreshToken;

  // START: Detail
  String? nickname;
  String? socialId;
  DateTime? birthDate;
  int? gender;

  int isConsent;
  DateTime? consentDate;
  int isPrivacy;
  DateTime? privacyDate;
  // END: Detail
  
  int? isGuest;
  DateTime? pointExpirationDate;
  DateTime? pointResetDate;

  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json["_id"],
      type: json["type"] ?? 'C2U',
      channel: json["channel"] ?? 'C2U',
      group: json["group"] != null && json["group"] is! String
        ? CustomerGroupModel.fromJson(json["group"]) 
        : null,
      groupTier: json["groupTier"] != null && json["groupTier"] is! String
        ? CustomerGroupTierModel.fromJson(json["groupTier"]) 
        : null,
      tier: json["tier"] != null && json["tier"] is! String
        ? CustomerTierModel.fromJson(json["tier"]) 
        : null,
      partnerShop: json["partnerShop"] != null && json["partnerShop"] is! String
        ? PartnerShopModel.fromJson(json["partnerShop"]) 
        : null,
      salesManager: json["salesManager"] != null && json["salesManager"] is! String
        ? UserModel.fromJson(json["salesManager"]) 
        : null,
      code: json["code"],
      erpCode: json["erpCode"],
      posCode: json["posCode"],
      firstname: json["firstname"] ?? '',
      lastname: json["lastname"] ?? '',
      username: json["username"] ?? '',
      email: json["email"] ?? '',
      avatar: json["avatar"] == null || json["avatar"] is String
        ? null: FileModel.fromJson(json["avatar"]),
      apple: json["apple"],
      facebook: json["facebook"],
      google: json["google"],
      line: json["line"],
      points: json["points"],
      telephone: json["telephone"],

      fcmToken: json["fcmToken"],
      accessToken: json["accessToken"],
      refreshToken: json["refreshToken"],

      nickname: json["nickname"],
      socialId: json["socialId"],
      birthDate: json["birthDate"] == null
        ? null: DateTime.parse(json["birthDate"]),
      gender: json["gender"],
      isConsent: json["isConsent"] ?? 0,
      consentDate: json["consentDate"] == null
        ? null: DateTime.parse(json["consentDate"]),
      isPrivacy: json["isPrivacy"] ?? 0,
      privacyDate: json["privacyDate"] == null
        ? null: DateTime.parse(json["privacyDate"]),

      isGuest: json["isGuest"],
      pointExpirationDate: json["pointExpirationDate"] == null
        ? null: DateTime.parse(json["pointExpirationDate"]),
      pointResetDate: json["pointResetDate"] == null
        ? null: DateTime.parse(json["pointResetDate"]),

      status: json["status"],
      createdAt: json["createdAt"] == null
        ? null: DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null
        ? null: DateTime.parse(json["updatedAt"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "type": type,
    "channel": channel,
    "group": group?.toJson(),
    "groupTier": groupTier?.toJson(),
    "tier": tier?.toJson(),
    "partnerShop": partnerShop?.toJson(),
    "salesManager": salesManager?.toJson(),
    "code": code,
    "erpCode": erpCode,
    "posCode": posCode,
    "firstname": firstname,
    "lastname": lastname,
    "username": username,
    "email": email,
    "avatar": avatar?.toJson(),
    "apple": apple,
    "facebook": facebook,
    "google": google,
    "line": line,
    "points": points,
    "telephone": telephone,
    "fcmToken": fcmToken,
    "accessToken": accessToken,
    "refreshToken": refreshToken,
    "nickname": nickname,
    "socialId": socialId,
    "birthDate": birthDate?.toIso8601String(),
    "gender": gender,
    "isConsent": isConsent,
    "consentDate": consentDate?.toIso8601String(),
    "isPrivacy": isPrivacy,
    "privacyDate": privacyDate?.toIso8601String(),
    "isGuest": isGuest,
    "pointExpirationDate": pointExpirationDate?.toIso8601String(),
    "pointResetDate": pointResetDate?.toIso8601String(),
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };

  bool isValid() {
    if (id != null && id != '') {
      return true;
    } else {
      return false;
    }
  }

  String displayName() {
    var temp = '';
    if (isValid()) {
      if (isGuest == 1) {
        return 'Guest Account';
      } else {
        if (firstname != null && firstname != '') {
          temp += firstname.toString();
        }
        if (lastname != null && lastname != '') {
          temp += ' ' + lastname.toString();
        }
        if (temp == '' && username != null && username != '') {
          temp = username.toString();
        }
        return temp;
      }
    } else {
      return '';
    }
  }
}
