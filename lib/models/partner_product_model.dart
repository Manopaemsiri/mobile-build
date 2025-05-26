import 'dart:convert';
import 'dart:math';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:html_unescape/html_unescape.dart';

/*
  type
    1 = Individual
    2 = Set

  status :
    -1 = Out of Stock
    0 = Inactive
    1 = Coming soon
    2 = Active
    3 = Clearance
    4 = New
    5 = Featured
    6 = On Sales
*/

PartnerProductModel partnerProductModelFromJson(String str) =>
    PartnerProductModel.fromJson(json.decode(str));
String partnerProductModelToJson(PartnerProductModel model) =>
    json.encode(model.toJson());

class PartnerProductModel {
  PartnerProductModel({
    this.id,
    this.type = 1,

    this.sku = '',
    this.barcode = '',
    this.url = '',

    this.name = '',
    this.shortDescription = '',
    this.description = '',

    this.keywords = '',
    this.specification = '',
    this.youtubeVideoId = '',

    this.category,
    this.subCategory,
    this.brand,

    this.unit = '',
    this.unitLF = '',
    this.unitDescription = '',
    this.unitVariantName = '',

    this.price = 0,
    this.priceInVAT = 0,
    this.memberPrice = 0,
    this.memberPriceInVAT = 0,

    this.partnerCommission = 0,
    this.pointMultiplier = 1,

    this.image,
    this.gallery,

    this.isPackagingReady = 0,
    this.preparingDays = 0,

    this.weight = 0,
    this.width = 0,
    this.length = 0,
    this.height = 0,

    this.salesCount = 0,
    this.status = 0,

    this.productSet = const [],
    this.productSetPriceInVAT = 0,

    this.quantity = 0,

    this.nameEN = '',
    this.shortDescriptionEN = '',
    this.descriptionEN = '',
    this.specificationEN = '',

    this.stock = 0,
    this.stockName,
    this.stockCenter = 0,
    this.stockCenterName,
    this.inCart = 0,
    this.selectedUnit,
    
    this.discountPrice = 0,
    this.discountPriceInVAT = 0,
    this.discountStartAt,
    this.discountEndAt,

    this.salesPrice = 0,
    this.salesPriceInVAT = 0,
    this.totaSalesPrice = 0,
    this.totaSalesPriceInVAT = 0,

    this.vat = 0,
    this.totalVAT = 0,

    this.discount = 0,
    this.discountInVAT = 0,
    this.totalDiscount = 0,
    this.totalDiscountInVAT = 0,

    this.acceptDownPayment = 0,
    this.downPayment = 0,
    this.downPaymentInVAT = 0,
    this.totalDownPayment = 0,
    this.totalDownPaymentInVAT = 0,
    this.missingPayment = 0,
    this.missingPaymentInVAT = 0,

    this.totalCommission = 0,
    this.pointEarn = 0,

    this.shipBySupplier = 0,

    this.eventId = '',
    this.eventName = '',

    this.rating,
    this.ratingCount,

    this.subscriptionInitial = 0,
    this.addPriceInVAT = 0,
  });

  String? id;
  int type;

  String sku;
  String barcode;
  String url;

  String name;
  String shortDescription;
  String description;

  String keywords;
  String specification;
  String youtubeVideoId;

  PartnerProductCategoryModel? category;
  PartnerProductSubCategoryModel? subCategory;
  PartnerProductBrandModel? brand;

  String unit;
  String unitLF;
  String unitDescription;
  String unitVariantName;

  double price;
  double priceInVAT;
  double memberPrice;
  double memberPriceInVAT;

  double partnerCommission;
  double pointMultiplier;

  FileModel? image;
  List<FileModel>? gallery;

  int isPackagingReady;
  int preparingDays;

  double weight;
  double width;
  double length;
  double height;

  int salesCount;
  int status;

  // Product Set
  List<PartnerProductModel> productSet;
  double productSetPriceInVAT; 

