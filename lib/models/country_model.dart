
class CountryModel{
   CountryModel({
    this.id  = '',
    this.name = '',
    this.countryCode = '',
    this.telephoneCode = '',
    this.lat ,
    this.lng,
   });
  String id;
  String name;
  String countryCode;
  String telephoneCode;
  double? lat;
  double? lng;

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
    id: json["_id"] ?? "",
    name: json["name"] ?? "",
    countryCode: json["countryCode"] ?? "",
    telephoneCode: json["telephoneCode"] ?? "",
    lat: json["lat"] == null || json["lat"] == "\\N"
      ? null: double.parse(json["lat"].toString()),
    lng: json["lng"] == null || json["lng"] == "\\N"
      ? null: double.parse(json["lat"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "countryCode": countryCode,
    "telephoneCode": telephoneCode,
    "lat": lat,
    "lng": lng,
  };

  isValid() {
    return id != ''? true: false;
  }

}