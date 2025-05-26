import 'dart:convert';

SubdistrictModel subdistrictModelFromJson(String str) =>
  SubdistrictModel.fromJson(json.decode(str));
String subdistrictModelToJson(SubdistrictModel model) =>
  json.encode(model.toJson());

class SubdistrictModel {
  SubdistrictModel({
    this.id = '',
    this.district = '',
    this.districtId = '',
    this.name = '',
    this.lat,
    this.lng,
    this.zipcodes = const [],
  });

  String id;
  String district;
  String districtId;
  String name;
  double? lat;
  double? lng;
  List<String> zipcodes;

  factory SubdistrictModel.fromJson(Map<String, dynamic> json) => SubdistrictModel(
    id: json['_id'] ?? '',
    district: json['district'] ?? '',
    districtId: '${json['districtId'] ?? ''}',
    name: json['name'] ?? '',
    lat: json['lat'] == null || json['lat'] == '\\N'
      ? null: double.parse(json['lat'].toString()),
    lng: json['lng'] == null || json['lng'] == '\\N'
      ? null: double.parse(json['lat'].toString()),
    zipcodes: json['zipcodes'] == null || json['zipcodes'] is String? []: List<String>.from(json['zipcodes'].map((e) => '$e')),
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'district': district,
    'districtId': districtId,
    'name': name,
    'lat': lat,
    'lng': lng,
    'zipcodes': zipcodes.isEmpty? []: zipcodes.map((e) => e).toList(),
  };

  bool isValid() {
    return id != ''? true: false;
  }
}
