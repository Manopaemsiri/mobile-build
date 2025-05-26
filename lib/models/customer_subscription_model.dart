import 'dart:convert';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/models/index.dart';
import 'package:flutter/material.dart';

import '../controller/language_controller.dart';
import '../utils/formater.dart';

/*
  channel : String
    - C2U
    - Store

  status : Number
    -1 = Charge Failed
    0  = Cancel
    1  = Pause
    2  = In Process
    3  = Completed
*/

CustomerSubscriptionModel customerSubscriptionModelFromJson(String str) 
  => CustomerSubscriptionModel.fromJson(json.decode(str));

String customerSubscriptionModelToJson(CustomerSubscriptionModel data) 
  => json.encode(data.toJson());

class CustomerSubscriptionModel {
  final String? id;
  final String type;
  final String channel;

  final String prefixOrderId2C2P;

  final CustomerModel? customer;
  final PartnerProductSubscriptionModel? subscription;
  final String subscriptionId;

  final PartnerShopModel? shop;
  final UserModel? partner;
  final UserModel? salesManager;

  final int recurringType;
  final int recurringInterval;
  final int recurringCount;

  final int hasRelatedProducts;
  final double relatedCredit;
  final List<RelatedProduct> relatedProducts;

  final List<SelectionSteps> selectionSteps;

  final String signature;

  final CustomerShippingAddressModel? shippingAddress;
  final CustomerBillingAddressModel? billingAddress;

  final double discount;
  final double subtotal;

  final String vatName;
  final double vatPercent; 
  final double vat;

  final double total;

  final PartnerShippingFrontendModel ?shippingFrontend;
  final double shippingCost;

  final double grandTotal;

  final List packagings;

  final int status;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  CustomerSubscriptionModel({
    this.id,
    this.type = 'C2U',
    this.channel = '2C2P',

    this.prefixOrderId2C2P = '',

    this.customer,
    this.subscription,
    this.subscriptionId = '',

    this.shop,
    this.partner,
    this.salesManager,

    this.recurringType = 2,
    this.recurringInterval = 1,
    this.recurringCount = 12,

    this.hasRelatedProducts = 0,
    this.relatedCredit = 0,
    this.relatedProducts = const [],

    this.selectionSteps = const [],

    this.signature = '',

    this.shippingAddress,
    this.billingAddress,

    this.discount = 0,
    this.subtotal = 0,

    this.vatName = '',
    this.vatPercent = 0,
    this.vat = 0,

    this.total = 0,

    this.shippingFrontend,
    this.shippingCost = 0,

    this.grandTotal = 0,

    this.packagings = const [],

    this.status = 2,

    this.createdAt,
    this.updatedAt,
  });

