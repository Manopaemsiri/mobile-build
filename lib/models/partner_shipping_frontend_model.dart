import 'dart:convert';
import 'package:coffee2u/controller/language_controller.dart';
import 'package:coffee2u/models/index.dart';
import 'package:coffee2u/utils/index.dart';
import 'package:html_unescape/html_unescape.dart';

/*
  type : Number
    1 = จัดส่งโดยส่วนกลาง
      subtype : Number
        1 = LF
        2 = Kerry Express
    2 = Click & Collect
    3 = Delivery by 3rd Party
      subtype : Number
        1 = Grab
        2 = Kerry Express
    4 = By Appointment
    5 = Self Delivery
    6 = Nim Express
      subtype : Number
        1 = LF
        2 = Nim Express

  shortages : Array
    shortage : Object
      _id: Partner product id,
      name: Partner product name,
      shortage: Number,
      unit: String

  shop : Object
    _id
    code
    name
    type
    url
    workingHours
    status
*/

PartnerShippingFrontendModel partnerShippingFrontendModelFromJson(String str) =>
    PartnerShippingFrontendModel.fromJson(json.decode(str));
String partnerShippingFrontendModelToJson(PartnerShippingFrontendModel model) =>
    json.encode(model.toJson());

class PartnerShippingFrontendModel {
  PartnerShippingFrontendModel({
    this.id,

    this.type = 1,
    this.subtype = 0,

    this.name = '',
    this.displayName = '',
    this.description = '',
    this.icon,
    
    this.price = 0,
    this.priceActual = 0,
    this.discount = 0,
    
    this.lfPickupDuration = 0,
    this.minDuration = 0,
    this.maxDuration = 0,

    this.pickupDate,
    this.pickupTime = '',

    this.shortages = const [],
    
    this.shop,
  });

  String? id;

  int type;
  int subtype;

  String name;
  String displayName;
  String description;
  
  FileModel? icon;

  double price;
  double priceActual;
  double discount;

  int lfPickupDuration;
  int minDuration;
  int maxDuration;

  DateTime? pickupDate;
  String pickupTime;

  List<dynamic> shortages;
  PartnerShopModel? shop;

