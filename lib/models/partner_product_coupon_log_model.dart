import 'dart:convert';
import 'partner_product_coupon_model.dart';

/*
  redeemStatus
    0 = Recieved from system
    1 = Redeem by points
*/

PartnerProductCouponLogModel partnerProductCouponLogFromJson(String str) =>
  PartnerProductCouponLogModel.fromJson(json.decode(str));
String partnerProductCouponLogToJson(PartnerProductCouponLogModel model) =>
  json.encode(model.toJson());

class PartnerProductCouponLogModel {
  PartnerProductCouponLogModel({
    this.id,
    this.coupon,
    this.redeemStatus = 0,
    this.points = 0,
    this.isUsed = 0,
    this.status = 0,
    this.usedAt,
    this.expiredAt,
    this.createdAt,
    this.updatedAt,
  });
  String? id;
  PartnerProductCouponModel? coupon;

  int redeemStatus;
  int points;

  int isUsed;
  int status;
  DateTime? usedAt;
  DateTime? expiredAt;

  DateTime? createdAt;
  DateTime? updatedAt;

  PartnerProductCouponLogModel copyWith({
    String? id,
    PartnerProductCouponModel? coupon,
    int? redeemStatus,
    int? points,
    int? isUsed,
    int? status,
    DateTime? usedAt,
    DateTime? expiredAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PartnerProductCouponLogModel(
    id: id ?? this.id,
    coupon: coupon ?? this.coupon,
    redeemStatus: redeemStatus ?? this.redeemStatus,
    points: points ?? this.points,
    isUsed: isUsed ?? this.isUsed,
    status: status ?? this.status,
    usedAt: usedAt ?? this.usedAt,
    expiredAt: expiredAt ?? this.expiredAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory PartnerProductCouponLogModel.fromJson(Map<String, dynamic> json){
   
    return PartnerProductCouponLogModel(
      id: json["_id"],
      coupon: json["coupon"] != null && json["coupon"] is! String 
        ? PartnerProductCouponModel.fromJson(json["coupon"])
        : null,
      redeemStatus: json["redeemStatus"] ?? 0,
      points: json["points"] ?? 0,
      isUsed: json["isUsed"] ?? 0,
      status: json["status"] ?? 0,
      usedAt: json["usedAt"] == null
        ? null
        : DateTime.parse(json["usedAt"]),
      expiredAt: json["expiredAt"] == null
        ? null
        : DateTime.parse(json["expiredAt"]),
      updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
      createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "coupon": coupon?.toJson(),
    
    "redeemStatus": redeemStatus,
    "points": points,

    "isUsed": isUsed,
    "status": status,
    "usedAt": usedAt?.toIso8601String(),
    "expiredAt": expiredAt?.toIso8601String(),
    
    "updatedAt": updatedAt?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
  };

  bool isValid() {
    return id != null ? true : false;
  }
}