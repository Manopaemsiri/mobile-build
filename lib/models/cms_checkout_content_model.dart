import 'dart:convert';

import 'package:coffee2u/models/index.dart';

CmsCheckoutContentModel cmsCheckoutConetntModelFromJson(String str) => CmsCheckoutContentModel.fromJson(json.decode(str));

String cmsCheckoutContentModelToJson(CmsCheckoutContentModel data) => json.encode(data.toJson());

class CmsCheckoutContentModel {
  final String? id;
  final String? name;
  final String? type;
  final int status;
  final int order;

  final DateTime? startAt;
  final DateTime? endAt;

  final List<PartnerProductModel>? relatedProducts;
  final List<CmsContentModel>? relatedContents;

  final int enabledPopup;
  final CmsPopupModel? relatedPopup;

  final List<CustomerGroupModel>? forCustomerGroups;

  final int forAllPartnerShops;
  final List<PartnerShopModel>? forPartnerShops;

  final int forAllCustomerTiers;
  final List<CustomerTierModel>? forCustomerTiers;

  final int forAllProvinces;
  final List<ProvinceModel>? forProvinces;


  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  CmsCheckoutContentModel({
    this.id,
    this.name,
    this.type,
    this.status = 0,
    this.order = 1,
    this.startAt,
    this.endAt,
    this.relatedProducts,
    this.relatedContents,
    this.enabledPopup = 0,
    this.relatedPopup,
    this.forCustomerGroups,
    this.forAllPartnerShops = 1,
    this.forPartnerShops,
    this.forAllCustomerTiers = 1,
    this.forCustomerTiers,
    this.forAllProvinces = 1,
    this.forProvinces,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  CmsCheckoutContentModel copyWith({
    String? id,
    String? name,
    String? type,
    int? status,
    int? order,
    DateTime? startAt,
    DateTime? endAt,
    List<PartnerProductModel>? relatedProducts,
    List<CmsContentModel>? relatedContents,
    int? enabledPopup,
    CmsPopupModel? relatedPopup,
    List<CustomerGroupModel>? forCustomerGroups,
    int? forAllPartnerShops,
    List<PartnerShopModel>? forPartnerShops,
    int? forAllCustomerTiers,
    List<CustomerTierModel>? forCustomerTiers,
    int? forAllProvinces,
    List<ProvinceModel>? forProvinces,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CmsCheckoutContentModel(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    status: status ?? this.status, 
    order: order ??  this.order, 
    startAt: startAt ?? this.startAt,
    endAt: endAt ?? this.endAt,
    relatedProducts: relatedProducts ?? this.relatedProducts,
    relatedContents: relatedContents ?? this.relatedContents,
    enabledPopup: enabledPopup ?? this.enabledPopup, 
    relatedPopup: relatedPopup ?? this.relatedPopup,
    forCustomerGroups: forCustomerGroups ?? this.forCustomerGroups,
    forAllPartnerShops: forAllPartnerShops ?? this.forAllPartnerShops, 
    forPartnerShops: forPartnerShops ?? this.forPartnerShops, 
    forAllCustomerTiers: forAllCustomerTiers ?? this.forAllCustomerTiers, 
    forCustomerTiers: forCustomerTiers ?? this.forCustomerTiers, 
    forAllProvinces: forAllProvinces ?? this.forAllProvinces, 
    forProvinces: forProvinces ?? this.forProvinces,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory CmsCheckoutContentModel.fromJson(Map<String, dynamic> json) => CmsCheckoutContentModel(
    id: json['_id'],
    name: json['name'],
    type: json['type'],
    status: json['status'] ?? 0,
    order: json['order'] ?? 1,
    startAt: json['startAt'] == null ? null : DateTime.parse(json['startAt']),
    endAt: json['endAt'] == null ? null : DateTime.parse(json['endAt']),
    relatedProducts: json['relatedProducts'] == null? [] : List<PartnerProductModel>.from(json['relatedProducts']!.map((x) => PartnerProductModel.fromJson(x))),
    relatedContents: json['relatedContents'] == null? [] : List<CmsContentModel>.from(json['relatedContents']!.map((x) => CmsContentModel.fromJson(x))),
    enabledPopup: json['enabledPopup'] ?? 0,
    relatedPopup: json['relatedPopup'] == null || json['relatedPopup'] is String? null: CmsPopupModel.fromJson(json['relatedPopup']),
    forCustomerGroups: json['forCustomerGroups'] == null? [] : List<CustomerGroupModel>.from(json['forCustomerGroups']!.map((x) => CustomerGroupModel.fromJson(x))),
    forAllPartnerShops: json['forAllPartnerShops'] ?? 1,
    forPartnerShops: json['forPartnerShops'] == null? [] : List<PartnerShopModel>.from(json['forPartnerShops']!.map((x) => PartnerShopModel.fromJson(x))),
    forAllCustomerTiers: json['forAllCustomerTiers'] ?? 1,
    forCustomerTiers: json['forCustomerTiers'] == null? [] : List<CustomerTierModel>.from(json['forCustomerTiers']!.map((x) => CustomerTierModel.fromJson(x))),
    forAllProvinces: json['forAllProvinces'] ?? 1,
    forProvinces: json['forProvinces'] == null? [] : List<ProvinceModel>.from(json['forProvinces']!.map((x) => ProvinceModel.fromJson(x))),
    createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
    v: json['__v'],
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'type': type,
    'status': status,
    'order': order,
    'startAt': startAt?.toIso8601String(),
    'endAt': endAt?.toIso8601String(),
    'relatedProducts': relatedProducts == null? null 
      : List<PartnerProductModel>.from(relatedProducts!.map((x) => x.toJson())),
    'relatedContents': relatedContents == null? null 
      : List<CmsContentModel>.from(relatedContents!.map((x) => x.toJson())),
    'enabledPopup': enabledPopup,
    'relatedPopup': relatedPopup?.toJson(),
    'forCustomerGroups': forCustomerGroups == null? null 
      : List<CustomerGroupModel>.from(forCustomerGroups!.map((x) => x.toJson())),
    'forAllPartnerShops': forAllPartnerShops,
    'forPartnerShops': forPartnerShops == null? null 
      : List<PartnerShopModel>.from(forPartnerShops!.map((x) => x.toJson())),
    'forAllCustomerTiers': forAllCustomerTiers,
    'forCustomerTiers': forCustomerTiers == null? null 
      : List<CustomerTierModel>.from(forCustomerTiers!.map((x) => x.toJson())),
    'forAllProvinces': forAllProvinces,
    'forProvinces': forProvinces == null? null 
      : List<ProvinceModel>.from(forProvinces!.map((x) => x.toJson())),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
  };

  bool get showPopup => enabledPopup == 1 && relatedPopup?.isValid() ==  true;
}
