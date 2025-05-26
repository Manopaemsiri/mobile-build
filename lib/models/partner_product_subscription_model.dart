import 'dart:convert';

import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:html_unescape/html_unescape.dart';

import '../controller/language_controller.dart';

/*
  channel :
    C2U
    STORE

  recurringType : Number
    1 = Every X Days
    2 = Every X Months
    3 = Every X Years

  status :
    0 = ปิดใช้งาน
    1 = เปิดใช้งาน
*/

PartnerProductSubscriptionModel partnerProductSubscriptionModelFromJson(String str) 
  => PartnerProductSubscriptionModel.fromJson(json.decode(str));

String partnerProductSubscriptionModelToJson(PartnerProductSubscriptionModel data) 
  => json.encode(data.toJson());

class PartnerProductSubscriptionModel {
  final String id;
  final String channel;
  final String name;
  final String description;
  final String content;
  final String agreement;

  final double priceInVAT;
  final double discountPriceInVAT;
  final DateTime? discountStartAt;
  final DateTime? discountEndAt;

  final int recurringType;
  final int recurringInterval;
  final int recurringCount;

  final int hasRelatedProducts;
  final double relatedCredit;
  final List<RelatedProduct> relatedProducts;

  final List<SelectionSteps> selectionSteps;

  final FileModel? image;
  final List<FileModel>? gallery;

  final int status;
  final int order;

  final List<PartnerProductModel> packageProducts;

  PartnerProductSubscriptionModel({
    this.id = '',
    this.channel = 'C2U',
    this.name = '',
    this.description = '',
    this.content = '',
    this.agreement = '',

    this.priceInVAT = 0,
    this.discountPriceInVAT = 0,
    this.discountStartAt,
    this.discountEndAt,

    this.recurringType = 2,
    this.recurringInterval = 1,
    this.recurringCount = 12,

    this.hasRelatedProducts = 0,
    this.relatedCredit = 0,
    this.relatedProducts = const [],

    this.selectionSteps = const [],

    this.image,
    this.gallery = const [],
    this.status = 0,
    this.order = 1000,

    this.packageProducts = const [],
  });

  PartnerProductSubscriptionModel copyWith({
    String? id,
    String? channel,
    String? name,
    String? description,
    String? content,
    String? agreement,
    double? priceInVAT,
    double? discountPriceInVAT,
    DateTime? discountStartAt,
    DateTime? discountEndAt,
    int? recurringType,
    int? recurringInterval,
    int? recurringCount,
    int? hasRelatedProducts,
    double? relatedCredit,
    List<RelatedProduct>? relatedProducts,
    List<SelectionSteps>? selectionSteps,
    FileModel? image,
    List<FileModel>? gallery,
    int? status,
    int? order,
    List<PartnerProductModel>? packageProducts
  }) => PartnerProductSubscriptionModel(
    id: id ?? this.id,
    channel: channel ?? this.channel,
    name: name ?? this.name,
    description: description ?? this.description,
    content: content ?? this.content,
    agreement: agreement ?? this.agreement,
    priceInVAT: priceInVAT ?? this.priceInVAT,
    discountPriceInVAT: discountPriceInVAT ?? this.discountPriceInVAT,
    discountStartAt: discountStartAt ?? this.discountStartAt,
    discountEndAt: discountEndAt ?? this.discountEndAt,
    recurringType: recurringType ?? this.recurringType,
    recurringInterval: recurringInterval ?? this.recurringInterval,
    recurringCount: recurringCount ?? this.recurringCount,
    hasRelatedProducts: hasRelatedProducts ?? this.hasRelatedProducts,
    relatedCredit: relatedCredit ?? this.relatedCredit,
    relatedProducts: relatedProducts ?? this.relatedProducts,
    selectionSteps: selectionSteps ?? this.selectionSteps,
    image: image ?? this.image,
    gallery: gallery ?? this.gallery,
    status: status ?? this.status,
    order: order ?? this.order,
    packageProducts: packageProducts ?? this.packageProducts,
  );

