import 'dart:math';

import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:html_unescape/html_unescape.dart';

/*
  channel : String
    - C2U
    - Store

  limitCustomerFrequency
    0 = ต่อคูปอง
    1 = ต่อวัน
    2 = ต่อสัปดาห์
    3 = ต่อเดือน
    4 = ต่อปี

  type : Number
    1 = (Before VAT) Flat rate / percentage discount
      - minimumPrice
      - maximumPrice
      - discountType
          1 = Flat rate
          2 = Percentage
      - discount
      - availableType : Number
          1 = All products
          2 = Include products
          3 = Exclude products
          4 = Include product categories
          5 = Exclude product categories
      - discountRules : Array
          discountRule : Object
            productId : String
            unitId : String
    2 = (Before VAT) Buy X items get Y with percent discount
      - discountType
          1 = Flat rate
          2 = Percentage
      - discount
      - discountRules : Array
          discountRule : Object
            buy : Object
              productId : String
              unitId : String
              quantity : Number
            discount : Object
              productId : String
              unitId : String
              quantity : Number
    3 = (After VAT) Cash Reward
      - discountType
          1 = Grand Total Discount
          2 = Missing Payment Discount
    4 = (Before VAT) Product Set Discount
      - allowCustomDownPayment : Number
          0 = No
          1 = Yes
      - customDownPayments : Array
          customDownPayment : Number
      - discountRules : Array
          discountRule : Object
            buys : Array
              buy : Object
                productId : String
                unitId : String
                quantity : Number
            salesPriceInVAT : Number
            installmentPriceInVAT : Number
    5 = (Before VAT) Step Discount
      - discountRules : Array
          discountRule : Object
            discountType : Number
              1 = Flat rate
              2 = Percentage
            discount
            maximumDiscount
            availableType : Number
              1 = All products
              2 = Include products
              3 = Exclude products
              4 = Include product categories
              5 = Exclude product categories
            rules : Array
              rule : Object
                availableType = 2, 3
                  productId : String
                  unitId : String
                availableType = 4, 5
                  categoryId : String

  status
    0 = Inactive
    1 = Active
    
  isPersonal : Number
    0 = No
    1 = Yes

  availability : Number
    0  = ไม่สามารถใช้งานได้
    1  = คูปองหมดแล้ว
    2  = คุณได้ใช้คูปองเต็มโควต้าแล้ว
    3  = ยังไม่ถึงเวลาการใช้คูปอง
    4  = สิ้นสุดเวลาการใช้คูปอง
    5  = ร้านค้าไม่ร่วมรายการ
    6  = สินค้าในตะกร้าไม่เข้าเงื่อนไข
    7  = ระดับของคุณไม่ร่วมรายการ
    8  = สั่งซื้อขั้นต่ำไม่ถึงที่กำหนด
    9  = สั่งซื้อสูงสุดเกินที่กำหนด
    10 = มีประเภทสินค้าในตะกร้าที่ไม่ร่วมรายการ
    11 = มีสินค้าในตะกร้าที่ไม่ร่วมรายการ
    12 = สินค้าในตะกร้าไม่เข้าเงื่อนไข
    13 = พื้นที่จัดส่งไม่ร่วมรายการ
    99 = ใช้งานได้
*/

class PartnerProductCouponModel {
  PartnerProductCouponModel({
    this.id,
    this.channel = 'C2U',

    this.code = '',
    this.name = '',
    this.shortDescription = '',
    this.description = '',
    this.image,

    this.quantity = 0,
    this.leftQuantity = 0,
    this.limitPerCustomer = 0,
    this.limitCustomerFrequency = 0,

    this.startAt,
    this.endAt,
    this.status = 0,
    this.isRedeemPoints = 0,
    this.redeemPoints = 0,
    this.type = 1,
    this.minimumOrder,
    this.maximumOrder,
    this.discountType = 1,
    this.discount = 0,
    this.maximumDiscount,

    this.availableType = 1,
    this.products = const [],
    this.productCategories = const [],

    this.forAllPartnerShops = 1,
    this.forPartnerShops = const [],
    this.forAllCustomerTiers = 1,
    this.forCustomerTiers = const [],
    this.forAllProvinces = 0,
    this.forProvinces = const [],

    this.createdAt,
    this.updatedAt,

    // Customer Checkout
    this.isPersonal = 0,
    this.availability = 0,
    this.actualDiscount = 0,
    this.missingPaymentDiscount = 0,
    this.diffInstallmentDiscount = 0,

    this.allowCustomDownPayment = 0,
    this.customDownPayments = const [],
  });

