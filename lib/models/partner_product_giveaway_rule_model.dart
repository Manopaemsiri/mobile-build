import 'package:coffee2u/models/index.dart';
import 'package:html_unescape/html_unescape.dart';

/*
  channel : String
    - C2U
    - STORE

  status : Number
    0 = Inactive
    1 = Active

  availableType : Number
    1 = All products
    2 = Include products
    3 = Exclude products
    4 = Include product categories
    5 = Exclude product categories

  giveawayRules : Array
    availableType = 2, 3
        productId : String
        unitId : String
    availableType = 4, 5
        categoryId : String

  giveawayProducts : Array
    Product status = -1
        productId : String
        unitId : String
        quantity : Number
*/

class PartnerProductGiveawayRuleModel {
  PartnerProductGiveawayRuleModel({
    this.id,
    this.channel = 'C2U',
    this.status = 0,
    this.order = 1,

    this.name = '',
    this.shortDescription = '',
    this.description = '',
    this.image,

    this.startAt,
    this.endAt,
    this.minimumOrder,
    this.maximumOrder,

    this.availableType = 1,
    this.products = const [],
    this.productCategories = const [],

    this.giveawayProducts = const [],

    this.forAllPartnerShops = 1,
    this.forPartnerShops = const [],
    this.forAllCustomerTiers = 1,
    this.forCustomerTiers = const [],
    this.forAllProvinces = 0,
    this.forProvinces = const [],

    this.createdAt,
    this.updatedAt,
  });

  String? id;
  
  String channel;
  int status;
  int order;

  String name;
  String shortDescription;
  String description;

  FileModel? image;
  
  DateTime? startAt;
  DateTime? endAt;

  double? minimumOrder;
  double? maximumOrder;

  int availableType;
  List<PartnerProductModel> products;
  List<PartnerProductCategoryModel> productCategories;

  List<PartnerProductModel> giveawayProducts;

  int forAllPartnerShops;
  List<PartnerShopModel> forPartnerShops;
  int forAllCustomerTiers;
  List<CustomerTierModel> forCustomerTiers;
  int forAllProvinces;
  List<ProvinceModel> forProvinces;

  DateTime? updatedAt;
  DateTime? createdAt;
  
  factory PartnerProductGiveawayRuleModel.fromJson(Map<String, dynamic> json){
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
    return PartnerProductGiveawayRuleModel(
      id: json["_id"],
      channel: json["channel"] ?? 'C2U',

      name: json["name"]==null? '': unescape.convert(json["name"]),
      shortDescription: json["shortDescription"]==null? '': unescape.convert(json["shortDescription"]),
      description: json["description"]==null? '': unescape.convert(json["description"]),

      image: json["image"] == null || json["image"] is String
        ? null : FileModel.fromJson(json["image"]),
      
      startAt: json["startAt"] == null
        ? null: DateTime.parse(json["startAt"]),
      endAt: json["endAt"] == null
        ? null: DateTime.parse(json["endAt"]),

      status: json["status"] ?? 0,
      minimumOrder: json["minimumOrder"] == null
        ? null: double.parse(json["minimumOrder"].toString()),
      maximumOrder: json["maximumOrder"] == null
        ? null: double.parse(json["maximumOrder"].toString()),

      availableType: json["availableType"] ?? 0,
      products: !isValidList(json["products"])? [] 
        : List<PartnerProductModel>.from(json["products"]
          .where((x) => x is! String)
          .map((x) => PartnerProductModel.fromJson(x))),
      productCategories: !isValidList(json["productCategories"])? [] 
        : List<PartnerProductCategoryModel>.from(json["productCategories"]
          .where((x) => x is! String)
          .map((x) => PartnerProductCategoryModel.fromJson(x))),

      giveawayProducts: !isValidList(json["giveawayProducts"])? [] 
        : List<PartnerProductModel>.from(json["giveawayProducts"]
          .where((x) => x is! String)
          .map((x) => PartnerProductModel.fromJson(x))),

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
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "channel": channel,
    
    "name": name,
    "shortDescription": shortDescription,
    "description": description,

    "image": image?.toJson(),
    
    "startAt": startAt?.toIso8601String(),
    "endAt": endAt?.toIso8601String(),

    "status": status,
    "minimumOrder": minimumOrder,
    "maximumOrder": maximumOrder,

    "availableType": availableType,
    "products": List<PartnerProductModel>
      .from(products.map((x) => x.toJson())),
    "productCategories": List<PartnerProductCategoryModel>
      .from(productCategories.map((x) => x.toJson())),

    "giveawayProducts": List<PartnerProductModel>
      .from(products.map((x) => x.toJson())),

    "forAllPartnerShops": forAllPartnerShops,
    "forPartnerShops": List<PartnerShopModel>
      .from(forPartnerShops.map((x) => x.toJson())),
    "forAllCustomerTiers": forAllCustomerTiers,
    "forCustomerTiers": List<CustomerTierModel>
      .from(forCustomerTiers.map((x) => x.toJson())),
      
    "forAllProvinces": forAllProvinces,
    'forProvinces': forProvinces.isEmpty? []
      : forProvinces.map((e) => e.toJson()).toList(),

    "updatedAt": updatedAt?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
  };

  bool isValid() {
    return id != null? true: false;
  }
}