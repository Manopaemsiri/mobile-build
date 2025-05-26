import 'package:coffee2u/models/index.dart';
import 'package:html_unescape/html_unescape.dart';

class CmsContentModel {
  CmsContentModel({
    this.id,
    this.type = 'C2U',
    this.category,

    this.title = '',
    this.description = '',
    this.url = '',
    this.youtubeVideoId = '',
    this.content = '',

    this.image,
    this.gallery,

    this.relatedPartnerShops = const [],
    this.relatedPartnerProductCategories = const [],
    this.relatedPartnerProducts = const [],
    this.relatedPartnerProductCoupons = const [],

    this.order = 1,
    this.status = 0,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String type;
  CmsCategoryModel? category;

  String title;
  String description;
  String url;
  String youtubeVideoId;
  String content;

  FileModel? image;
  List<FileModel>? gallery;

  List<PartnerShopModel> relatedPartnerShops;
  List<PartnerProductCategoryModel> relatedPartnerProductCategories;
  List<PartnerProductModel> relatedPartnerProducts;
  List<PartnerProductCouponModel> relatedPartnerProductCoupons;

  int order;
  int status;
  DateTime? updatedAt;
  DateTime? createdAt;

  factory CmsContentModel.fromJson(Map<String, dynamic> json){
    var unescape = HtmlUnescape();
    return CmsContentModel(
      id: json["_id"],
      type: json["type"] ?? '',
      category: json["category"] != null && json["category"] is! String
        ? CmsCategoryModel.fromJson(json["category"]) 
        : null,

      title: json["title"]==null? '': unescape.convert(json["title"]),
      description: json["description"]==null? '': unescape.convert(json["description"]),
      url: json["url"] ?? '',
      youtubeVideoId: json["youtubeVideoId"] ?? '',
      content: json["content"] == null
        ? '': json["content"].toString().trim(),

      image: json["image"] != null && json["image"] is! String
        ? FileModel.fromJson(json["image"])
        : null,
      gallery: json["gallery"] == null || json["gallery"] is String? null
        : List<FileModel>.from(json["gallery"].where((x) => x is! String).map((x) => FileModel.fromJson(x))),
      
      relatedPartnerShops: json["relatedPartnerShops"] == null || json["relatedPartnerShops"] is String? []
        : List<PartnerShopModel>.from(json["relatedPartnerShops"]
          .where((x) => x is! String)
          .map((x) => PartnerShopModel.fromJson(x))),
      relatedPartnerProductCategories: json["relatedPartnerProductCategories"] == null || json["relatedPartnerProductCategories"] is String? []
        : List<PartnerProductCategoryModel>.from(json["relatedPartnerProductCategories"]
          .where((x) => x is! String)
          .map((x) => PartnerProductCategoryModel.fromJson(x))),
      relatedPartnerProducts: json["relatedPartnerProducts"] == null || json["relatedPartnerProducts"] is String? []
        : List<PartnerProductModel>.from(json["relatedPartnerProducts"]
          .where((x) => x is! String)
          .map((x) => PartnerProductModel.fromJson(x))),
      relatedPartnerProductCoupons: json["relatedPartnerProductCoupons"] == null || json["relatedPartnerProductCoupons"] is String? []
        : List<PartnerProductCouponModel>.from(json["relatedPartnerProductCoupons"]
          .where((x) => x is! String)
          .map((x) => PartnerProductCouponModel.fromJson(x))),

      order: json["order"] ?? 1,
      status: json["status"] ?? 0,
      updatedAt: json["updatedAt"] == null
        ? null: DateTime.parse(json["updatedAt"]),
      createdAt: json["createdAt"] == null
        ? null: DateTime.parse(json["createdAt"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "type": type,
    "category": category?.toJson(),

    "title": title,
    "description": description,
    "url": url,
    "youtubeVideoId": youtubeVideoId,
    "content": content,

    "image": image?.toJson(),
    "gallery": gallery == null
      ? null: List<FileModel>.from(gallery!.map((x) => x.toJson())),

    "relatedPartnerShops": List<PartnerShopModel>
      .from(relatedPartnerShops.map((e) => e.toJson())),
    "relatedPartnerProductCategories": List<PartnerProductCategoryModel>
      .from(relatedPartnerProductCategories.map((e) => e.toJson())),
    "relatedPartnerProducts": List<PartnerProductModel>
      .from(relatedPartnerProducts.map((e) => e.toJson())),
    "relatedPartnerProductCoupons": List<PartnerProductCouponModel>
      .from(relatedPartnerProductCoupons.map((e) => e.toJson())),

    "order": order,
    "status": status,
    "updatedAt": updatedAt == null? null: updatedAt!.toIso8601String(),
    "createdAt": createdAt == null? null: createdAt!.toIso8601String(),
  };

  bool isValid() {
    return id != null? true: false;
  }
}
