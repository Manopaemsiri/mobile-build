import 'dart:convert';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';

CustomerCartModel customerCartModelFromJson(String str) =>
  CustomerCartModel.fromJson(json.decode(str));
String customerCartModelToJson(CustomerCartModel model) =>
  json.encode(model.toJson());

class CustomerCartModel {
  CustomerCartModel({
    this.id,
    this.shop,

    this.products = const [],
    
    this.subtotal = 0,
    this.vat = 0,
    this.vatPercent = 7,
    this.discount = 0,
    this.total = 0,

    this.hasDownPayment = 0,
    this.downPayment = 0,
    this.missingPayment = 0,

    this.totalCommission = 0,
    this.pointEarn = 0,
    this.pointEarnStatus = 0,

    this.productGiveawayRule,
    this.receivedCoupons = const [],
  });

  String? id;
  PartnerShopModel? shop;

  List<PartnerProductModel> products;

  double subtotal;
  double vat;
  double vatPercent;
  double discount;
  double total;

  int hasDownPayment;
  double downPayment;
  double missingPayment;

  double totalCommission;
  double pointEarn;
  int pointEarnStatus;

  PartnerProductGiveawayRuleModel? productGiveawayRule;
  List<PartnerProductCouponModel> receivedCoupons;

  factory CustomerCartModel.fromJson(Map<String, dynamic> json) =>
    CustomerCartModel(
      id: json["_id"],
      shop: json["shop"] != null && json["shop"] is! String
        ? PartnerShopModel.fromJson(json["shop"]) 
        : null,

      products: json["products"] != null && json["products"] is! String
        ? List<PartnerProductModel>.from(json["products"]
          .where((x) => x is! String)
          .map((x) => PartnerProductModel.fromJson(x))) 
        : [],

      discount: json["discount"] == null
        ? 0: double.parse(json["discount"].toString()),
      subtotal: json["subtotal"] == null
        ? 0: double.parse(json["subtotal"].toString()),
      vat: json["vat"] == null
        ? 0: double.parse(json["vat"].toString()),
      vatPercent: json["vatPercent"] == null
        ? 0: double.parse(json["vatPercent"].toString()),
      total: json["total"] == null
        ? 0: double.parse(json["total"].toString()),
        
      hasDownPayment: json["hasDownPayment"] ?? 0,
      downPayment: json["downPayment"] == null
        ? 0: double.parse(json["downPayment"].toString()),
      missingPayment: json["missingPayment"] == null
        ? 0: double.parse(json["missingPayment"].toString()),

      totalCommission: json["totalCommission"] == null
        ? 0: double.parse(json["totalCommission"].toString()),
      pointEarn: json["pointEarn"] == null
        ? 0: double.parse(json["pointEarn"].toString()),
      pointEarnStatus: json["pointEarnStatus"] ?? 0,

      productGiveawayRule: json["productGiveawayRule"] != null && json["productGiveawayRule"] is! String
        ? PartnerProductGiveawayRuleModel.fromJson(json["productGiveawayRule"]): null,
      receivedCoupons: json["receivedCoupons"] != null && json["receivedCoupons"] is! String
        ? List<PartnerProductCouponModel>.from(json["receivedCoupons"]
          .where((x) => x is! String)
          .map((x) => PartnerProductCouponModel.fromJson(x))) 
        : [],
    );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "shop": shop?.toJson(),

    "products": List<dynamic>.from(products.map((e) => e.toJson())),

    "subtotal": subtotal,
    "vat": vat,
    "vatPercent": vatPercent,
    "discount": discount,
    "total": total,
    
    "hasDownPayment": hasDownPayment,
    "downPayment": downPayment,
    "missingPayment": missingPayment,

    "totalCommission": totalCommission,
    "pointEarn": pointEarn,
    "pointEarnStatus": pointEarnStatus,

    "productGiveawayRule": productGiveawayRule?.toJson(),
    "receivedCoupons": receivedCoupons.isNotEmpty? List<dynamic>.from(receivedCoupons.map((e) => e.toJson())): [],
  };

  bool isValid() {
    return id != null? true: false;
  }
  bool isValidDownPayment() {
    return isValid() && hasDownPayment == 1 
      && downPayment > 0 && missingPayment > 0;
  }

  String displayDownPayment(LanguageController controller, {bool showSymbol = true, bool trimDigits = false}) {
    if(isValidDownPayment()){
      return priceFormat(downPayment, controller, digits: 2, showSymbol: showSymbol, trimDigits: trimDigits);
    } else {
      return '';
    }
  }
  String displayMissingPayment(LanguageController controller, {bool showSymbol = true, bool trimDigits = false}) {
    if(isValidDownPayment()){
      return priceFormat(missingPayment, controller, digits: 2, showSymbol: showSymbol, trimDigits: trimDigits);
    } else {
      return '';
    }
  }
  
  bool hasShipBySupplier() {
    bool shipBySupplier = false;
    for(var i=0; i<products.length; i++){
      if(products[i].shipBySupplier == 1){
        shipBySupplier = true;
      }
    }
    return shipBySupplier;
  }
  List<PartnerProductModel> shipBySupplierProducts() {
    List<PartnerProductModel> result = [];
    for(var i=0; i<products.length; i++){
      if(products[i].shipBySupplier == 1){
        result.add(products[i]);
      }
    }
    return result;
  }
}
