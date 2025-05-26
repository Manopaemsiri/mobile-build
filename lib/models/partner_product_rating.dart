import 'dart:convert';
import 'package:coffee2u/models/index.dart';

PartnerProductRatingModel partnerProductRatingFromJson(String str) => PartnerProductRatingModel.fromJson(json.decode(str));

String partnerProductRatingToJson(PartnerProductRatingModel data) => json.encode(data.toJson());

class PartnerProductRatingModel {
  String? id;
  CustomerOrderModel? order;
  List<PartnerProductModel>? products;
  CustomerModel? customer;
  PartnerShopModel? shop;
  double? rating;
  String? comment;
  List<FileModel>? images;
  int isShown;
  int isAnonymous;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  PartnerProductRatingModel({
    this.id,
    this.order,
    this.products,
    this.customer,
    this.shop,
    this.rating,
    this.comment,
    this.images,
    this.isShown = 1,
    this.isAnonymous = 0,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  PartnerProductRatingModel copyWith({
    String? id,
    CustomerOrderModel? order,
    List<PartnerProductModel>? products,
    CustomerModel? customer,
    PartnerShopModel? shop,
    double? rating,
    String? comment,
    List<FileModel>? images,
    int? isShown,
    int? isAnonymous,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) => PartnerProductRatingModel(
    id: id ?? this.id,
    order: order ?? this.order,
    products: products ?? this.products,
    customer: customer ?? this.customer,
    shop: shop ?? this.shop,
    rating: rating ?? this.rating,
    comment: comment ?? this.comment,
    images: images ?? this.images,
    isShown: isShown ?? this.isShown,
    isAnonymous: isAnonymous ?? this.isAnonymous,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
  );

  factory PartnerProductRatingModel.fromJson(Map<String, dynamic> json) => PartnerProductRatingModel(
    id: json["_id"],
    order: json["order"] == null || json["order"] is String? null : CustomerOrderModel.fromJson(json["order"]),
    products: json["products"] == null? [] : List<PartnerProductModel>.from(json["products"]!.map((x) => PartnerProductModel.fromJson(x))),
    customer: json["customer"] == null || json["customer"] is String? null : CustomerModel.fromJson(json["customer"]),
    shop: json["shop"] == null || json["shop"] is String? null : PartnerShopModel.fromJson(json["shop"]),
    rating: json["rating"] == null? 0: double.parse(json["rating"].toString()),
    comment: json["comment"],
    images: json["images"] == null ? [] : List<FileModel>.from(json["images"]!.map((x) => FileModel.fromJson(x))),
    isShown: json["isShown"] == null? 1: int.parse(json["isShown"].toString()),
    isAnonymous: json["isAnonymous"] == null? 0: int.parse(json["isAnonymous"].toString()),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
      "_id": id,
      "order": order,
      "products": products == null ? [] : List<PartnerProductModel>.from(products!.map((x) => x)),
      "customer": customer?.toJson(),
      "shop": shop,
      "rating": rating,
      "comment": comment,
      "images": images == null ? [] : List<FileModel>.from(images!.map((x) => x)),
      "isShown": isShown,
      "isAnonymous": isAnonymous,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "__v": v,
  };

  isValid() => id?.isNotEmpty;
}
