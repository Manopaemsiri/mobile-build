import 'dart:convert';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:html_unescape/html_unescape.dart';

/*
  limitCustomerFrequency
    0 = ต่อคูปอง
    1 = ต่อวัน
    2 = ต่อสัปดาห์
    3 = ต่อเดือน
    4 = ต่อปี

  discountType
    1 = Flat rate
    2 = Percentage
    
  availableType : Number
    1 = All products
    2 = Include products
    3 = Exclude products
    4 = Include product categories
    5 = Exclude product categories

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
    6  = วิธีการจัดส่งไม่ได้ร่วมรายการ
    7  = ระดับของคุณไม่ร่วมรายการ
    8  = สั่งซื้อขั้นต่ำไม่ถึงที่กำหนด
    9  = สั่งซื้อสูงสุดเกินที่กำหนด
    10 = มีประเภทสินค้าในตะกร้าที่ไม่ร่วมรายการ
    11 = มีสินค้าในตะกร้าที่ไม่ร่วมรายการ
    12 = สินค้าในตะกร้าไม่เข้าเงื่อนไข
    13 = พื้นที่จัดส่งไม่ร่วมรายการ
    99 = ใช้งานได้
*/

PartnerShippingCouponModel partnerShippingCouponModelFromJson(String str) =>
  PartnerShippingCouponModel.fromJson(json.decode(str));
String partnerShippingCouponModelToJson(PartnerShippingCouponModel model) =>
  json.encode(model.toJson());

class PartnerShippingCouponModel {
  PartnerShippingCouponModel({
    this.id,
    this.channel = 'C2U',
    this.shippings = const [],

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
  });

  String? id;
  String channel;
  List<PartnerShippingModel> shippings;

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

  factory PartnerShippingCouponModel.fromJson(Map<String, dynamic> json){
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
    return PartnerShippingCouponModel(
      id: json["_id"],
      channel: json["channel"] ?? 'C2U',
      shippings: !isValidList(json["shippings"])? []
        : List<PartnerShippingModel>.from(json["shippings"]
          .where((x) => x is! String)
          .map((x) => PartnerShippingModel.fromJson(x))),

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
      redeemPoints: json["redeemPoints"] ?? 0,
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
      forProvinces: !isValidList(json['forProvinces'])? []
        : List<ProvinceModel>.from(json['forProvinces']
          .where((e) => e.runtimeType != String)
          .map((e) => ProvinceModel.fromJson(e))),

      updatedAt: json["updatedAt"] == null
        ? null: DateTime.parse(json["updatedAt"]),
      createdAt: json["createdAt"] == null
        ? null: DateTime.parse(json["createdAt"]),

      isPersonal: json["isPersonal"] ?? 0,
      availability: json["availability"] ?? 0,
      actualDiscount: json["actualDiscount"] == null
        ? 0: double.parse(json["actualDiscount"].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "channel": channel,
    "shippings": List<PartnerShippingModel>
      .from(shippings.map((x) => x.toJson())),
    
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
  };

  bool isValid() {
    return id != null ? true : false;
  }
  bool isAvailable() {
    if(isValid() && status == 1 && leftQuantity > 0){
      return true;
    }else{
      return false;
    }
  }

  String displayLimitCustomer(LanguageController controller) {
    if(isValid()){
      if(limitCustomerFrequency == 0){
        return '$limitPerCustomer ${controller.getLang("Coupon")}';
      }else if(limitCustomerFrequency == 1){
        return '$limitPerCustomer ${controller.getLang("Coupon Per Day")}';
      }else if(limitCustomerFrequency == 2){
        return '$limitPerCustomer ${controller.getLang("Weekly Coupon")}';
      }else if(limitCustomerFrequency == 3){
        return '$limitPerCustomer ${controller.getLang("Coupon Per Month")}';
      }else if(limitCustomerFrequency == 4){
        return '$limitPerCustomer ${controller.getLang("Coupon Per Year")}';
      }else{
        return '';
      }
    }else{
      return '';
    }
  }
  String displayDiscount(LanguageController controller, {bool trimDigits = false}){
    final symbol = controller.usedCurrency?.unit ?? controller.defaultCurrency?.unit ?? 'THB';
    
    if(isValid()){
      if(discountType == 1){
        return '${priceFormat(discount, controller, showSymbol: false, trimDigits: trimDigits)} $symbol';
      }else if(discountType == 2){
        if(maximumDiscount != null){
          return '${numberFormat(discount)}% (${controller.getLang("Maximum")} ${priceFormat(maximumDiscount, controller, showSymbol: false, trimDigits: trimDigits)} $symbol)';
        }else{
          return '${numberFormat(discount)}%';
        }
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
  
  String displayAvailability(LanguageController controller) {
    if(availability == 99){
      return controller.getLang("text_available_coupon_99");
    }else if(availability == 0){
      return controller.getLang("text_available_coupon_0");
    }else if(availability == 1){
      return controller.getLang("text_available_coupon_1");
    }else if(availability == 2){
      return controller.getLang("text_available_coupon_2");
    }else if(availability == 3){
      return controller.getLang("text_available_coupon_3");
    }else if(availability == 4){
      return controller.getLang("text_available_coupon_4");
    }else if(availability == 5){
      return controller.getLang("text_available_coupon_5");
    }else if(availability == 6){
      return controller.getLang("text_available_coupon_6");
    }else if(availability == 7){
      return controller.getLang("text_available_coupon_7");
    }else if(availability == 8){
      return controller.getLang("text_available_coupon_8");
    }else if(availability == 9){
      return controller.getLang("text_available_coupon_9");
    }else if(availability == 10){
      return controller.getLang("text_available_coupon_10");
    }else if(availability == 11){
      return controller.getLang("text_available_coupon_11");
    }else if(availability == 12){
      return controller.getLang('text_available_coupon_12');
    }else if(availability == 13){
      return controller.getLang('text_available_coupon_13');
    }else{
      return '';
    }
  }
}