  CustomerSubscriptionModel copyWith({
    String? id,
    String? type,
    String? channel,
    String? prefixOrderId2C2P,
    CustomerModel? customer,
    PartnerProductSubscriptionModel? subscription,
    String? subscriptionId,
    PartnerShopModel? shop,
    UserModel? partner,
    UserModel? salesManager,
    int? recurringType,
    int? recurringInterval,
    int? recurringCount,
    int? hasRelatedProducts,
    double? relatedCredit,
    List<RelatedProduct>? relatedProducts,
    List<SelectionSteps>? selectionSteps,
    String? signature,
    CustomerShippingAddressModel? shippingAddress,
    CustomerBillingAddressModel? billingAddress,
    double? discount,
    double? subtotal,
    String? vatName,
    double? vatPercent, 
    double? vat,
    double? total,
    PartnerShippingFrontendModel? shippingFrontend,
    double? shippingCost,
    double? grandTotal,
    List? packagings,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CustomerSubscriptionModel(
    id: id ?? this.id,
    type: type ?? this.type,
    channel: channel ?? this.channel,
    prefixOrderId2C2P: prefixOrderId2C2P ?? this.prefixOrderId2C2P,
    customer: customer ?? this.customer,
    subscription: subscription ?? this.subscription,
    subscriptionId: subscriptionId ?? this.subscriptionId,
    shop: shop ?? this.shop,
    partner: partner ?? this.partner,
    salesManager: salesManager ?? this.salesManager,
    recurringType: recurringType ?? this.recurringType,
    recurringInterval: recurringInterval ?? this.recurringInterval,
    recurringCount: recurringCount ?? this.recurringCount,
    hasRelatedProducts: hasRelatedProducts ?? this.hasRelatedProducts,
    relatedCredit: relatedCredit ?? this.relatedCredit,
    relatedProducts: relatedProducts ?? this.relatedProducts,
    selectionSteps: selectionSteps ?? this.selectionSteps,
    signature: signature ?? this.signature,
    shippingAddress: shippingAddress ?? this.shippingAddress,
    billingAddress: billingAddress ?? this.billingAddress,
    discount: discount ?? this.discount,
    subtotal: subtotal ?? this.subtotal,
    vatName: vatName ?? this.vatName,
    vatPercent: vatPercent ?? this.vatPercent,
    vat: vat ?? this.vat,
    total: total ?? this.total,
    shippingFrontend: shippingFrontend ?? this.shippingFrontend,
    shippingCost: shippingCost ?? this.shippingCost,
    grandTotal: grandTotal ?? this.grandTotal,
    packagings: packagings ?? this.packagings,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory CustomerSubscriptionModel.fromJson(Map<String, dynamic> json) => CustomerSubscriptionModel(
    id: json['_id'],

    type: json['type'] ?? 'C2U',
    channel: json['channel'] ?? '2C2P',
    prefixOrderId2C2P: json['prefixOrderId2C2P'] ?? '',

    customer: json['customer'] == null || json['customer'] is String? null : CustomerModel.fromJson(json['customer']),
    subscription: json['subscription'] == null || json['subscription'] is String? null : PartnerProductSubscriptionModel.fromJson(json['subscription']),
    subscriptionId: json['subscriptionId'] ?? '',

    shop: json['shop'] == null || json['shop'] is String? null : PartnerShopModel.fromJson(json['shop']),
    partner: json['partner'] == null || json['partner'] is String? null : UserModel.fromJson(json['partner']),
    salesManager: json['salesManager'] == null || json['salesManager'] is String? null : UserModel.fromJson(json['salesManager']),

    recurringType: json['recurringType'] == null
      ? 2: int.parse(json['recurringType'].toString()),
    recurringInterval: json['recurringInterval'] == null
      ? 1: int.parse(json['recurringInterval'].toString()),
    recurringCount: json['recurringCount'] == null
      ? 12: int.parse(json['recurringCount'].toString()),

    hasRelatedProducts: json['hasRelatedProducts'] ?? 0,
    relatedCredit: json['relatedCredit'] == null
      ? 0: double.parse(json['relatedCredit'].toString()),

    relatedProducts: json['relatedProducts'] == null || json['relatedProducts'] is String
      ? []: List<RelatedProduct>.from(json['relatedProducts'].where((x) => x is! String).map((x) => RelatedProduct.fromJson(x))),

    selectionSteps: json['selectionSteps'] == null || json['selectionSteps'] is String
      ? []: List<SelectionSteps>.from(json['selectionSteps'].where((x) => x is! String).map((x) => SelectionSteps.fromJson(x))),
    
    signature: json['signature'] ?? '',

    shippingAddress: json['shippingAddress'] == null || json['shippingAddress'] is String? null : CustomerShippingAddressModel.fromJson(json['shippingAddress']),
    billingAddress: json['billingAddress'] == null || json['billingAddress'] is String? null : CustomerBillingAddressModel.fromJson(json['billingAddress']),
    
    shippingFrontend: json['shippingFrontend'] == null || json['shippingFrontend'] is String? null : PartnerShippingFrontendModel.fromJson(json['shippingFrontend']),

    discount: json['discount'] == null
        ? 0: double.parse(json['discount'].toString()),
    subtotal: json['subtotal'] == null
        ? 0: double.parse(json['subtotal'].toString()),

    vatName: json['vatName'] ?? '',
    vatPercent: json['vatPercent'] == null
      ? 0: double.parse(json['vatPercent'].toString()),
    vat: json['vat'] == null
      ? 0: double.parse(json['vat'].toString()),

    total: json['total'] == null
      ? 0: double.parse(json['total'].toString()),
    grandTotal: json['grandTotal'] == null
      ? 0: double.parse(json['grandTotal'].toString()),

    packagings: json['packagings'] ?? [],

    status: json['status'] ?? 1,

    createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'type': type,
    'channel': channel,
    'prefixOrderId2C2P': prefixOrderId2C2P,
    'customer': customer?.toJson(),
    'subscription': subscription?.toJson(),
    'subscriptionId': subscriptionId,
    'shop': shop?.toJson(),
    'partner': partner?.toJson(),
    'salesManager': salesManager?.toJson(),
    'recurringType': recurringType,
    'recurringInterval': recurringInterval,
    'recurringCount': recurringCount,
    'hasRelatedProducts': hasRelatedProducts,
    'relatedCredit': relatedCredit,
    'relatedProducts': relatedProducts.isEmpty? [] 
      : List<RelatedProduct>.from(relatedProducts.map((x) => x.toJson())),
    'selectionSteps': selectionSteps.isEmpty? [] 
      : List<SelectionSteps>.from(selectionSteps.map((x) => x.toJson())),
    'signature': signature,
    'shippingAddress': shippingAddress?.toJson(),
    'billingAddress': billingAddress?.toJson(),
    'discount': discount,
    'subtotal': subtotal,
    'vatName': vatName,
    'vatPercent': vatPercent,
    'vat': vat,
    'total': total,
    'grandTotal': grandTotal,
    'packagings': packagings,
    'status': status,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  isValid() => id?.isNotEmpty;

  displayStatus(LanguageController lController){
    if(id?.isEmpty == true){
      return '';
    }else if(status == -1){
      return lController.getLang('Charge Failed');
    }else if(status == 0){
      return lController.getLang('Cancel');
    }else if(status == 1){
      return lController.getLang('Pause');
    }else if(status == 2){
      return lController.getLang('In Process');
    }else if(status == 3){
      return lController.getLang('Completed');
    }
  }

  Color displayStatusColor(){
    if(status == -1){
      return kRedColor;
    }else if(status == 0){
      return kGrayLightColor;
    }else if(status == 1){
      return kYellowColor;
    }else if(status == 2){
      return kBlueColor;
    }else if(status == 3){
      return kGreenColor;
    }
    return kGreenColor;
  }


  displayRecurringTypeName(LanguageController controller) {
    if(recurringType == 1){
      return controller.getLang('Day');
    }else if(recurringType == 2){
      return controller.getLang('Month');
    }else if(recurringType == 3){
      return controller.getLang('Year');
    }
    return '';
  }

  String diaplaySubscriptionPrice(LanguageController lController){
    double price = total;

    String text = lController.getLang('text_subscription_price')
    .replaceFirst('_VALUE_', priceFormat(price, lController, showSymbol: false))
    .replaceFirst('_VALUE2_', displayRecurringTypeName(lController));

    return text;
  }

  String diaplaySubscriptionContract(LanguageController lController){
    String text = lController.getLang('text_subscription_contract')
    .replaceFirst('_VALUE_', '$recurringCount')
    .replaceFirst('_VALUE2_', displayRecurringTypeName(lController));

    return text;
  }

}
