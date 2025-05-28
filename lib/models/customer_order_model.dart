import 'dart:convert';
import 'package:coffee2u/config/index.dart';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:coffee2u/widgets/index.dart';
import 'package:coffee2u/models/index.dart';
import 'package:flutter/material.dart';

/*
  paymentStatus
    -1 = คืนเงินแล้ว
    0  = ทดสอบ
    1  = รอการชำระเงิน COD
    2  = ชำระเงินแล้ว COD
    3  = ชำระเงินแล้ว
    4  = ผ่อนชำระแล้ว
*/

CustomerOrderModel customerOrderModelFromJson(String str) =>
  CustomerOrderModel.fromJson(json.decode(str));
String customerOrderModelToJson(CustomerOrderModel model) => 
  json.encode(model.toJson());

class CustomerOrderModel {
  CustomerOrderModel({
    this.id,
    this.type = 'C2U',
    this.orderId = '',

    this.orderIdKerry = '',
    this.pickupDateKerry,
    this.pickupTimeKerry = '',

    this.orderId2C2P = '',
    this.paymentToken2C2P = '',
    
    this.customer,
    this.shop,

    this.products = const [],
    this.subtotal = 0,
    
    this.vat = 0,
    this.vatPercent = 0,
    
    this.total = 0,
    
    this.coupon,
    this.couponDiscount = 0,
    this.couponMissingPaymentDiscount = 0,
    
    this.shipping,
    this.shippingFrontend,
    this.shippingCost = 0,
    this.shippingCoupon,
    this.shippingDiscount = 0,
    
    this.cashCoupon,
    this.cashDiscount = 0,
    this.cashMissingPaymentDiscount = 0,
    
    this.pointBurn = 0,
    this.pointDiscount = 0,
    
    this.grandTotal = 0,

    this.hasDownPayment = 0,
    this.downPayment = 0,
    this.missingPayment = 0,
    this.fullMissingPayment = 0,

    this.grandTotalDefault,
    this.hasCustomDownPayment = 0,
    this.customDownPayment,
    this.downPaymentDefault,
    this.missingPaymentDefault,
    
    this.pointEarn = 0,
    this.pointEarnStatus = 0,

    this.shippingAddress,
    this.billingAddress,

    this.shippingStatusDates = const [],
    this.shippingStatus,
    this.shippingHistory = const [],

    this.minDeliveryDate,
    this.maxDeliveryDate,
    this.pickupDate,
    this.pickupTime = '',
    this.deliveredDate,

    this.paymentMethod,
    this.paymentStatus = 0,
    this.paymentDate,
    
    this.packagings = const [],
    
    this.note = '',

    this.giveawayCoupons = const [],
    this.receivedCoupons = const [],
    this.productGiveawayRule,

    int hasRatedProduct = 0,
    this.productRatingEndAt,
    int hasRatedOrder = 0,
    this.orderRatingEndAt,

    this.orderRating,
    this.productRating,

    this.subscription,
    this.subscriptionPlan,

    this.createdAt,
    this.updatedAt,
  }) : 
    _hasRatedProduct = hasRatedProduct, 
    _hasRatedOrder = hasRatedOrder;

  String? id;
  String type;
  String orderId;

  String orderIdKerry;
  DateTime? pickupDateKerry;
  String pickupTimeKerry;

  String orderId2C2P;
  String paymentToken2C2P;
  
  CustomerModel? customer;
  PartnerShopModel? shop;

  List<PartnerProductModel> products;
  double subtotal;
  
  double vat;
  double vatPercent;
  
  double total;
  
  PartnerProductCouponModel? coupon;
  double couponDiscount;
  double couponMissingPaymentDiscount;
  
  PartnerShippingModel? shipping;
  PartnerShippingFrontendModel? shippingFrontend;
  double shippingCost;
  PartnerShippingCouponModel? shippingCoupon;
  double shippingDiscount;
  
  PartnerProductCouponModel? cashCoupon;
  double cashDiscount;
  double cashMissingPaymentDiscount;
  
  int pointBurn;
  double pointDiscount;
  
  double grandTotal;

