import 'dart:convert';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:flutter/material.dart';

import '../widgets/badge_default.dart';

/*
  paymentStatus
    -1 = คืนเงินแล้ว
    0  = ทดสอบ
    1  = รอการชำระเงิน COD
    2  = ชำระเงินแล้ว COD
    3  = ชำระเงินแล้ว
    4  = ผ่อนชำระแล้ว

  status : Number
    0 = Cancel
    1 = Skip
    2 = Ongoing
    3 = Completed
*/

CustomerSubscriptionOrderModel customerSubscriptionOrderModelFromJson(String str) 
  => CustomerSubscriptionOrderModel.fromJson(json.decode(str));

String customerSubscriptionOrderModelToJson(CustomerSubscriptionOrderModel data) 
  => json.encode(data.toJson());

class CustomerSubscriptionOrderModel {
  final String? id;

  final CustomerSubscriptionModel? subscription;
  final PartnerProductSubscriptionModel? order;

  final List<RelatedProduct> products;

  final DateTime? paymentDue;

  final int status;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  CustomerSubscriptionOrderModel({
    this.id = '',
    this.subscription,
    this.order,
    this.products = const [],
    this.paymentDue,
    this.status = 2,
    this.createdAt,
    this.updatedAt,
  });

  CustomerSubscriptionOrderModel copyWith({
    String? id,
    CustomerSubscriptionModel? subscription,
    PartnerProductSubscriptionModel? order,
    List<RelatedProduct>? products,
    DateTime? paymentDue,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CustomerSubscriptionOrderModel(
    id: id ?? this.id,
    subscription: subscription ?? this.subscription,
    order: order ?? this.order,
    products: products ?? this.products,
    paymentDue: paymentDue ?? this.paymentDue,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory CustomerSubscriptionOrderModel.fromJson(Map<String, dynamic> json) => CustomerSubscriptionOrderModel(
    id: json['_id'],

    subscription: json['subscription'] == null || json['subscription'] is String? null : CustomerSubscriptionModel.fromJson(json['subscription']),
    order: json['order'] == null || json['order'] is String? null : PartnerProductSubscriptionModel.fromJson(json['order']),

    products: json['products'] == null || json['products'] is String
      ? []: List<RelatedProduct>.from(json['products'].where((x) => x is! String).map((x) => RelatedProduct.fromJson(x))),
    
    paymentDue: json['paymentDue'] == null ? null : DateTime.parse(json['paymentDue']),
    status: json['status'] ?? 1,

    createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'subscription': subscription?.toJson(),
    'order': order?.toJson(),
    'products': products.isEmpty? [] 
      : List<RelatedProduct>.from(products.map((x) => x.toJson())),
    'paymentDue': paymentDue?.toIso8601String(),
    'status': status,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  isValid() => id?.isNotEmpty;

  Widget displayStatus(LanguageController lController) {
    String text = lController.getLang('subscription_status_$status');
    Color? color;
    if(status == 0){
      color = kRedColor;
    }else if(status == 1){
      color = kYellowColor;
    }else if(status == 2){
      color = kBlueColor;
    }else if(status == 3){
      color = kGreenColor;
    }

    return BadgeDefault(
      title: text,
      color: color,
      size: 15,
    );
  }
}



