import 'dart:convert';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:flutter/material.dart';

import '../widgets/badge_default.dart';

/*
  status : Number
    -1 = Charge Failed
    0  = Cancel
    1  = Pause
    2  = In Process
    3  = Completed
*/

CustomerSubscriptionPlanModel customerSubscriptionPlanModelFromJson(String str) 
  => CustomerSubscriptionPlanModel.fromJson(json.decode(str));

String customerSubscriptionPlanModelToJson(CustomerSubscriptionPlanModel data) 
  => json.encode(data.toJson());

class CustomerSubscriptionPlanModel {
  final String? id;

  final CustomerSubscriptionModel? subscription;
  final CustomerOrderModel? order;

  final DateTime? recurringDate;

  final String? orderId2C2P;
  final String? paymentToken2C2P;

  final DateTime? paymentAt;

  final int status;

  final double total;
  final double initialPriceInVAT;
  final double shippingCost;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  CustomerSubscriptionPlanModel({
    this.id,
    this.subscription,
    this.order,
    this.recurringDate,
    this.orderId2C2P,
    this.paymentToken2C2P,
    this.paymentAt,
    this.status = 2,
    this.total = 0,
    this.initialPriceInVAT = 0,
    this.shippingCost = 0,
    this.createdAt,
    this.updatedAt,
  });

  CustomerSubscriptionPlanModel copyWith({
    String? id,
    CustomerSubscriptionModel? subscription,
    CustomerOrderModel? order,
    DateTime? recurringDate,
    String? orderId2C2P,
    String? paymentToken2C2P,
    DateTime? paymentAt,
    int? status,
    double? total,
    double? initialPriceInVAT,
    double? shippingCost,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CustomerSubscriptionPlanModel(
    id: id ?? this.id,
    subscription: subscription ?? this.subscription,
    order: order ?? this.order,
    recurringDate: recurringDate ?? this.recurringDate,
    orderId2C2P: orderId2C2P ?? this.orderId2C2P,
    paymentToken2C2P: paymentToken2C2P ?? this.paymentToken2C2P,
    paymentAt: paymentAt ?? this.paymentAt,
    status: status ?? this.status,
    total: total ?? this.total,
    initialPriceInVAT: initialPriceInVAT ?? this.initialPriceInVAT,
    shippingCost: shippingCost ?? this.shippingCost,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory CustomerSubscriptionPlanModel.fromJson(Map<String, dynamic> json) => CustomerSubscriptionPlanModel(
    id: json['_id'],
    subscription: json['subscription'] == null || json['subscription'] is String? null : CustomerSubscriptionModel.fromJson(json['subscription']),
    order: json['order'] == null || json['order'] is String? null : CustomerOrderModel.fromJson(json['order']),
    recurringDate: json['recurringDate'] == null? null : DateTime.parse(json['recurringDate']),
    orderId2C2P: json['orderId2C2P'],
    paymentToken2C2P: json['paymentToken2C2P'],
    paymentAt: json['paymentAt'] == null ? null: DateTime.parse(json['paymentAt']),
    status: json['status'] ?? 1,
    total: json['total'] != null? double.parse(json['total'].toString()): 0,
    initialPriceInVAT: json['initialPriceInVAT'] != null? double.parse(json['initialPriceInVAT'].toString()): 0,
    shippingCost: json['shippingCost'] != null? double.parse(json['shippingCost'].toString()): 0,
    createdAt: json['createdAt'] == null? null : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null? null : DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'order': order?.toJson(),
    'subscription': subscription?.toJson(),
    'recurringDate': recurringDate?.toIso8601String(),
    'orderId2C2P': orderId2C2P,
    'paymentToken2C2P': paymentToken2C2P,
    'paymentAt': paymentAt?.toIso8601String(),
    'status': status,
    'total': total,
    'initialPriceInVAT': initialPriceInVAT,
    'shippingCost': shippingCost,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  isValid() => id?.isNotEmpty;

  Widget displayStatus(LanguageController lController) {
    String text = '';
    Color? color;
    Color? textColor;

    if(status == -1){
      color = kRedColor;
      text = 'Charge Failed';
      textColor = Colors.white;
    }else if(status == 0){
      color = kGrayLightColor;
      text = 'Cancel';
      textColor = kDarkColor;
    }else if(status == 1){
      color = kYellowColor;
      text = 'Pause';
      textColor = Colors.white;
    }else if(status == 2){
      color = kBlueColor;
      text = 'In Process';
      textColor = Colors.white;
    }else if(status == 3){
      color = kGreenColor;
      text = 'Completed';
      textColor = Colors.white;
    }

    return BadgeDefault(
      title: lController.getLang(text),
      color: color,
      size: 15,
      textColor: textColor
    );
  }

  Color statusColor() {
    Color color = kRedColor;
    if(status == -1){
      color = kRedColor;
    }else if(status == 0){
      color = kGrayLightColor;
    }else if(status == 1){
      color = kYellowColor;
    }else if(status == 2){
      color = kBlueColor;
    }else if(status == 3){
      color = kGreenColor;
    }
    return color;
  }

  Color textStatusColor() {
    Color textColor = kRedColor;
    if(status == -1){
      textColor = kRedColor;
    }else if(status == 0){
      textColor = kGrayLightColor;
    }else if(status == 1){
      textColor = kYellowColor;
    }else if(status == 2){
      textColor = kBlueColor;
    }else if(status == 3){
      textColor = kGreenColor;
    }
    return textColor;
  }

  String billingFormat() {
    String text = '';
    if(subscription?.recurringType == 1){
      text = 'dd/MM/y';
    }else if(subscription?.recurringType == 2){
      text = 'MMM y';
    }else if(subscription?.recurringType == 3){
      text = 'y';
    }
    return text;
  }
}



