import 'dart:convert';
import 'package:coffee2u/models/index.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));
String userModelToJson(UserModel model) => json.encode(model.toJson());

class UserModel {
  UserModel({
    this.id,
    this.firstname,
    this.lastname,
    this.username,
    this.email,
    this.avatar,
    this.address,
    this.fcmToken,
    this.status,
  });
  final String? id;

  // this.role = new UserRoleModel(data.role? data.role: {});
  // this.partnerShops = data.partnerShops && data.partnerShops.length
  //     ? data.partnerShops.map(d => new PartnerShopModel(d)): [];
  // this.partnerShopIds = this.partnerShops.map(d => d._id);

  String? firstname;
  String? lastname;
  String? username;
  String? email;
  FileModel? avatar;

  CustomerShippingAddressModel? address;

  String? fcmToken;

  final int? status;
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["_id"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    username: json["username"],
    email: json["email"],
    avatar: json["avatar"] == null || json["avatar"] is String? null
      : FileModel.fromJson(json["avatar"]),
    address: json["address"] != null && json["address"] is! String
      ? CustomerShippingAddressModel.fromJson(json["address"]) 
      : null,
    fcmToken: json["fcmToken"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "firstname": firstname,
    "lastname": lastname,
    "username": username,
    "email": email,
    "avatar": avatar?.toJson(),
    "address": address?.toJson(),
    "fcmToken": fcmToken,
    "status": status,
  };
}
