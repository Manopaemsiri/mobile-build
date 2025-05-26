import 'dart:convert';
import 'dart:math';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/utils/index.dart';

/*
  status :
    0 = Inactive
    2 = Active
    3 = Clearance
    6 = On Sales
*/

PartnerProductUnitModel partnerProductUnitModelFromJson(String str) =>
  PartnerProductUnitModel.fromJson(json.decode(str));
String partnerProductUnitModelToJson(PartnerProductUnitModel model) =>
  json.encode(model.toJson());

class PartnerProductUnitModel {
  PartnerProductUnitModel({
    this.id,
    this.productId,

    this.sku = '',
    this.barcode = '',

    this.unit = '',
    this.unitLF = '',
    this.unitDescription = '',

    this.convertedQuantity = 1,

    this.price = 0,
    this.priceInVAT = 0,
    this.memberPrice = 0,
    this.memberPriceInVAT = 0,

    this.isPackagingReady = 0,

    this.weight = 0,
    this.width = 0,
    this.length = 0,
    this.height = 0,

    this.status = 0,
    
    this.stock = 0,

    this.discountPrice = 0,
    this.discountPriceInVAT = 0,
    this.discountStartAt,
    this.discountEndAt,
    
    this.acceptDownPayment = 0,
    this.downPayment = 0,
    this.downPaymentInVAT = 0,
  });

  String? id;
  String? productId;

  String sku;
  String barcode;

  String unit;
  String unitLF;
  String unitDescription;

  int convertedQuantity;

  double price;
  double priceInVAT;
  double memberPrice;
  double memberPriceInVAT;

  int isPackagingReady;

  double weight;
  double width;
  double length;
  double height;

  int status;

  int stock;

  double discountPrice;
  double discountPriceInVAT;
  DateTime? discountStartAt;
  DateTime? discountEndAt;
  
  int acceptDownPayment;
  double downPayment;
  double downPaymentInVAT;

