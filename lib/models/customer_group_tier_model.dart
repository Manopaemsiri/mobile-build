import 'dart:convert';

import 'customer_group_model.dart';
import 'customer_tier_model.dart';

CustomerGroupTierModel customerGroupTierModelFromJson(String str) => CustomerGroupTierModel.fromJson(json.decode(str));

String customerGroupTierModelToJson(CustomerGroupTierModel data) => json.encode(data.toJson());

class CustomerGroupTierModel {
  final String? id;
  final CustomerGroupModel? group;
  final CustomerTierModel? tier;
  final int? pointEarnRate;
  final double? pointBurnRate;
  final int? minOrderMonthly;
  final int? pointBurnStep;
  final int? isDefault;
  final int? order;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  CustomerGroupTierModel({
    this.id,
    this.group,
    this.tier,
    this.pointEarnRate,
    this.pointBurnRate,
    this.minOrderMonthly,
    this.pointBurnStep,
    this.isDefault,
    this.order,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  CustomerGroupTierModel copyWith({
    String? id,
    CustomerGroupModel? group,
    CustomerTierModel? tier,
    int? pointEarnRate,
    double? pointBurnRate,
    int? minOrderMonthly,
    int? pointBurnStep,
    int? isDefault,
    int? order,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) => CustomerGroupTierModel(
    id: id ?? this.id,
    group: group ?? this.group,
    tier: tier ?? this.tier,
    pointEarnRate: pointEarnRate ?? this.pointEarnRate,
    pointBurnRate: pointBurnRate ?? this.pointBurnRate,
    minOrderMonthly: minOrderMonthly ?? this.minOrderMonthly,
    pointBurnStep: pointBurnStep ?? this.pointBurnStep,
    isDefault: isDefault ?? this.isDefault,
    order: order ?? this.order,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
  );

  factory CustomerGroupTierModel.fromJson(Map<String, dynamic> json) => CustomerGroupTierModel(
    id: json["_id"],
    group: json["group"] == null || json["group"] is String? null : CustomerGroupModel.fromJson(json["group"]),
    tier: json["tier"] == null || json["tier"] is String? null : CustomerTierModel.fromJson(json["tier"]),
    pointEarnRate: json["pointEarnRate"],
    pointBurnRate: json["pointBurnRate"]?.toDouble(),
    minOrderMonthly: json["minOrderMonthly"],
    pointBurnStep: json["pointBurnStep"],
    isDefault: json["isDefault"],
    order: json["order"],
    status: json["status"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "group": group,
    "tier": tier?.toJson(),
    "pointEarnRate": pointEarnRate,
    "pointBurnRate": pointBurnRate,
    "minOrderMonthly": minOrderMonthly,
    "pointBurnStep": pointBurnStep,
    "isDefault": isDefault,
    "order": order,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };

  bool isValid() => id != null;
}