  int hasDownPayment;
  double downPayment;
  double missingPayment;
  double fullMissingPayment;

  double? grandTotalDefault;
  int hasCustomDownPayment;
  double? customDownPayment;
  double? downPaymentDefault;
  double? missingPaymentDefault;

  int pointEarn;
  int pointEarnStatus;

  CustomerShippingAddressModel? shippingAddress;
  CustomerBillingAddressModel? billingAddress;

  List<DateTime> shippingStatusDates;
  ShippingStatusMappingModel? shippingStatus;
  List<ShippingStatusMappingModel> shippingHistory;

  DateTime? minDeliveryDate;
  DateTime? maxDeliveryDate;
  DateTime? pickupDate;
  String pickupTime;
  DateTime? deliveredDate;

  PaymentMethodModel? paymentMethod;
  int paymentStatus;
  DateTime? paymentDate;
  
  List packagings;
  
  String note;
  
  // Giveaway
  List<PartnerProductCouponModel> giveawayCoupons;
  List<PartnerProductCouponModel> receivedCoupons;

  PartnerProductGiveawayRuleModel? productGiveawayRule;

  int _hasRatedProduct;
  DateTime? productRatingEndAt;
  int _hasRatedOrder;
  DateTime? orderRatingEndAt;

  CustomerOrderRatingModel? orderRating;
  PartnerProductRatingModel? productRating;

  dynamic subscription;
  dynamic subscriptionPlan;

  DateTime? createdAt;
  DateTime? updatedAt; 
  
  bool get hasRatedProduct => _hasRatedProduct == 1;
  set hasRatedProduct(bool value) =>
    _hasRatedProduct = value? 1: 0;
  
  bool get hasRatedOrder => _hasRatedOrder == 1;
  set hasRatedOrder(bool value) =>
    _hasRatedOrder = value? 1: 0;

