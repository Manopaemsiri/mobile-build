import 'dart:convert';
import 'package:coffee2u/models/index.dart';

ResApiAuth resApiAuthFromJson(String str) =>
  ResApiAuth.fromJson(json.decode(str));
String resApiAuthToJson(ResApiAuth data) => json.encode(data.toJson());

class ResApiAuth {
  ResApiAuth({
    this.message,
    this.data,
  });
  String? message;
  DataModelAuth? data;

  factory ResApiAuth.fromJson(Map<String, dynamic> json) => ResApiAuth(
    message: json["message"],
    data: DataModelAuth.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
  };
}

class DataModelAuth {
  DataModelAuth({
    this.accessToken,
    this.refreshToken,
    this.user,
    this.address,
  });

  String? accessToken;
  String? refreshToken;
  CustomerModel? user;
  CustomerShippingAddressModel? address;

  factory DataModelAuth.fromJson(Map<String, dynamic> json) {
    return DataModelAuth(
      accessToken: json["accessToken"],
      refreshToken: json["refreshToken"],
      user: json["user"] != null && json["user"].runtimeType != String 
        ? CustomerModel.fromJson(json["user"]) 
        : null,
      address: json["result"] != null && json["result"].runtimeType != String 
        ? CustomerShippingAddressModel.fromJson(json["result"]) 
        : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "accessToken": accessToken,
    "refreshToken": refreshToken,
    "user": user?.toJson(),
    "result": address?.toJson(),
  };
}