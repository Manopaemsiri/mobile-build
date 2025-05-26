import 'dart:convert';

DistrictModel districtModelFromJson(String str) =>
  DistrictModel.fromJson(json.decode(str));
String districtModelToJson(DistrictModel model) => 
  json.encode(model.toJson());

class DistrictModel {
  DistrictModel({
    this.id = '',
    this.provinceId = '',
    this.name = '',
    this.lat,
    this.lng,
  });
  String id;
  String provinceId;
  String name;
  double? lat;
  double? lng;

  factory DistrictModel.fromJson(Map<String, dynamic> json) => DistrictModel(
    id: json['_id'] ?? '',
    provinceId: '${json['provinceId'] ?? ''}',
    name: json['name'] ?? '',
    lat: json['lat'] == null || json['lat'] == '\\N'
      ? null: double.parse(json['lat'].toString()),
    lng: json['lng'] == null || json['lng'] == '\\N'
      ? null: double.parse(json['lat'].toString()),
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'provinceId': provinceId,
    'name': name,
    'lat': lat,
    'lng': lng,
  };

  bool isValid() {
    return id != ''? true: false;
  }

 

}