  factory CustomerOrderModel.fromJson(Map<String, dynamic> json){
    List<String> ssDates = json["shippingStatusDates"] == null
      ? []: List<String>.from(json["shippingStatusDates"].map((d) => d));
    List<ShippingStatusMappingModel> ssHistory = [];
    if(json["shippingHistory"] != null){
      List data = json["shippingHistory"] as List;
      var len = data.length;
      for(var i=0; i<len; i++) {
        ssHistory.add(ShippingStatusMappingModel.fromJson({
          ...data[i],
          ...{ "createdAt": ssDates.length > i? ssDates[i]: null }
        }));
      }
    }
    return CustomerOrderModel(
      id: json["_id"],
      type: json["type"] ?? '',
      orderId: json["orderId"] ?? '',

      orderIdKerry: json["orderIdKerry"] ?? '',
      pickupDateKerry: json["pickupDateKerry"] == null
        ? null: DateTime.parse(json["pickupDateKerry"]),
      pickupTimeKerry: json["pickupTimeKerry"] ?? '',

      orderId2C2P: json["orderId2C2P"] ?? '',
      paymentToken2C2P: json["paymentToken2C2P"] ?? '',
      
      customer: json["customer"] != null && json["customer"] is! String
        ? CustomerModel.fromJson(json["customer"]): null,
      shop: json["shop"] != null && json["shop"] is! String
        ? PartnerShopModel.fromJson(json["shop"]): null,

      products: json["products"] != null && json["products"] is! String
        ? List<PartnerProductModel>.from(json["products"]
          .where((x) => x is! String)
          .map((x) => PartnerProductModel.fromJson(x))) 
        : [],
      subtotal: json["subtotal"] == null
        ? 0: double.parse(json["subtotal"].toString()),
      
      vat: json["vat"] == null
        ? 0: double.parse(json["vat"].toString()),
      vatPercent: json["vatPercent"] == null
        ? 0: double.parse(json["vatPercent"].toString()),
      
      total: json["total"] == null
        ? 0: double.parse(json["total"].toString()),
      
      coupon: json["coupon"] != null && json["coupon"] is! String
        ? PartnerProductCouponModel.fromJson(json["coupon"]): null,
      couponDiscount: json["couponDiscount"] == null
        ? 0: double.parse(json["couponDiscount"].toString()),
      couponMissingPaymentDiscount: json["couponMissingPaymentDiscount"] == null
        ? 0: double.parse(json["couponMissingPaymentDiscount"].toString()),
      
      shipping: json["shipping"] != null && json["shipping"] is! String
        ? PartnerShippingModel.fromJson(json["shipping"]): null,
      shippingFrontend: json["shippingFrontend"] != null && json["shippingFrontend"] is! String
        ? PartnerShippingFrontendModel.fromJson(json["shippingFrontend"]): null,
      shippingCost: json["shippingCost"] == null
        ? 0: double.parse(json["shippingCost"].toString()),
      shippingCoupon: json["shippingCoupon"] != null && json["shippingCoupon"] is! String
        ? PartnerShippingCouponModel.fromJson(json["shippingCoupon"]): null,
      shippingDiscount: json["shippingDiscount"] == null
        ? 0: double.parse(json["shippingDiscount"].toString()),
      
      cashCoupon: json["cashCoupon"] != null && json["cashCoupon"] is! String
        ? PartnerProductCouponModel.fromJson(json["cashCoupon"]): null,
      cashDiscount: json["cashDiscount"] == null
        ? 0: double.parse(json["cashDiscount"].toString()),
      cashMissingPaymentDiscount: json["cashMissingPaymentDiscount"] == null
        ? 0: double.parse(json["cashMissingPaymentDiscount"].toString()),
      
      pointBurn: json["pointBurn"] ?? 0,
      pointDiscount: json["pointDiscount"] == null
        ? 0: double.parse(json["pointDiscount"].toString()),
      
      grandTotal: json["grandTotal"] == null
        ? 0: double.parse(json["grandTotal"].toString()),

      hasDownPayment: json["hasDownPayment"] ?? 0,
      downPayment: json["downPayment"] == null
        ? 0: double.parse(json["downPayment"].toString()),
      missingPayment: json["missingPayment"] == null
        ? 0: double.parse(json["missingPayment"].toString()),
      fullMissingPayment: json["fullMissingPayment"] == null
        ? 0: double.parse(json["fullMissingPayment"].toString()),

      grandTotalDefault: json["grandTotalDefault"] == null 
        ? null: double.parse(json["grandTotalDefault"].toString()),
      hasCustomDownPayment: json["hasCustomDownPayment"] ?? 0,
      customDownPayment: json["customDownPayment"] == null 
        ? null: double.parse(json["customDownPayment"].toString()),
      downPaymentDefault: json["downPaymentDefault"] == null 
        ? null: double.parse(json["downPaymentDefault"].toString()),
      missingPaymentDefault: json["missingPaymentDefault"] == null 
        ? null: double.parse(json["missingPaymentDefault"].toString()),
      
      pointEarn: json["pointEarn"] ?? 0,
      pointEarnStatus: json["pointEarnStatus"] ?? 0,

      shippingAddress: json["shippingAddress"] != null && json["shippingAddress"] is! String
        ? CustomerShippingAddressModel.fromJson(json["shippingAddress"]): null,
      billingAddress: json["billingAddress"] != null && json["billingAddress"] is! String
        ? CustomerBillingAddressModel.fromJson(json["billingAddress"]): null,

      shippingStatusDates: List<DateTime>.from(ssDates.map((d) => DateTime.parse(d))),
      shippingStatus: json["shippingStatus"] == null? null
        : ShippingStatusMappingModel.fromJson({
          ...json["shippingStatus"],
          ...{ "createdAt": ssDates.isNotEmpty? ssDates[0]: null }
        }),
      shippingHistory: ssHistory,

      minDeliveryDate: json["minDeliveryDate"] == null
        ? null: DateTime.parse(json["minDeliveryDate"]),
      maxDeliveryDate: json["maxDeliveryDate"] == null
        ? null: DateTime.parse(json["maxDeliveryDate"]),
      pickupDate: json["pickupDate"] == null
        ? null: DateTime.parse(json["pickupDate"]),
      pickupTime: json["pickupTime"] ?? '',
      deliveredDate: json["deliveredDate"] == null
        ? null: DateTime.parse(json["deliveredDate"]),

      paymentMethod: json["paymentMethod"] != null && json["paymentMethod"] is! String
        ? PaymentMethodModel.fromJson(json["paymentMethod"]) 
        : null,
      paymentStatus: json["paymentStatus"] ?? 0,
      paymentDate: json["paymentDate"] == null
        ? null: DateTime.parse(json["paymentDate"]),
      
      packagings: json["packagings"] ?? [],
      
      note: json["note"] ?? '',

      giveawayCoupons: json["giveawayCoupons"] != null && json["giveawayCoupons"] is! String
        ? List<PartnerProductCouponModel>.from(json["giveawayCoupons"]
          .where((x) => x is! String)
          .map((x) => PartnerProductCouponModel.fromJson(x))) 
        : [],
      receivedCoupons: json["receivedCoupons"] != null && json["receivedCoupons"] is! String
        ? List<PartnerProductCouponModel>.from(json["receivedCoupons"]
          .where((x) => x is! String)
          .map((x) => PartnerProductCouponModel.fromJson(x))) 
        : [],
      productGiveawayRule: json["productGiveawayRule"] != null && json["productGiveawayRule"] is! String
        ? PartnerProductGiveawayRuleModel.fromJson(json["productGiveawayRule"]) 
        : null,

      hasRatedProduct: json["hasRatedProduct"] ?? 0,
      productRatingEndAt: json["productRatingEndAt"] == null
        ? null: DateTime.parse(json["productRatingEndAt"]),
      hasRatedOrder: json["hasRatedOrder"] ?? 0,
      orderRatingEndAt: json["orderRatingEndAt"] == null
        ? null: DateTime.parse(json["orderRatingEndAt"]),

      orderRating: json["orderRating"] != null && json["orderRating"] is! String
        ? CustomerOrderRatingModel.fromJson(json["orderRating"]): null,
      productRating: json["productRating"] != null && json["productRating"] is! String
        ? PartnerProductRatingModel.fromJson(json["productRating"]): null,

      subscription: json["subscription"] != null
        ? json["subscription"] is Map
          ? CustomerSubscriptionModel.fromJson(json["subscription"])
          : json["subscription"] is String
            ? json["subscription"]
            : null
        : null,
      subscriptionPlan: json["subscriptionPlan"] != null
        ? json["subscriptionPlan"] is Map
          ? CustomerSubscriptionPlanModel.fromJson(json["subscriptionPlan"])
          : json["subscriptionPlan"] is String
            ? json["subscriptionPlan"]
            : null
        : null,

      createdAt: json["createdAt"] == null
        ? null: DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null
        ? null: DateTime.parse(json["updatedAt"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "type": type,
    "orderId": orderId,

    "orderIdKerry": orderIdKerry,
    "pickupDateKerry": pickupDateKerry?.toIso8601String(),
    "pickupTimeKerry": pickupTimeKerry,

    "orderId2C2P": orderId2C2P,
    "paymentToken2C2P": paymentToken2C2P,
    
    "customer": customer?.toJson(),
    "shop": shop?.toJson(),

    "products": List<dynamic>.from(products.map((e) => e.toJson())),
    "subtotal": subtotal,
    
    "vat": vat,
    "vatPercent": vatPercent,
    
    "total": total,
    
    "coupon": coupon?.toJson(),
    "couponDiscount": couponDiscount,
    "couponMissingPaymentDiscount": couponMissingPaymentDiscount,
    
    "shipping": shipping?.toJson(),
    "shippingFrontend": shippingFrontend?.toJson(),
    "shippingCost": shippingCost,
    "shippingCoupon": shippingCoupon?.toJson(),
    "shippingDiscount": shippingDiscount,
    
    "cashCoupon": cashCoupon?.toJson(),
    "cashDiscount": cashDiscount,
    "cashMissingPaymentDiscount": cashMissingPaymentDiscount,
    
    "pointBurn": pointBurn,
    "pointDiscount": pointDiscount,
    
    "grandTotal": grandTotal,

    "hasDownPayment": hasDownPayment,
    "downPayment": downPayment,
    "missingPayment": missingPayment,
    "fullMissingPayment": fullMissingPayment,

    "grandTotalDefault": grandTotalDefault,
    "hasCustomDownPayment": hasCustomDownPayment,
    "customDownPayment": customDownPayment,
    "downPaymentDefault": downPaymentDefault,
    "missingPaymentDefault": missingPaymentDefault,
    
    "pointEarn": pointEarn,
    "pointEarnStatus": pointEarnStatus,

    "shippingAddress": shippingAddress?.toJson(),
    "billingAddress": billingAddress?.toJson(),

    "shippingStatusDates": shippingStatusDates,
    "shippingStatus": shippingStatus?.toJson(),
    "shippingHistory": shippingHistory.map((d) => d.toJson()),

    "minDeliveryDate": minDeliveryDate?.toIso8601String(),
    "maxDeliveryDate": maxDeliveryDate?.toIso8601String(),
    "pickupDate": pickupDate?.toIso8601String(),
    "pickupTime": pickupTime,
    "deliveredDate": deliveredDate?.toIso8601String(),

    "paymentMethod": paymentMethod?.toJson(),
    "paymentStatus": paymentStatus,
    "paymentDate": paymentDate?.toIso8601String(),
    
    "packagings": packagings,
    
    "note": note,

    "giveawayCoupons": List<PartnerProductCouponModel>.from(giveawayCoupons.map((e) => e.toJson())),
    "receivedCoupons": List<PartnerProductCouponModel>.from(receivedCoupons.map((e) => e.toJson())),
    "productGiveawayRule": productGiveawayRule?.toJson(),

    "hasRatedProduct": _hasRatedProduct,
    // "hasRatedProduct": hasRatedProduct,
    "productRatingEndAt": productRatingEndAt?.toIso8601String(),
    "hasRatedOrder": _hasRatedOrder,
    // "hasRatedOrder": hasRatedOrder,
    "orderRatingEndAt": orderRatingEndAt?.toIso8601String(),

    "orderRating": orderRating?.toJson(),
    "productRating": productRating?.toJson(),
    "subscription": subscription == null
      ? null
      : subscription is CustomerSubscriptionModel
        ? subscription?.toJson()
        : subscription,
    "subscriptionPlan": subscriptionPlan == null
      ? null
      : subscriptionPlan is CustomerSubscriptionPlanModel
        ? subscriptionPlan?.toJson()
        : subscriptionPlan,
  
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };

  bool isValid() {
    return id != null? true: false;
  }
  bool isValidShippingAddress() {
    return shippingAddress != null
      && shippingAddress!.shippingFirstname != '' 
      && shippingAddress!.shippingLastname != '';
  }
  bool isValidBillingAddress() {
    return billingAddress != null 
      && billingAddress!.billingName != '' 
      && billingAddress!.taxId != '';
  }
  bool isValidDownPayment() {
    return isValid() && hasDownPayment == 1 
      && downPayment > 0 && missingPayment > 0;
  }
  bool isValidCustomDownPayment() {
    return isValid() && customDownPayment != null 
      && (downPaymentDefault != null || missingPaymentDefault != null);
  }

  bool isReturned() {
    if(!isValid()){
      return false;
    }else{
      int? temp = shippingStatus?.shippingStatus?.order;
      if(shippingStatus == null || shippingStatus?.shippingStatus == null){
        return false;
      }else if(temp == 4){
        return true;
      }else{
        return false;
      }
    }
  }
  bool isReceived() {
    if(!isValid()){
      return false;
    }else{
      int temp = shippingStatus!.shippingStatus!.order;
      if(shippingStatus == null || shippingStatus!.shippingStatus == null){
        return false;
      }else if(temp == 3){
        return true;
      }else{
        return false;
      }
    }
  }

  String displayMissingPayment(LanguageController controller, {bool showSymbol = true, bool trimDigits = false}) {
    if(isValidDownPayment()){
      return priceFormat(missingPayment, controller, digits: 2, showSymbol: showSymbol, trimDigits: trimDigits);
    } else {
      return '';
    }
  }

  Widget displayShippingStatus() {
    if(isValid()){
      String status1 = shippingStatus?.shippingStatus?.name ?? '';
      int order1 = shippingStatus?.shippingStatus?.order ?? 0;
      if(order1 == 1){
        return BadgeDefault(
          title: status1,
          color: kYellowColor,
          size: 15,
        );
      }else if(order1 == 2){
        return BadgeDefault(
          title: status1,
          color: kBlueColor,
          size: 15,
        );
      }else if(order1 == 3){
        return BadgeDefault(
          title: status1,
          color: kGreenColor,
          size: 15,
        );
      }else if(order1 == 4){
        return BadgeDefault(
          title: status1,
          color: kRedColor,
          size: 15,
        );
      }else{
        return const SizedBox.shrink();
      }
    }else{
      return const SizedBox.shrink();
    }
  }
  String displayShippingStatusText() {
    if(isValid()){
      return shippingStatus?.shippingStatus?.name ?? '';
    }else{
      return '';
    }
  }
  
  String displayDeliveryDetail(LanguageController controller) {
    if(isValid()){
      bool isDelivered = shippingStatus?.shippingStatus?.order == 3;
      bool isReturned = shippingStatus?.shippingStatus?.order == 4;
      DateTime actionDate = shippingStatus?.createdAt ?? DateTime.now();
      if(isReturned){
        return '${controller.getLang("Return the product on")} ${dateFormat(actionDate, format: 'd MMMM y ${controller.getLang("Time")} kk:mm')}';
      }
      if(shipping?.type == 2){
        if(isDelivered){
          return '${controller.getLang("text_received_product_1")} ${dateFormat(actionDate, format: 'd MMMM y ${controller.getLang("Time")} kk:mm')}';
        }else{
          return '${controller.getLang("Pick up the product on")} ${dateFormat(pickupDate ?? DateTime.now(), format: 'd MMMM y')} ${controller.getLang("Time")} $pickupTime';
        }
      }else{
        if(isDelivered){
          return '${controller.getLang("text_received_product_2")} ${dateFormat(actionDate, format: 'd MMMM y ${controller.getLang("Time")} kk:mm')}';
        }else{
          return shippingFrontend?.displaySummary(controller, minDeliveryDate: minDeliveryDate, maxDeliveryDate: maxDeliveryDate) ?? '';
          // return '${controller.getLang("Received the product within")}${dateFormat(maxDeliveryDate?? DateTime.now(), format: 'EEEE ที่ d MMMM y')}';
        }
      }
    }else{
      return '';
    }
  }

  String displayPaymentStatus(LanguageController controller) {
    if(isValid()){
      if(paymentStatus == 4){
        return controller.getLang('Paid Installment');
      }else if(paymentStatus == 3){
        return controller.getLang('Paid');
      }else if(paymentStatus == 2){
        return controller.getLang('Paid COD');
      }else if(paymentStatus == 1){
        return controller.getLang('Waiting for COD payment');
      }else if(paymentStatus == -1){
        return controller.getLang('Refunded');
      }else{
        return '';
      }
    }else{
      return '';
    }
  }

  canRateProduct() =>
    shippingStatus?.shippingStatus?.order == 3 && (DateTime.now().isBeforeOrEqualTo(productRatingEndAt) ?? false) && _hasRatedProduct == 0;

  canRateOrder() =>
    shippingStatus?.shippingStatus?.order == 3 && (DateTime.now().isBeforeOrEqualTo(orderRatingEndAt) ?? false) && _hasRatedOrder == 0;

  canUpdateRateProduct() =>
    shippingStatus?.shippingStatus?.order == 3 && (DateTime.now().isBeforeOrEqualTo(productRatingEndAt) ?? false);

  canUpdateRateOrder() =>
    shippingStatus?.shippingStatus?.order == 3 && (DateTime.now().isBeforeOrEqualTo(orderRatingEndAt) ?? false);

  double subscriptionInitialPriceInVAT() {
    return products.fold(0, (a, b) {
      return a + (b.subscriptionInitial > 0? ((b.addPriceInVAT) * b.inCart): 0);
    });
  }

}