  factory PartnerProductSubscriptionModel.fromJson(Map<String, dynamic> json) {
    var unescape = HtmlUnescape();
    return PartnerProductSubscriptionModel(
      id: json['_id'],
      channel: json['channel'] ?? '',
      name: json['name'] == null? '': unescape.convert(json['name']),
      description: json['description'] == null? '': unescape.convert(json['description']),
      content: json['content'] == null
        ? '': json['content'].toString().trim(),
      agreement: json['agreement'] == null
        ? '': json['agreement'].toString().trim(),
      
      priceInVAT: json['priceInVAT'] == null
        ? 0: double.parse(json['priceInVAT'].toString()),
      discountPriceInVAT: json['discountPriceInVAT'] == null
        ? 0: double.parse(json['discountPriceInVAT'].toString()),
      discountStartAt: json['discountStartAt'] != null && json['discountStartAt'] is String 
        ? DateTime.parse(json['discountStartAt']): null,
      discountEndAt: json['discountEndAt'] != null && json['discountEndAt'] is String 
        ? DateTime.parse(json['discountEndAt']): null,
      
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

      image: json['image'] == null || json['image'] is String? null : FileModel.fromJson(json['image']),
      gallery: json['gallery'] == null || json['gallery'] is String? null
        : List<FileModel>.from(json['gallery'].where((x) => x is! String).map((x) => FileModel.fromJson(x))),

      status: json['status'] ?? 0,
      order: json['order'] ?? 1000,

      packageProducts: json['packageProducts'] == null || json['packageProducts'] is String
        ? []: List<PartnerProductModel>.from(json['packageProducts'].where((x) => x is! String).map((x) => PartnerProductModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'channel': channel,
    'name': name,
    'description': description,
    'content': content,
    'agreement': agreement,
    'priceInVAT': priceInVAT,
    'discountPriceInVAT': discountPriceInVAT,
    'discountStartAt': discountStartAt?.toIso8601String(),
    'discountEndAt': discountEndAt?.toIso8601String(),
    'recurringType': recurringType,
    'recurringInterval': recurringInterval,
    'recurringCount': recurringCount,
    'hasRelatedProducts': hasRelatedProducts,
    'relatedCredit': relatedCredit,
    // 'relatedProducts': relatedProducts.isEmpty? [] 
    //   : List<RelatedProduct>.from(relatedProducts.map((x) => x.toJson())),
    // 'selectionSteps': selectionSteps.isEmpty? [] 
    //   : List<SelectionSteps>.from(selectionSteps.map((x) => x.toJson())),
    'image': image?.toJson(),
    // 'gallery': gallery == null? [] 
    //   : List<FileModel>.from(gallery!.map((x) => x.toJson())),
    'status': status,
    'order': order,
  };

  isValid() => id.isNotEmpty == true;

  bool isDiscounted() => status == 6 && priceInVAT > discountPriceInVAT; 

  String displayDiscountPrice(LanguageController controller, {bool showSymbol = true, bool trimDigits = false}) {
    if (isValid()) {
      return priceFormat(discountPriceInVAT, controller, digits: 2, showSymbol: showSymbol, trimDigits: trimDigits);
    } else {
      return '';
    }
  }
  
  String displayPrice(LanguageController controller, {bool showSymbol = true, bool trimDigits = false}) {
    if (isValid()) {
      return priceFormat(priceInVAT, controller, digits: 2, showSymbol: showSymbol, trimDigits: trimDigits);
    } else {
      return '';
    }
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

  String diaplayPrice(LanguageController lController){
    double price = priceInVAT;
    if(discountPriceInVAT > 0) price = discountPriceInVAT;

    String text = lController.getLang('text_subscription_price')
    .replaceFirst('_VALUE_', numberFormat(price))
    .replaceFirst('_VALUE2_', displayRecurringTypeName(lController));

    return text;
  }

  String diaplayContract(LanguageController lController){
    String text = lController.getLang('text_subscription_contract')
    .replaceFirst('_VALUE_', '$recurringCount')
    .replaceFirst('_VALUE2_', displayRecurringTypeName(lController));

    return text;
  }
  
}



class RelatedProduct {
  final String? id;
  final PartnerProductModel? product;
  final PartnerProductUnitModel? unit;
  int quantity;
  int inCart;
  final double credit;
  final double addPriceInVAT;

  RelatedProduct({
    this.id,
    this.product,
    this.unit,
    this.quantity = 1,
    this.inCart = 1,
    this.credit = 1,
    this.addPriceInVAT = 0,
  });

  RelatedProduct copyWith({
    String? id,
    PartnerProductModel? product,
    PartnerProductUnitModel? unit,
    int? quantity,
    int? inCart,
    double? credit,
    double? addPriceInVAT,
  }) => RelatedProduct(
    id: id ?? this.id,
    product: product ?? this.product,
    unit: unit ?? this.unit,
    quantity: quantity ?? this.quantity,
    inCart: inCart ?? this.inCart,
    credit: credit ?? this.credit,
    addPriceInVAT: addPriceInVAT ?? this.addPriceInVAT,
  );

  factory RelatedProduct.fromJson(Map<String, dynamic> json) => RelatedProduct(
    id: json['_id'],
    product: json['product'] == null || json['product'] is String? null: PartnerProductModel.fromJson(json['product']),
    unit: json['unit'] == null || json['unit'] is String? null: PartnerProductUnitModel.fromJson(json['unit']),
    quantity: json['quantity'] == null? 1: int.parse(json['quantity'].toString()),
    inCart: json['inCart'] == null? 1: int.parse(json['inCart'].toString()),
    credit: json['credit'] == null? 1: double.parse(json['credit'].toString()),
    addPriceInVAT: json['addPriceInVAT'] == null? 0: double.parse(json['addPriceInVAT'].toString()),
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'product': product?.toJson(),
    'unit': unit?.toJson(),
    'quantity': quantity,
    'inCart': inCart,
    'credit': credit,
    'addPriceInVAT': addPriceInVAT,
  };
}

/*
  type: int
    0 related product
    1 product
*/
class SelectionSteps {
  final String? id;
  final String name;
  final FileModel? icon;
  final double credit;
  final int order;
  final List<RelatedProduct> products;
  final int type;

  SelectionSteps({
    this.id,
    this.name = '',
    this.icon,
    this.credit = 1,
    this.order = 1000,
    this.products = const [],
    this.type = 1,
  });

  SelectionSteps copyWith({
    String? id,
    String? name,
    FileModel? icon,
    double? credit,
    int? order,
    List<RelatedProduct>? products,
    int? type,
  }) => SelectionSteps(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    credit: credit ?? this.credit,
    order: order ?? this.order,
    products: products ?? this.products,
    type: type ?? this.type,
  );

  factory SelectionSteps.fromJson(Map<String, dynamic> json) => SelectionSteps(
    id: json['_id'],
    name: json['name'],
    icon: json['icon'] == null || json['icon'] is String? null : FileModel.fromJson(json['icon']),
    order: json['order'] ?? 1000,
    credit: json['credit'] == null
      ? 0: double.parse(json['credit'].toString()),
    products: json['products'] == null || json['products'] is String
      ? []: List<RelatedProduct>.from(json['products'].where((x) => x is! String).map((x) => RelatedProduct.fromJson(x))),
    type: json['type'] ?? 1,
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'icon': icon?.toJson(),
    'credit': credit,
    'order': order,
    'products': products.isEmpty
      ? []: products.map((x) => x.toJson()).toList(),
    'type': type,
  };
}