  factory PartnerProductUnitModel.fromJson(Map<String, dynamic> json) => PartnerProductUnitModel(
    id: json["_id"],
    productId: json["productId"] ?? '',

    sku: json["sku"] ?? '',
    barcode: json["barcode"] ?? '',

    unit: json["unit"] ?? '',
    unitLF: json["unitLF"] ?? '',
    unitDescription: json["unitDescription"] ?? '',

    convertedQuantity: json["convertedQuantity"] ?? 1,

    price: json["price"] == null
      ? 0: double.parse(json["price"].toString()),
    priceInVAT: json["priceInVAT"] == null
      ? 0: double.parse(json["priceInVAT"].toString()),
    memberPrice: json["memberPrice"] == null
      ? 0: double.parse(json["memberPrice"].toString()),
    memberPriceInVAT: json["memberPriceInVAT"] == null
      ? 0: double.parse(json["memberPriceInVAT"].toString()),
      
    isPackagingReady: json["isPackagingReady"] ?? 0,

    weight: json["weight"] == null? 0: double.parse(json["weight"].toString()),
    width: json["width"] == null? 0: double.parse(json["width"].toString()),
    length: json["length"] == null? 0: double.parse(json["length"].toString()),
    height: json["height"] == null? 0: double.parse(json["height"].toString()),

    status: json["status"] ?? 0,
    
    stock: json["stock"] == null
      ? 0: double.parse(json["stock"].toString()).floor(),

    discountPrice: json["discountPrice"] == null 
      ? 0: double.parse(json["discountPrice"].toString()),
    discountPriceInVAT: json["discountPriceInVAT"] == null 
      ? 0: double.parse(json["discountPriceInVAT"].toString()),
    discountStartAt: json["discountStartAt"] != null && json["discountStartAt"].runtimeType == String 
      ? DateTime.parse(json["discountStartAt"]): null,
    discountEndAt: json["discountEndAt"] != null && json["discountEndAt"].runtimeType == String 
      ? DateTime.parse(json["discountEndAt"]): null,
      
    acceptDownPayment: json["acceptDownPayment"] ?? 0,
    downPayment: json["downPayment"] == null
      ? 0: double.parse(json["downPayment"].toString()),
    downPaymentInVAT: json["downPaymentInVAT"] == null
      ? 0: double.parse(json["downPaymentInVAT"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "productId": productId,

    "sku": sku,
    "barcode": barcode,

    "unit": unit,
    "unitLF": unitLF,
    "unitDescription": unitDescription,

    "convertedQuantity": convertedQuantity,

    "price": price,
    "priceInVAT": priceInVAT,
    "memberPrice": memberPrice,
    "memberPriceInVAT": memberPriceInVAT,

    "isPackagingReady": isPackagingReady,

    "weight": weight,
    "width": width,
    "length": length,
    "height": height,

    "status": status,

    "stock": stock,

    "discountPrice": discountPrice,
    "discountPriceInVAT": discountPriceInVAT,
    "discountStartAt": discountStartAt == null? null: discountStartAt!.toIso8601String(),
    "discountEndAt": discountEndAt == null? null: discountEndAt!.toIso8601String(),
  
    "acceptDownPayment": acceptDownPayment,
    "downPayment": downPayment,
    "downPaymentInVAT": downPaymentInVAT,
  };

  bool isValid() {
    return id != null? true: false;
  }
  bool isValidDownPayment() {
    return status > 1 && acceptDownPayment == 1 && downPaymentInVAT > 0;
  }

  bool isClearance() {
    return isValid() && status == 3;
  }
  bool isOnSales() {
    return isValid() && status == 6;
  }
  bool isDiscounted() {
    return (isClearance() || isOnSales()) && discountPriceInVAT < memberPriceInVAT;
  }

  int discountPercent() {
    if (isDiscounted()) {
      return ((memberPriceInVAT - discountPriceInVAT) *100 /memberPriceInVAT).round();
    } else {
      return 0;
    }
  }
  double getDiscountPrice() {
    if(isValid()){
      double temp = discountPriceInVAT;
      // double temp = discountPrice * 107/100;
      return (temp * pow(10, 2)).round().toDouble() / pow(10, 2);
    }else{
      return 0;
    }
  }
  String displayDiscountPrice(LanguageController controller, {bool showSymbol = true, bool trimDigits = false}) {
    if (isValid()) {
      return priceFormat(discountPriceInVAT, controller, digits: 2, showSymbol: showSymbol, trimDigits: trimDigits);
    } else {
      return '';
    }
  }

  double signinPrice() {
    if(isDiscounted()) {
      return getDiscountPrice();
    } else {
      return getMemberPrice();
    }
  }
  String displaySigninPrice(LanguageController controller, {bool showSymbol = true}) {
    if (isDiscounted()) {
      return displayDiscountPrice(controller, showSymbol: showSymbol);
    } else {
      return displayMemberPrice(controller, showSymbol: showSymbol);
    }
  }

  double getPrice() {
    if(isValid()){
      // double temp = price * 107/100;
      double temp = priceInVAT;
      return (temp * pow(10, 2)).round().toDouble() / pow(10, 2);
    }else{
      return 0;
    }
  }
  String displayPrice(LanguageController controller, {bool showSymbol = true, bool trimDigits = false}) {
    if(isValid()){
      return priceFormat(priceInVAT, controller, digits: 2, showSymbol: showSymbol, trimDigits: trimDigits);
    }else{
      return '';
    }
  }
  
  double getMemberPrice() {
    if(isValid()){
      // double temp = memberPrice * 107/100;
      double temp = memberPriceInVAT;
      return (temp * pow(10, 2)).round().toDouble() / pow(10, 2);
    }else{
      return 0;
    }
  }
  String displayMemberPrice(LanguageController controller, {bool showSymbol = true, bool trimDigits = false}) {
    if(isValid()){
      return priceFormat(memberPriceInVAT, controller, digits: 2, showSymbol: showSymbol, trimDigits: trimDigits);
    }else{
      return '';
    }
  }

  double getDownPayment() {
    if(isValid()){
      // double temp = downPayment * 107/100;
      double temp = downPaymentInVAT;
      return (temp * pow(10, 2)).round().toDouble() / pow(10, 2);
    }else{
      return 0;
    }
  }
  String displayDownPayment(LanguageController controller, {bool showSymbol = true, bool trimDigits = false}) {
    if (isValid()) {
      return priceFormat(downPaymentInVAT, controller, digits: 2, showSymbol: showSymbol, trimDigits: trimDigits);
    } else {
      return '';
    }
  }

  String displayWeight() {
    return numberFormat(weight);
  }
  String displayDimension() {
    return "${numberFormat(width, digits: 1)} x ${numberFormat(length, digits: 1)} x ${numberFormat(height, digits: 1)} CM\u00B3";
  }
  
  String displayStatus(LanguageController controller){
    if (status == 6) {
      return controller.getLang("text_product_status_6");
    } else if (status == 5) {
      return controller.getLang("text_product_status_5");
    } else if (status == 4) {
      return controller.getLang("text_product_status_4");
    } else if (status == 3) {
      return controller.getLang("text_product_status_3");
    } else if (status == 2) {
      return controller.getLang("text_product_status_2");
    } else if (status == 1) {
      return controller.getLang("text_product_status_1");
    } else {
      return controller.getLang("text_product_status_0");
    }
  }
}
