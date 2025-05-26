import 'dart:convert';
import 'dart:math';
import 'package:coffee2u/models/index.dart';


CustomerSubscriptionCartModel customerSubscriptionCartModelFromJson(String str) 
  => CustomerSubscriptionCartModel.fromJson(json.decode(str));

String customerSubscriptionCartModelToJson(CustomerSubscriptionCartModel data) 
  => json.encode(data.toJson());

class CustomerSubscriptionCartModel {
  final String? id;

  final CustomerModel? customer;

  final CustomerShippingAddressModel? shippingAddress;
  final CustomerBillingAddressModel? billingAddress;

  final PartnerProductSubscriptionModel? subscription;
  final List<RelatedProduct> relatedProducts;
  final List<SelectionSteps> selectionSteps;

  final double subtotal;
  final double initialPriceInVAT;
  
  final String vatName;
  final double vatPercent;
  final double vat;
  
  final double total;
  final double discount;
  final double grandTotal;

  final List packagings;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  CustomerSubscriptionCartModel({
    this.id = '',

    this.customer,
    this.shippingAddress,
    this.billingAddress, 

    this.subscription, 
    this.relatedProducts = const [],
    this.selectionSteps = const [],

    this.subtotal = 0,
    this.initialPriceInVAT = 0,
  
    this.vatName = '',
    this.vatPercent = 0,
    this.vat = 0,
    
    this.total = 0,
    this.discount = 0,
    this.grandTotal = 0,

    this.packagings = const [],

    this.createdAt,
    this.updatedAt,
  });

  CustomerSubscriptionCartModel copyWith({
    String? id,
    CustomerModel? customer,
    CustomerShippingAddressModel? shippingAddress,
    CustomerBillingAddressModel? billingAddress,
    PartnerProductSubscriptionModel? subscription,
    List<RelatedProduct>? relatedProducts,
    List<SelectionSteps>? selectionSteps,
    double? subtotal,
    double? initialPriceInVAT,
    String? vatName,
    double? vatPercent,
    double? vat,
    double? total,
    double? discount,
    double? grandTotal,
    List? packagings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CustomerSubscriptionCartModel(
    id: id ?? this.id,
    customer: customer ?? this.customer,
    shippingAddress: shippingAddress ?? this.shippingAddress,
    billingAddress: billingAddress,
    subscription: subscription ?? this.subscription,
    relatedProducts: relatedProducts ?? this.relatedProducts,
    selectionSteps: selectionSteps ?? this.selectionSteps,
    subtotal: subtotal ?? this.subtotal,
    initialPriceInVAT: initialPriceInVAT ?? this.initialPriceInVAT,
    vatName: vatName ?? this.vatName,
    vatPercent: vatPercent ?? this.vatPercent,
    vat: vat ?? this.vat,
    total: total ?? this.total,
    discount: discount ?? this.discount,
    grandTotal: grandTotal ?? this.grandTotal,
    packagings: packagings ?? this.packagings,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory CustomerSubscriptionCartModel.fromJson(Map<String, dynamic> json) => CustomerSubscriptionCartModel(
    id: json['_id'],

    customer: json['customer'] == null || json['customer'] is String? null : CustomerModel.fromJson(json['customer']),

    shippingAddress: json['shippingAddress'] == null || json['shippingAddress'] is String? null : CustomerShippingAddressModel.fromJson(json['shippingAddress']),
    billingAddress: json['billingAddress'] == null || json['billingAddress'] is String? null : CustomerBillingAddressModel.fromJson(json['billingAddress']),
    
    subscription: json['subscription'] == null || json['subscription'] is String? null : PartnerProductSubscriptionModel.fromJson(json['subscription']),
    relatedProducts: json['relatedProducts'] == null || json['relatedProducts'] is String
      ? []: List<RelatedProduct>.from(json['relatedProducts'].where((x) => x is! String).map((x) => RelatedProduct.fromJson(x))),
    selectionSteps: json['selectionSteps'] == null || json['selectionSteps'] is String
      ? []: List<SelectionSteps>.from(json['selectionSteps'].where((x) => x is! String).map((x) => SelectionSteps.fromJson(x))),

    subtotal: json['subtotal'] == null
        ? 0: double.parse(json['subtotal'].toString()),
    initialPriceInVAT: json['initialPriceInVAT'] == null
        ? 0: double.parse(json['initialPriceInVAT'].toString()),
    vatName: json['vatName'],
    vatPercent: json['vatPercent'] == null
      ? 0: double.parse(json['vatPercent'].toString()),
    vat: json['vat'] == null
      ? 0: double.parse(json['vat'].toString()),

    total: json['total'] == null
      ? 0: double.parse(json['total'].toString()),
    discount: json['discount'] == null
      ? 0: double.parse(json['discount'].toString()),
    grandTotal: json['grandTotal'] == null
      ? 0: double.parse(json['grandTotal'].toString()),

    packagings: json["packagings"] ?? [],
      
    createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'customer': customer?.toJson(),
    'shippingAddress': shippingAddress?.toJson(),
    'billingAddress': billingAddress?.toJson(),
    'subscription': subscription?.toJson(),
    'relatedProducts': relatedProducts.isEmpty? [] 
      : List<RelatedProduct>.from(relatedProducts.map((x) => x.toJson())),
    'selectionSteps': selectionSteps.isEmpty? [] 
      : List<SelectionSteps>.from(selectionSteps.map((x) => x.toJson())),
    'subtotal': subtotal,
    'initialPriceInVAT': initialPriceInVAT,
    'vatName': vatName,
    'vatPercent': vatPercent,
    'vat': vat,
    'total': total,
    'discount': discount,
    'grandTotal': grandTotal,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  isValid() => id?.isNotEmpty;

  displayStatus() {
    if(id?.isEmpty == true) return '';
  }

  displayGrandTotal(PartnerShippingFrontendModel? shippingMethod) {
    return max(grandTotal + (shippingMethod?.isValid() == true? (shippingMethod?.price ?? 0): 0), 0);
  }

}