  int quantity; 

  String? nameEN;
  String? shortDescriptionEN;
  String? descriptionEN;
  String? specificationEN;

  int stock;
  String? stockName;
  int stockCenter;
  String? stockCenterName;
  int inCart;
  PartnerProductUnitModel? selectedUnit;

  double discountPrice;
  double discountPriceInVAT;
  DateTime? discountStartAt;
  DateTime? discountEndAt;

  double salesPrice;
  double salesPriceInVAT;
  double totaSalesPrice;
  double totaSalesPriceInVAT;

  double vat;
  double totalVAT;

  double discount;
  double discountInVAT;
  double totalDiscount;
  double totalDiscountInVAT;
  
  int acceptDownPayment;
  double downPayment;
  double downPaymentInVAT;
  double totalDownPayment;
  double totalDownPaymentInVAT;
  double missingPayment;
  double missingPaymentInVAT;

  double totalCommission;
  double pointEarn;

  int shipBySupplier;

  String eventId;
  String eventName;

  double? rating;
  int? ratingCount;

  // Subscription
  double subscriptionInitial;
  double addPriceInVAT;

  factory PartnerProductModel.fromJson(Map<String, dynamic> json){
    var unescape = HtmlUnescape();
    return PartnerProductModel(
      id: json["_id"],
      type: json["type"] ?? 1,

      sku: json["sku"] ?? '',
      barcode: json["barcode"] ?? '',
      url: json["url"] ?? '',
      
      name: json["name"]==null? '': unescape.convert(json["name"]),
      shortDescription: json["shortDescription"]==null? '': unescape.convert(json["shortDescription"]),
      description: json["description"]==null? '': unescape.convert(json["description"]),
      
      keywords: json["keywords"] ?? '',
      specification: json["specification"] ?? '',
      youtubeVideoId: json["youtubeVideoId"] ?? '',

      category: json["category"] != null && json["category"] is! String 
        ? PartnerProductCategoryModel.fromJson(json["category"])
        : null,
      subCategory: json["subCategory"] != null && json["subCategory"] is! String
        ? PartnerProductSubCategoryModel.fromJson(json["subCategory"])
        : null,
      brand: json["brand"] != null && json["brand"] is! String
        ? PartnerProductBrandModel.fromJson(json["brand"])
        : null,

      unit: json["unit"] ?? '',
      unitLF: json["unitLF"] ?? '',
      unitDescription: json["unitDescription"] ?? '',
      unitVariantName: json["unitVariantName"] ?? '',

      price: json["price"] == null
        ? 0: double.parse(json["price"].toString()),
      priceInVAT: json["priceInVAT"] == null
        ? 0: double.parse(json["priceInVAT"].toString()),
      memberPrice: json["memberPrice"] == null
        ? 0: double.parse(json["memberPrice"].toString()),
      memberPriceInVAT: json["memberPriceInVAT"] == null
        ? 0: double.parse(json["memberPriceInVAT"].toString()),

      partnerCommission: json["partnerCommission"] == null
        ? 0: double.parse(json["partnerCommission"].toString()),
      pointMultiplier: json["pointMultiplier"] == null
        ? 1: double.parse(json["pointMultiplier"].toString()),

      image: json["image"] == null || json["image"] is String? null : FileModel.fromJson(json["image"]),
      gallery: json["gallery"] == null || json["gallery"] is String? null
        : List<FileModel>.from(json["gallery"].where((x) => x is! String).map((x) => FileModel.fromJson(x))),
      
      isPackagingReady: json["isPackagingReady"] ?? 0,
      preparingDays: json["preparingDays"] ?? 0,

      weight: json["weight"] == null? 0: double.parse(json["weight"].toString()),
      width: json["width"] == null? 0: double.parse(json["width"].toString()),
      length: json["length"] == null? 0: double.parse(json["length"].toString()),
      height: json["height"] == null? 0: double.parse(json["height"].toString()),
      
      salesCount: json["salesCount"] ?? 0,
      status: json["status"] ?? 0,

      productSet: json["productSet"] == null || json["productSet"] is String
        ? []
        : List<PartnerProductModel>.from(json["productSet"].where((x) => x is! String).map((x) => PartnerProductModel.fromJson(x))).toList(),
      productSetPriceInVAT: json["productSetPriceInVAT"] == null
        ? 0: double.parse(json["productSetPriceInVAT"].toString()),     

      quantity: json["quantity"] ?? 0,

      nameEN: json["nameEN"]==null? '': unescape.convert(json["nameEN"]),
      shortDescriptionEN: json["shortDescriptionEN"]==null? '': unescape.convert(json["shortDescriptionEN"]),
      descriptionEN: json["descriptionEN"]==null? '': unescape.convert(json["descriptionEN"]),
      specificationEN: json["specificationEN"] ?? '',

      stock: json["stock"] == null
        ? 0: double.parse(json["stock"].toString()).floor(),
      stockName: json["stockName"],
      stockCenter: json["stockCenter"] == null
        ? 0: double.parse(json["stockCenter"].toString()).floor(),
      stockCenterName: json["stockCenterName"],
      inCart: json["inCart"] ?? 0,
      selectedUnit: json["selectedUnit"] != null && json["selectedUnit"] is! String
        ? PartnerProductUnitModel.fromJson(json["selectedUnit"]): null,

      discountPrice: json["discountPrice"] == null 
        ? 0: double.parse(json["discountPrice"].toString()),
      discountPriceInVAT: json["discountPriceInVAT"] == null 
        ? 0: double.parse(json["discountPriceInVAT"].toString()),
      discountStartAt: json["discountStartAt"] != null && json["discountStartAt"] is String 
        ? DateTime.parse(json["discountStartAt"]): null,
      discountEndAt: json["discountEndAt"] != null && json["discountEndAt"] is String 
        ? DateTime.parse(json["discountEndAt"]): null,

      salesPrice: json["salesPrice"] == null
        ? 0: double.parse(json["salesPrice"].toString()),
      salesPriceInVAT: json["salesPriceInVAT"] == null
        ? 0: double.parse(json["salesPriceInVAT"].toString()),
      totaSalesPrice: json["totaSalesPrice"] == null
        ? 0: double.parse(json["totaSalesPrice"].toString()),
      totaSalesPriceInVAT: json["totaSalesPriceInVAT"] == null
        ? 0: double.parse(json["totaSalesPriceInVAT"].toString()),

      vat: json["vat"] == null? 0: double.parse(json["vat"].toString()),
      totalVAT: json["totalVAT"] == null? 0: double.parse(json["totalVAT"].toString()),

      acceptDownPayment: json["acceptDownPayment"] ?? 0,
      downPayment: json["downPayment"] == null
        ? 0: double.parse(json["downPayment"].toString()),
      downPaymentInVAT: json["downPaymentInVAT"] == null
        ? 0: double.parse(json["downPaymentInVAT"].toString()),
      totalDownPayment: json["totalDownPayment"] == null
        ? 0: double.parse(json["totalDownPayment"].toString()),
      totalDownPaymentInVAT: json["totalDownPaymentInVAT"] == null
        ? 0: double.parse(json["totalDownPaymentInVAT"].toString()),
      missingPayment: json["missingPayment"] == null
        ? 0: double.parse(json["missingPayment"].toString()),
      missingPaymentInVAT: json["missingPaymentInVAT"] == null
        ? 0: double.parse(json["missingPaymentInVAT"].toString()),

      discount: json["discount"] == null
        ? 0: double.parse(json["discount"].toString()),
        
      totalCommission: json["totalCommission"] == null
        ? 0: double.parse(json["totalCommission"].toString()),
      pointEarn: json["pointEarn"] == null
        ? 0: double.parse(json["pointEarn"].toString()),

      shipBySupplier: json["shipBySupplier"] ?? 0,

      eventId: json["eventId"] ?? '',
      eventName: json["eventName"] ?? '',

      rating: json["rating"] != null? double.parse(json["rating"].toString()): null,
      ratingCount: json["ratingCount"] != null? int.parse(json["ratingCount"].toString()): null,

      subscriptionInitial: json["subscriptionInitial"] == null
        ? 0: double.parse(json["subscriptionInitial"].toString()),
      addPriceInVAT: json["addPriceInVAT"] == null
        ? 0: double.parse(json["addPriceInVAT"].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "type": type,
    
    "sku": sku,
    "barcode": barcode,
    "url": url,

    "name": name,
    "shortDescription": shortDescription,
    "description": description,
    
    "keywords": keywords,
    "specification": specification,
    "youtubeVideoId": youtubeVideoId,

    "category": category?.toJson(),
    "subCategory": subCategory?.toJson(),
    "brand": brand?.toJson(),
    
    "unit": unit,
    "unitLF": unitLF,
    "unitDescription": unitDescription,
    "unitVariantName": unitVariantName,

    "price": price,
    "priceInVAT": priceInVAT,
    "memberPrice": memberPrice,
    "memberPriceInVAT": memberPriceInVAT,

    "partnerCommission": partnerCommission,
    "pointMultiplier": pointMultiplier,

    "image": image?.toJson(),
    "gallery": gallery == null? null 
      : List<FileModel>.from(gallery!.map((x) => x.toJson())),

    "isPackagingReady": isPackagingReady,
    "preparingDays": preparingDays,

    "weight": weight,
    "width": width,
    "length": length,
    "height": height,

    "salesCount": salesCount,
    "status": status,

    "productSet": productSet.isEmpty
      ? [] 
      : List<dynamic>.from(productSet.map((x) => x.toJson())),
    "productSetPriceInVAT": productSetPriceInVAT,

    "quantity": quantity,

    "nameEN": nameEN,
    "shortDescriptionEN": shortDescriptionEN,
    "descriptionEN": descriptionEN,
    "specificationEN": specificationEN,

    "stock": stock,
    "stockName": stockName,
    "stockCenter": stockCenter,
    "stockCenterName": stockCenterName,
    "inCart": inCart,
    "selectedUnit": selectedUnit?.toJson(),

    "discountPrice": discountPrice,
    "discountPriceInVAT": discountPriceInVAT,
    "discountStartAt": discountStartAt?.toIso8601String(),
    "discountEndAt": discountEndAt?.toIso8601String(),

    "salesPrice": salesPrice,
    "salesPriceInVAT": salesPriceInVAT,
    "totaSalesPrice": totaSalesPrice,
    "totaSalesPriceInVAT": totaSalesPriceInVAT,

    "vat": vat,
    "totalVAT": totalVAT,
    
    "discount": discount,
    "discountInVAT": discountInVAT,
    "totalDiscount": totalDiscount,
    "totalDiscountInVAT": totalDiscountInVAT,

    "acceptDownPayment": acceptDownPayment,
    "downPayment": downPayment,
    "downPaymentInVAT": downPaymentInVAT,
    "totalDownPayment": totalDownPayment,
    "totalDownPaymentInVAT": totalDownPaymentInVAT,
    "missingPayment": missingPayment,
    "missingPaymentInVAT": missingPaymentInVAT,
    
    "totalCommission": totalCommission,
    "pointEarn": pointEarn,

    "shipBySupplier": shipBySupplier,

    "eventId": eventId,
    "eventName": eventName,

    "rating": rating,
    "ratingCount": ratingCount,
    
    "subscriptionInitial": subscriptionInitial,
    "addPriceInVAT": addPriceInVAT,
  };

  bool isValid() {
    return id != null ? true : false;
  }
  bool isValidDownPayment() {
    return selectedUnit == null
      ? status > 1 && acceptDownPayment == 1 && downPaymentInVAT > 0 
      : selectedUnit!.isValidDownPayment();
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
    if (isValid()) {
      // double temp = discountPriceInVAT *100/100;
      double temp = discountPriceInVAT;
      return (temp * pow(10, 2)).round().toDouble() / pow(10, 2);
    } else {
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

  double getPrice() {
    if (isValid()) {
      // double temp = price * 107/100;
      double temp = priceInVAT;
      return (temp * pow(10, 2)).round().toDouble() / pow(10, 2);
    } else {
      return 0;
    }
  }
  String displayPrice(LanguageController controller, {bool showSymbol = true, bool trimDigits = false}) {
    if (isValid()) {
      return priceFormat(priceInVAT, controller, digits: 2, showSymbol: showSymbol, trimDigits: trimDigits);
    } else {
      return '';
    }
  }
  String displaySetFullSavedPrice(LanguageController controller, {bool showSymbol = true, bool trimDigits = false}) {
    if (isValid()) {
      return priceFormat(productSetPriceInVAT, controller, digits: 2, showSymbol: showSymbol, trimDigits: trimDigits);
    } else {
      return '';
    }
  }
  String displaySetSavedPrice(LanguageController controller, {bool showSymbol = true, bool trimDigits = false}) {
    if (isValid()) {
      return priceFormat(memberPriceInVAT, controller, digits: 2, showSymbol: showSymbol, trimDigits: trimDigits);
    } else {
      return '';
    }
  }

  double getMemberPrice() {
    if (isValid()) {
      double temp = memberPriceInVAT;
      // double temp = memberPrice * 107/100;
      return (temp * pow(10, 2)).round().toDouble() / pow(10, 2);
    } else {
      return 0;
    }
  }
  String displayMemberPrice(LanguageController controller, {bool showSymbol = true, bool trimDigits = false}) {
    if (isValid()) {
      return priceFormat(memberPriceInVAT, controller, digits: 2, showSymbol: showSymbol, trimDigits: trimDigits);
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
  String displaySigninPrice(LanguageController controller, {bool showSymbol = true, bool trimDigits = false}) {
    if (isDiscounted()) {
      return displayDiscountPrice(controller, showSymbol: showSymbol, trimDigits: trimDigits);
    } else {
      return displayMemberPrice(controller, showSymbol: showSymbol, trimDigits: trimDigits);
    }
  }

  double getTotalPriceInVAT() {
    if (isValid()) {
      double temp = totaSalesPriceInVAT + missingPaymentInVAT;
      return (temp * pow(10, 2)).round().toDouble() / pow(10, 2);
    } else {
      return 0;
    }
  }
  String displayTotalPriceInVAT(LanguageController controller, {bool showSymbol = true, bool trimDigits = false}) {
    if(isValid()){
      double temp = totaSalesPriceInVAT + missingPaymentInVAT;
      return priceFormat(temp, controller, digits: 2, showSymbol: showSymbol, trimDigits: trimDigits);
    }else{
      return '';
    }
  }
  String displayFullAmountInVAT(LanguageController controller, {bool showSymbol = true, bool trimDigits = false}) {
    if(isValid() && discountInVAT > 0){
      double temp = discountInVAT;
      // double temp = discount * 107/100;
      temp = (temp * pow(10, 2)).round().toDouble() / pow(10, 2);
      return priceFormat(
        getTotalPriceInVAT() + temp*inCart,
        controller,
        digits: 2,
        showSymbol: showSymbol,
        trimDigits: trimDigits
      );
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
    if(isValid()){
      return priceFormat(downPaymentInVAT, controller, digits: 2, showSymbol: showSymbol, trimDigits: trimDigits);
    }else{
      return '';
    }
  }
  String displayTotalDownPaymentInVAT(LanguageController controller, {bool showSymbol = true, bool trimDigits = false}) {
    if(isValid()){
      double temp = downPaymentInVAT;
      // double temp = downPayment * 107/100;
      temp = (temp * pow(10, 2)).round().toDouble() / pow(10, 2);
      return priceFormat(temp * inCart, controller, digits: 2, showSymbol: showSymbol, trimDigits: trimDigits);
    }else{
      return '';
    }
  }

  String displayWeight() {
    return "${numberFormat(weight)} KG";
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
    } else if(status == 0) {
      return controller.getLang("text_product_status_0");
    }else {
      return controller.getLang("text_default_product_status__1");
    }
  }

  // int maxStock() {
  //   if (selectedUnit == null) {
  //     return stock;
  //   } else{
  //     return (stock / (selectedUnit?.convertedQuantity ?? 1)).floor();
  //   }
  // }

  int getMaxStock() {
    final temp = max(stock, stockCenter);
    if (selectedUnit == null) {
      return temp;
    } else{
      return (temp / (selectedUnit?.convertedQuantity ?? 1)).floor();
    }
  }

  isOutOfStock() {
    if(getMaxStock() <= 0 || status == -1) return true;
    return false;
  }

  PartnerProductStatusModel? productBadge(LanguageController lController, {bool showSelectedUnit = false, bool isCart = false, bool showDiscounted = true}) {
    
    if(isOutOfStock() && !isCart){
      return PartnerProductStatusModel(
        productStatus: status,
        text: "Out of Stock",
        textColor: kWhiteColor.toString(), 
        textBgColor: kGrayColor.toString(),

        textColor2: kWhiteColor,
        textBgColor2: kGrayColor
      );
    }else if(isClearance()){
      return PartnerProductStatusModel(
        productStatus: status,
        text: "Clearance",
        textColor: kWhiteColor.toString(),
        textBgColor: kGrayColor.toString(),

        textColor2: kWhiteColor,
        textBgColor2: kGrayColor
      );
    }else if(isSetSaved()){
      return PartnerProductStatusModel(
        productStatus: status,
        text: "-${setSavedPercent()} %",
        textColor: kWhiteColor.toString(),
        textBgColor: kAppColor.toString(),
        textColor2: kWhiteColor,
        textBgColor2: kAppColor
      );
    }else if((isDiscounted() || showSelectedUnit) && showDiscounted){
      return PartnerProductStatusModel(
        productStatus: status,
        text: "-${!showSelectedUnit? discountPercent(): selectedUnit?.discountPercent()} %",
        textColor: kWhiteColor.toString(),
        textBgColor: kAppColor.toString(),
        textColor2: kWhiteColor,
        textBgColor2: kAppColor
      );
    }else if(status == 5){
      return PartnerProductStatusModel(
        productStatus: status,
        text: "Featured",
        textColor: kWhiteColor.toString(),
        textBgColor: kBlueColor.toString(),
        textColor2: kWhiteColor,
        textBgColor2: kBlueColor
      );
    }else if(status == 4){
      return PartnerProductStatusModel(
        productStatus: status,
        text: "New",
        textColor: kWhiteColor.toString(),
        textBgColor: kAppColor.toString(),
        textColor2: kWhiteColor,
        textBgColor2: kAppColor
      );
    }else if(status == 1) {
      return PartnerProductStatusModel(
        productStatus: status,
        text: "Coming\nSoon",
        textColor: kDarkColor.toString(),
        textBgColor: kWhiteColor.withOpacity(0.45).toString(),
        textColor2: kDarkColor,
        textBgColor2: kWhiteColor.withOpacity(0.45)
      );
    }
    return null;
  }

  isSetSaved() {
    if(isValid() && type == 2 && productSet.isNotEmpty) return memberPriceInVAT < productSetPriceInVAT;
    return false;
  }
  setSavedPercent() {
    if(isValid() && type == 2 && productSet.isNotEmpty){
      return ((productSetPriceInVAT - memberPriceInVAT) / productSetPriceInVAT * 100).round();
    }
    return 0;
  }
}