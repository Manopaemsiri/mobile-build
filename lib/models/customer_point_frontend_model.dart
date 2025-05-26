import 'dart:convert';

CustomerPointFrontendModel customerPointFrontendModelFromJson(String str) => 
  CustomerPointFrontendModel.fromJson(json.decode(str));
String customerPointFrontendModelToJson(CustomerPointFrontendModel model) => 
  json.encode(model.toJson());

class CustomerPointFrontendModel {
  CustomerPointFrontendModel({
    this.points = 0,
    this.discount = 0,
  });

  double points;
  double discount;

  factory CustomerPointFrontendModel.fromJson(Map<String, dynamic> json) => 
    CustomerPointFrontendModel(
      points: json["points"] ?? 0,
      discount: json["discount"] ?? 0,
    );

  Map<String, dynamic> toJson() => {
    "points": points,
    "discount": discount,
  };
}