import 'package:coffee2u/models/index.dart';
import 'package:html_unescape/html_unescape_small.dart';

class PartnerShopClickCollectModel extends PartnerShopModel {
  PartnerShopClickCollectModel({
    id,
    code,
    erpCode,
    erpEmployeeCode,
    name,
    nameEN,
    description,
    type,
    url,
    image,
    gallery,
    email,
    address,
    telephones,
    line,
    facebook,
    instagram,
    website,
    workingHours,
    status,
    distance,
    this.shortages
  });
  final List<dynamic>? shortages;

  @override
  factory PartnerShopClickCollectModel.fromJson(Map<String, dynamic> json){
    var unescape = HtmlUnescape();
    return PartnerShopClickCollectModel(
      id: json["_id"],
      code: json["code"] ?? '',
      erpCode: json["erpCode"] ?? '',
      erpEmployeeCode: json["erpEmployeeCode"] ?? '',
      
      name: json["name"]==null? '': unescape.convert(json["name"]),
      nameEN: json["nameEN"]==null? '': unescape.convert(json["nameEN"]),
      description: json["description"]==null? '': unescape.convert(json["description"]),
      
      type: json["type"] ?? 0,
      url: json["url"] ?? '',
      
      image: json["image"] == null || json["image"] is String
        ? null: FileModel.fromJson(json["image"]),
      gallery: json["gallery"] == null || json["gallery"] is String? null
        : List<FileModel>.from(json["gallery"]
          .where((e) => e is! String)
          .map((e) => FileModel.fromJson(e))),
      
      email: json["email"],
      address: json["address"] != null && json["address"] is! String
        ? CustomerShippingAddressModel.fromJson(json["address"]) 
        : null,
      telephones: json["telephones"] == null || json["telephones"] is String
        ? null: List<String>.from(json["telephones"].map((x) => x)),
      line: json["line"] ?? '',
      facebook: json["facebook"] ?? '',
      instagram: json["instagram"] ?? '',
      website: json["website"] ?? '',
      
      workingHours: json["workingHours"] != null && json["workingHours"] is! String
        ? List<WorkingHourModel>.from(
          json["workingHours"].map((x) => WorkingHourModel.fromJson(x)))
        : [],
      
      status: json["status"],
      distance: json["distance"] == null || json["distance"] == 999999
        ? null: double.parse(json["distance"].toStringAsFixed(1)),
      
      shortages: json["shortages"] ?? [],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    "shortages": shortages,
  };
}