  String? id;
  String channel;

  String code;
  String name;
  String shortDescription;
  String description;

  FileModel? image;
  int quantity;
  int leftQuantity;
  int limitPerCustomer;
  int limitCustomerFrequency;
  
  DateTime? startAt;
  DateTime? endAt;

  int status;
  int isRedeemPoints;
  int redeemPoints;
  int type;
  double? minimumOrder;
  double? maximumOrder;
  int discountType;
  double discount;
  double? maximumDiscount;

  int availableType;
  List<PartnerProductModel> products;
  List<PartnerProductCategoryModel> productCategories;

  int forAllPartnerShops;
  List<PartnerShopModel> forPartnerShops;
  int forAllCustomerTiers;
  List<CustomerTierModel> forCustomerTiers;
  int forAllProvinces;
  List<ProvinceModel> forProvinces;

  DateTime? updatedAt;
  DateTime? createdAt;

  int isPersonal;
  int availability;
  double actualDiscount;
  double missingPaymentDiscount;
  double diffInstallmentDiscount;

  int allowCustomDownPayment;
  List<double> customDownPayments;
  
  factory PartnerProductCouponModel.fromJson(Map<String, dynamic> json){
    var unescape = HtmlUnescape();
    bool isValidList(List? list) {
      if(list == null || list.isEmpty){
        return false;
      }else{
        if(list[0] is String){
          return false;
        }else{
          return true;
        }
      }
    }
    return PartnerProductCouponModel(
      id: json["_id"],
      channel: json["channel"] ?? 'C2U',
      code: json["code"] ?? '',

      name: json["name"]==null? '': unescape.convert(json["name"]),
      shortDescription: json["shortDescription"]==null? '': unescape.convert(json["shortDescription"]),
      description: json["description"]==null? '': unescape.convert(json["description"]),

      image: json["image"] == null || json["image"] is String
        ? null : FileModel.fromJson(json["image"]),
      
      quantity: json["quantity"] ?? 0,
      leftQuantity: json["leftQuantity"] ?? 0,
      limitPerCustomer: json["limitPerCustomer"] ?? 0,
      limitCustomerFrequency: json["limitCustomerFrequency"] ?? 0,
      
      startAt: json["startAt"] == null
        ? null: DateTime.parse(json["startAt"]),
      endAt: json["endAt"] == null
        ? null: DateTime.parse(json["endAt"]),

      status: json["status"] ?? 0,
      isRedeemPoints: json["isRedeemPoints"] ?? 0,
      redeemPoints: json["redeemPoints"] != null
        ? json["redeemPoints"] > pow(2, 53) - 1
          ? 999999999999999
          : json["redeemPoints"].toInt()
        : 0,
      type: json["type"] ?? 0,
      minimumOrder: json["minimumOrder"] == null
        ? null: double.parse(json["minimumOrder"].toString()),
      maximumOrder: json["maximumOrder"] == null
        ? null: double.parse(json["maximumOrder"].toString()),
      discountType: json["discountType"] ?? 1,
      discount: json["discount"] == null
        ? 0: double.parse(json["discount"].toString()),
      maximumDiscount: json["maximumDiscount"] == null
        ? null: double.parse(json["maximumDiscount"].toString()),

      availableType: json["availableType"] ?? 0,
      products: !isValidList(json["products"])? [] 
        : List<PartnerProductModel>.from(json["products"]
          .where((x) => x is! String)
          .map((x) => PartnerProductModel.fromJson(x))),
      productCategories: !isValidList(json["productCategories"])? [] 
        : List<PartnerProductCategoryModel>.from(json["productCategories"]
          .where((x) => x is! String)
          .map((x) => PartnerProductCategoryModel.fromJson(x))),

      forAllPartnerShops: json["forAllPartnerShops"] ?? 0,
      forPartnerShops: !isValidList(json["forPartnerShops"])? []
        : List<PartnerShopModel>.from(json["forPartnerShops"]
          .where((x) => x is! String)
          .map((x) => PartnerShopModel.fromJson(x))),
      forAllCustomerTiers: json["forAllCustomerTiers"] ?? 0,
      forCustomerTiers: !isValidList(json["forCustomerTiers"])? []
        : List<CustomerTierModel>.from(json["forCustomerTiers"]
          .where((x) => x is! String)
          .map((x) => CustomerTierModel.fromJson(x))),
      forAllProvinces: json["forAllProvinces"] ?? 0,
      forProvinces: json['forProvinces'] == null || (json['forProvinces'] is String)? []
        : List<ProvinceModel>.from(json['forProvinces']
          .where((x) => x is! String)
          .map((x) => ProvinceModel.fromJson(x))),

      updatedAt: json["updatedAt"] == null
        ? null: DateTime.parse(json["updatedAt"]),
      createdAt: json["createdAt"] == null
        ? null: DateTime.parse(json["createdAt"]),

      isPersonal: json["isPersonal"] ?? 0,
      availability: json["availability"] ?? 0,
      actualDiscount: json["actualDiscount"] == null
        ? 0: double.parse(json["actualDiscount"].toString()),
      missingPaymentDiscount: json["missingPaymentDiscount"] == null
        ? 0: double.parse(json["missingPaymentDiscount"].toString()),
      diffInstallmentDiscount: json["diffInstallmentDiscount"] == null
        ? 0: double.parse(json["diffInstallmentDiscount"].toString()),

      allowCustomDownPayment: json["allowCustomDownPayment"] ?? 0,
      customDownPayments: json["customDownPayments"] == null || json["customDownPayments"] is String
        ? []: List<double>.from(json["customDownPayments"].map((x) => double.parse(x.toString()))),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "channel": channel,
    
    "code": code,
    "name": name,
    "shortDescription": shortDescription,
    "description": description,

    "image": image?.toJson(),
    "quantity": quantity,
    "leftQuantity": leftQuantity,
    "limitPerCustomer": limitPerCustomer,
    "limitCustomerFrequency": limitCustomerFrequency,
    
    "startAt": startAt == null? null: startAt!.toIso8601String(),
    "endAt": endAt == null? null: endAt!.toIso8601String(),

    "status": status,
    "isRedeemPoints": isRedeemPoints,
    "redeemPoints": redeemPoints,
    "type": type,
    "minimumOrder": minimumOrder,
    "maximumOrder": maximumOrder,
    "discountType": discountType,
    "discount": discount,
    "maximumDiscount": maximumDiscount,

    "availableType": availableType,
    "products": List<PartnerProductModel>
      .from(products.map((x) => x.toJson())),
    "productCategories": List<PartnerProductCategoryModel>
      .from(productCategories.map((x) => x.toJson())),

    "forAllPartnerShops": forAllPartnerShops,
    "forPartnerShops": List<PartnerShopModel>
      .from(forPartnerShops.map((x) => x.toJson())),
    "forAllCustomerTiers": forAllCustomerTiers,
    "forCustomerTiers": List<CustomerTierModel>
      .from(forCustomerTiers.map((x) => x.toJson())),
      
    "forAllProvinces": forAllProvinces,
    'forProvinces': forProvinces.isEmpty? []
      : forProvinces.map((e) => e.toJson()).toList(),

    "updatedAt": updatedAt == null? null: updatedAt!.toIso8601String(),
    "createdAt": createdAt == null? null: createdAt!.toIso8601String(),
      
    "isPersonal": isPersonal,
    "availability": availability,
    "actualDiscount": actualDiscount,
    "missingPaymentDiscount": missingPaymentDiscount,
    "diffInstallmentDiscount": diffInstallmentDiscount,

    "allowCustomDownPayment": allowCustomDownPayment,
    "customDownPayments": customDownPayments.isEmpty
      ? null: List<double>.from(customDownPayments.map((e) => e)),
  };

  bool isValid() {
    return id != null? true: false;
  }
  bool isAvailable() {
    return isValid() && status == 1 && leftQuantity > 0;
  }

  bool hasMissingPaymentDiscount() {
    return isValid() && missingPaymentDiscount > 0;
  }
  bool hasIntallmentDiscount() {
    return isValid() && diffInstallmentDiscount > 0;
  }

  String displayLimitCustomer() {
    if(isValid()){
      if(limitCustomerFrequency == 0){
        return '$limitPerCustomer คูปอง';
      }else if(limitCustomerFrequency == 1){
        return '$limitPerCustomer คูปองต่อวัน';
      }else if(limitCustomerFrequency == 2){
        return '$limitPerCustomer คูปองต่อสัปดาห์';
      }else if(limitCustomerFrequency == 3){
        return '$limitPerCustomer คูปองต่อเดือน';
      }else if(limitCustomerFrequency == 4){
        return '$limitPerCustomer คูปองต่อปี';
      }else{
        return '';
      }
    }else{
      return '';
    }
  }
  String displayType(LanguageController controller) {
    if(isValid()){
      if(type == 1){
        return controller.getLang("Product Discount");
      }else if(type == 2){
        return controller.getLang("Buy X Get Y Discounted");
      }else if(type == 3){
        return controller.getLang("Cash Coupon");
      }else if(type == 4){
        return controller.getLang("Product Set Discount");
      }else if(type == 5){
        return controller.getLang("Product Step Discount");
      }else{
        return '';
      }
    }else{
      return '';
    }
  }
  
  String displayAvailableType(LanguageController controller) {
    if(isValid()){
      if(availableType == 1){
        return controller.getLang("All Products");
      }else if(availableType == 2){
        return controller.getLang("Include by Products");
      }else if(availableType == 3){
        return controller.getLang("Exclude by Products");
      }else if(availableType == 4){
        return controller.getLang("Include by Product Categories");
      }else if(availableType == 5){
        return controller.getLang("Exclude by Product Categories");
      }else{
        return '';
      }
    }else{
      return '';
    }
  }
  
  String displayDiscount(LanguageController controller, {bool trimDigits = false}) {
    if(isValid()){
      if(type == 1){
        if(discountType == 1){
          return priceFormat(discount, controller, trimDigits: trimDigits);
        }else if(discountType == 2){
          if(maximumDiscount != null){
            return '${priceFormat(discount, controller, trimDigits: trimDigits)}% (${controller.getLang("Maximum")} ${priceFormat(maximumDiscount, controller, trimDigits: trimDigits)})';
          }else{
            return '${priceFormat(discount, controller, trimDigits: trimDigits)}%';
          }
        }else{
          return '';
        }
      }else if(type == 3){
        return priceFormat(discount, controller, trimDigits: trimDigits);
      }else{
        return '';
      }
    }else{
      return '';
    }
  }

  String displayAvailability(LanguageController controller) {
    if(availability == 99){
      return controller.getLang('text_available_coupon_99');
    }else if(availability == 0){
      return controller.getLang('text_available_coupon_0');
    }else if(availability == 1){
      return controller.getLang('text_available_coupon_1');
    }else if(availability == 2){
      return controller.getLang('text_available_coupon_2');
    }else if(availability == 3){
      return controller.getLang('text_available_coupon_3');
    }else if(availability == 4){
      return controller.getLang('text_available_coupon_4');
    }else if(availability == 5){
      return controller.getLang('text_available_coupon_5');
    }else if(availability == 6){
      return controller.getLang('text_available_coupon_6');
    }else if(availability == 7){
      return controller.getLang('text_available_coupon_7');
    }else if(availability == 8){
      return controller.getLang('text_available_coupon_8');
    }else if(availability == 9){
      return controller.getLang('text_available_coupon_9');
    }else if(availability == 10){
      return controller.getLang('text_available_coupon_10');
    }else if(availability == 11){
      return controller.getLang('text_available_coupon_11');
    }else if(availability == 12){
      return controller.getLang('text_available_coupon_12');
    }else if(availability == 13){
      return controller.getLang('text_available_coupon_13');
    }else if(availability == 14){
      return controller.getLang('text_available_coupon_14');
    }else{
      return '';
    }
  }


  bool validAllowCustomDownPayment() {
    if(isValid()){
      return type == 4 && allowCustomDownPayment == 1 
        && customDownPayments.isNotEmpty;
    }else{
      return false;
    }
  }
}