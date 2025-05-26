import 'dart:convert';
import 'package:coffee2u/models/index.dart';
import 'package:html_unescape/html_unescape.dart';

SellerShopRatingModel sellerShopRatingModelFromJson(String str) =>
  SellerShopRatingModel.fromJson(json.decode(str));
String sellerShopRatingModelToJson(SellerShopRatingModel model) =>
  json.encode(model.toJson());

class SellerShopRatingModel {
  SellerShopRatingModel({
    this.id,
    this.customer,
    this.rating = 0,
    this.comment = '',
    this.images = const [],
    this.isShown = 0,
    this.createdAt,
  });

  String? id;
  CustomerModel? customer;
  int rating;
  String comment;
  List<FileModel> images;
  int isShown;
  DateTime? createdAt;

  factory SellerShopRatingModel.fromJson(Map<String, dynamic> json){
    var unescape = HtmlUnescape();
    return SellerShopRatingModel(
      id: json["_id"],
      customer: json["customer"] != null && json["customer"] is! String
        ? CustomerModel.fromJson(json["customer"]) 
        : null,
      rating: json["rating"] ?? 0,
      comment: json["comment"]==null? '': unescape.convert(json["comment"]),
      images: json["images"] == null || json["images"] is String? []
        : List<FileModel>.from(json["images"]
          .where((e) => e is! String)
          .map((e) => FileModel.fromJson(e))),
      isShown: json["isShown"] ?? 0,
      createdAt: json["createdAt"] == null
        ? null: DateTime.parse(json["createdAt"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "customer": customer!.toJson(),
    "rating": rating,
    "comment": comment,
    "images": List<Map<String, dynamic>>
      .from(images.map((x) => x.toJson())),
    "isShown": isShown,
    "createdAt": createdAt == null
      ? null: createdAt!.toIso8601String(),
  };

  bool isValid() {
    return id != null? true: false;
  }
}