  factory PartnerShippingFrontendModel.fromJson(Map<String, dynamic> json){
    var unescape = HtmlUnescape();
    return PartnerShippingFrontendModel(
      id: json["_id"],
      
      type: json["type"] ?? 1,
      subtype: json["subtype"] ?? 0,

      name: json["name"]==null? '': unescape.convert(json["name"]),
      displayName: json["displayName"]==null? '': unescape.convert(json["displayName"]),
      description: json["description"]==null? '': unescape.convert(json["description"]),

      icon: json["icon"] == null || json["icon"] is String
        ? null :FileModel.fromJson(json["icon"]),
        
      price: json["price"] == null
        ? 0: double.parse(json["price"].toString()),
      priceActual: json["priceActual"] == null
        ? 0: double.parse(json["priceActual"].toString()),
      discount: json["discount"] == null
        ? 0: double.parse(json["discount"].toString()),
        
      lfPickupDuration: json["lfPickupDuration"] ?? 0,
      minDuration: json["minDuration"] ?? 0,
      maxDuration: json["maxDuration"] ?? 0,

      pickupDate: json["pickupDate"] == null
        ? null: DateTime.parse(json["pickupDate"]),
      pickupTime: json["pickupTime"] ?? '',

      shortages: json["shortages"] ?? [],
      shop: json["shop"] != null && json["shop"] is! String
        ? PartnerShopModel.fromJson(json["shop"]) 
        : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
      
    "type": type,
    "subtype": subtype,

    "name": name,
    "displayName": displayName,
    "description": description,

    "icon": icon == null? null: icon!.toJson(),
      
    "price": price,
    "priceActual": priceActual,
    "discount": discount,
      
    "lfPickupDuration": lfPickupDuration,
    "minDuration": minDuration,
    "maxDuration": maxDuration,

    "pickupDate": pickupDate == null? null: pickupDate!.toIso8601String(),
    "pickupTime": pickupTime,

    "shortages": shortages,
    "shop": shop == null? null: shop!.toJson(),
  };

  bool isValid() {
    return id != null? true: false;
  }

  bool hasShortages() {
    if(isValid() && shortages.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }

  String displayPrice(LanguageController controller, {bool trimDigits = false}) {
    if (isValid()) {
      return priceFormat(price, controller ,digits: 2, trimDigits: trimDigits);
    } else {
      return '';
    }
  }

  String displayDiscount(LanguageController controller, {bool trimDigits = false}) {
    if (isValid()) {
      return priceFormat(discount, controller, digits: 2, trimDigits: trimDigits);
    } else {
      return '';
    }
  }

  String displayDeliveryDate(LanguageController controller) {
    if(isValid()){
      if(type == 2){
        return '';
      }else{
        // String temp = 'ได้รับวันที่ ${dateFormat(DateTime.now(), addDays: minDuration)}';
        // if(minDuration != maxDuration){
        //   temp += ' - ${dateFormat(DateTime.now(), addDays: maxDuration)}';
        // }
        // return temp;
        // return '${controller.getLang("Receive within")}${dateFormat(DateTime.now(), addDays: maxDuration, format: 'วัน E ที่ d MMMM y')}';
        return '${controller.getLang("Receive within")}${dateFormat(DateTime.now(), addDays: maxDuration, format: controller.languageCode == "th"? 'วัน E ที่ d MMMM y': 'd MMMM y')}';

      }
    }else{
      return '';
    }
  }
  String displayPickupTime(LanguageController controller) {
    if(isValid() && type == 2 && pickupDate != null && pickupTime != ''){
      return '${controller.getLang("Picked up")}${dateFormat(pickupDate ?? DateTime.now(), format: controller.languageCode == "th"? 'วัน E ที่ d MMMM y': 'd MMMM y')} ${controller.getLang("Time")} $pickupTime';
    }else{
      return '';
    }
  }
  String displaySummary(LanguageController controller, {DateTime? minDeliveryDate, DateTime? maxDeliveryDate}) {
    if(isValid()){
      if(type == 2 && pickupDate != null && pickupTime != ''){
        return '${controller.getLang("Picked up")}${dateFormat(pickupDate ?? DateTime.now(), format: controller.languageCode == "th"? 'วัน E ที่ d MMMM y': 'd MMMM y')} ${controller.getLang("Time")} $pickupTime';
      }else if(type != 2){
        DateTime? minDate = minDeliveryDate;
        DateTime? maxDate = maxDeliveryDate;

        final currentDate = DateTime.now();
        if(minDate == null || maxDate == null){
          minDate = currentDate.add(Duration(days: minDuration));
          maxDate = currentDate.add(Duration(days: maxDuration));
        }

        if(minDate.year == maxDate.year
          && minDate.month == maxDate.month
          && minDate.day == maxDate.day){
          return '${controller.getLang("Receive within")}${dateFormat(minDate, format: controller.languageCode == "th"? 'วัน E ที่ d MMMM y': 'd MMMM y')}';
        }
        
        if(minDate.year == maxDate.year){
          if(minDate.month == maxDate.month) {
            final _date = '${minDate.day} - ${maxDate.day} ${dateFormat(minDate, format: 'MMM y')}';
            return '${controller.getLang("text_receive_product")} $_date';
          }else {
            final __date1 = dateFormat(minDate, format: 'd MMM');
            final __date2 = dateFormat(maxDate, format: 'd MMM');
            final __date = dateFormat(minDate, format: 'y');
            return '${controller.getLang("text_receive_product")} $__date1 - $__date2 $__date';
          }
        }else {
          final __date1 = dateFormat(minDate, format: 'd MMM y');
          final __date2 = dateFormat(maxDate, format: 'd MMM y');
          return '${controller.getLang("text_receive_product")} $__date1 - $__date2';
        }
      }else{
        return '';
      }
    }else{
      return '';
    }
  }
}
