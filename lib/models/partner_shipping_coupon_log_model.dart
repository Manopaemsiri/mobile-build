import 'dart:convert';
import 'partner_shipping_coupon.dart';

/*
  redeemStatus
    0 = Recieved from system
    1 = Redeem by points
*/

PartnerShippingCouponLogModel partnerShippingCouponLogFromJson(String str) =>
  PartnerShippingCouponLogModel.fromJson(json.decode(str));
String partnerShippingCouponLogToJson(PartnerShippingCouponLogModel model) =>
  json.encode(model.toJson());

class PartnerShippingCouponLogModel {
  PartnerShippingCouponLogModel({
    this.id,
    this.coupon,
    this.redeemStatus = 0,
    this.points = 0,
    this.isUsed = 0,
    this.usedAt,
    this.expiredAt,
    this.createdAt,
    this.updatedAt,
  });
  String? id;
  PartnerShippingCouponModel? coupon;

  int redeemStatus;
  int points;

  int isUsed;
  DateTime? usedAt;
  DateTime? expiredAt;

  DateTime? createdAt;
  DateTime? updatedAt;

  PartnerShippingCouponLogModel copyWith({
    String? id,
    PartnerShippingCouponModel? coupon,
    int? redeemStatus,
    int? points,
    int? isUsed,
    DateTime? usedAt,
    DateTime? expiredAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PartnerShippingCouponLogModel(
    id: id ?? this.id,
    coupon: coupon ?? this.coupon,
    redeemStatus: redeemStatus ?? this.redeemStatus,
    points: points ?? this.points,
    isUsed: isUsed ?? this.isUsed,
    usedAt: usedAt ?? this.usedAt,
    expiredAt: expiredAt ?? this.expiredAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory PartnerShippingCouponLogModel.fromJson(Map<String, dynamic> json){
   
    return PartnerShippingCouponLogModel(
      id: json["_id"],
      coupon: json["coupon"] != null && json["coupon"] is! String 
        ? PartnerShippingCouponModel.fromJson(json["coupon"])
        : null,
      redeemStatus: json["redeemStatus"] ?? 0,
      points: json["points"] ?? 0,
      isUsed: json["isUsed"] ?? 0,
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
    "updausedAttedAt": usedAt == null? null: usedAt!.toIso8601String(),
    "expiredAt": expiredAt == null? null: expiredAt!.toIso8601String(),
    
    "updatedAt": updatedAt == null? null: updatedAt!.toIso8601String(),
    "createdAt": createdAt == null? null: createdAt!.toIso8601String(),
  };

  bool isValid() {
    return id != null ? true : false;
  }
}