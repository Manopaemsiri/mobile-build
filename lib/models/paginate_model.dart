import 'dart:convert';

PaginateModel paginateModelFromJson(String str) =>
    PaginateModel.fromJson(json.decode(str));
String paginateModelToJson(PaginateModel model) => json.encode(model.toJson());

class PaginateModel {
  PaginateModel({
    this.page,
    this.pp,
    this.total,
  });
  final int? page;
  final int? pp;
  final int? total;
  factory PaginateModel.fromJson(Map<String, dynamic> json) => PaginateModel(
    page: json["page"],
    pp: json["pp"],
    total: json["total"],
  );
  Map<String, dynamic> toJson() => {
    "page": page,
    "pp": pp,
    "total": total,
  };
}
