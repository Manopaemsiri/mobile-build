import 'dart:convert';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';

/*
  status
    -1  = Canceled order

    0  = Pending points
    1  = Burn points for partner product coupon
    2  = Earn points from returning partner product coupon
    3  = Burn points for partner shipping coupon
    4  = Earn points from returning partner shipping coupon
    5  = Burn points for order
    6  = Earn points from order

    80 = Sync points from SAP
    81 = Use points in SAP

    90 = Sync points from POS
    91 = Use points in POS

    100 = System
*/

CustomerPointModel customerPointModelFromJson(String str) => 
  CustomerPointModel.fromJson(json.decode(str));
String customerPointModelToJson(CustomerPointModel model) => 
  json.encode(model.toJson());

class CustomerPointModel {
  CustomerPointModel({
    this.id,
    this.productCoupon,
    this.shippingCoupon,
    this.order,

    this.points = 0,
    this.channel = 'C2U',
    this.description = '',

    this.status = 0,

    this.createdAt,
    this.updatedAt,
  });

  String? id;
  PartnerProductCouponModel? productCoupon;
  PartnerShippingCouponModel? shippingCoupon;
  CustomerOrderModel? order;

  int points;
  String channel;
  String description;

  int status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory CustomerPointModel.fromJson(Map<String, dynamic> json){
    var unescape = HtmlUnescape();
    return CustomerPointModel(
      id: json["_id"],
      productCoupon: json["productCoupon"] != null && json["productCoupon"] is! String
        ? PartnerProductCouponModel.fromJson(json["productCoupon"]) 
        : null,
      shippingCoupon: json["shippingCoupon"] != null && json["shippingCoupon"] is! String
        ? PartnerShippingCouponModel.fromJson(json["shippingCoupon"]) 
        : null,
      order: json["order"] != null && json["order"] is! String
        ? CustomerOrderModel.fromJson(json["order"]) 
        : null,

      points: json["points"] ?? 0,
      channel: json["channel"] ?? 'C2U',
      description: json["description"]==null? '': unescape.convert(json["description"]),

      status: json["status"] ?? 0,
      
      createdAt: json["createdAt"] == null
        ? null: DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null
        ? null: DateTime.parse(json["updatedAt"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "productCoupon": productCoupon?.toJson(),
    "shippingCoupon": shippingCoupon?.toJson(),
    "order": order?.toJson(),
    "points": points,
    "channel": channel,
    "description": description,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };

  bool isValid() {
    return id != null? true: false;
  }

  Widget displayType() {
    if(isValid()){
      if([-1].contains(status)){
        return _badgePoint('Canceled Order', kRedColor);
      }else if([1, 3, 5].contains(status)){
        return _badgePoint('Burn Points', kYellowColor);
      }else if([2, 4, 6].contains(status)){
        return _badgePoint('Earn Points', kGreenColor);
      }else if([0].contains(status)){
        return _badgePoint('Pending Points', kAppColor);
      }else if([80, 90].contains(status)){
        return _badgePoint('Sync Points', kBlueColor);
      }else if([81].contains(status)){
        if(points > 0){
          return _badgePoint('From SAP', kGreenColor);
        }else{
          return _badgePoint('From SAP', kYellowColor);
        }
      }else if([91].contains(status)){
        if(points > 0){
          return _badgePoint('From POS', kGreenColor);
        }else{
          return _badgePoint('From POS', kYellowColor);
        }
      }else if([100].contains(status)){
        return _badgePoint('System', kBlueColor);
      }else{
        return const SizedBox.shrink();
      }
    }else{
      return const SizedBox.shrink();
    }
  }
  Widget displayPoints() {
    if(isValid()){
      String temp = numberFormat(double.parse(points.toString()), digits: 0);
      if([-1].contains(status)){
        return _widgetPoint(temp, kRedColor);
      }else if([1, 3, 5].contains(status)){
        return _widgetPoint(temp, kRedColor);
      }else if([2, 4, 6].contains(status)){
        return _widgetPoint('+$temp', kGreenColor);
      }else if([0].contains(status)){
        return _widgetPoint(temp, kAppColor);
      }else if([80, 90].contains(status)){
        return _widgetPoint(temp, kBlueColor);
      }else if([81].contains(status)){
        if(points > 0){
          return _widgetPoint('+$temp', kGreenColor);
        }else{
          return _widgetPoint(temp, kYellowColor);
        }
      }else if([91].contains(status)){
        if(points > 0){
          return _widgetPoint('+$temp', kGreenColor);
        }else{
          return _widgetPoint(temp, kYellowColor);
        }
      }else if([100].contains(status)){
        return _widgetPoint(temp, kBlueColor);
      }else{
        return const SizedBox.shrink();
      }
    }else{
      return const SizedBox.shrink();
    }
  }
  String displayDescription(LanguageController controller) {
    if(isValid()){
      if(description != ''){
        return description;
      }else{
        if(status == -1){
          return '${controller.getLang("Canceled Order")} ${order?.orderId ?? ''}';
        }else if(status == 1){
          return '${controller.getLang("Redeem product discount coupon")} ${productCoupon?.name ?? ''}';
        }else if(status == 2){
          return '${controller.getLang("Return Discount Coupon")} ${productCoupon?.name ?? ''}';
        }else if(status == 3){
          return '${controller.getLang("Redeem Shipping Coupon")} ${shippingCoupon?.name ?? ''}';
        }else if(status == 4){
          return '${controller.getLang("Return Shipping Coupon")} ${shippingCoupon?.name ?? ''}';
        }else if(status == 5){
          return '${controller.getLang("Use it as an order discount")} ${order?.orderId ?? ''}';
        }else if(status == 6){
          return '${controller.getLang("From the order")} ${order?.orderId ?? ''}';
        }else if(status == 0){
          return '${controller.getLang("Waiting for payment")} ${order?.orderId ?? ''}';
        }else if(status == 80){
          return 'Sync Points ${controller.getLang("From")} SAP';
        }else if(status == 90){
          return 'Sync Points ${controller.getLang("From")} POS';
        }else{
          return '';
        }
      }
    }else{
      return '';
    }
  }

  Widget _badgePoint(String titleText, Color bgColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        titleText,
        style: subtitle2.copyWith(
          color: kWhiteColor,
          fontFamily: "CenturyGothic",
          fontWeight: FontWeight.w600,
          letterSpacing: 0.25,
        ),
      ),
    );
  }
  Widget _widgetPoint(String titleText, Color color) {
    return Text(
      titleText,
      style: title.copyWith(
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}