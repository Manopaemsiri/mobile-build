import 'dart:convert';

ApiData apiDataFromJson(String str) => ApiData.fromJson(json.decode(str));
String apiDataToJson(ApiData data) => json.encode(data.toJson());

class ApiData {
  ApiData({this.message, this.data});
  String? message;
  DataModel? data;

  factory ApiData.fromJson(Map<String, dynamic> json) => ApiData(
      message: json["message"].toString(),
      data: json["data"] == null ? null : DataModel.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class DataModel {
  DataModel({this.result, this.paginate, this.dataFilter});

  List<dynamic>? result;
  Map<String, dynamic>? paginate;
  Map<String, dynamic>? dataFilter;

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        result: json["result"] == null
            ? null
            : List<dynamic>.from(json["result"].map((x) => x)),
        paginate: json["paginate"] ?? {"page": 1, "pp": 10, "total": 0},
        dataFilter: json["dataFilter"] ?? {},
      );

  Map<String, dynamic> toJson() => {
        "result":
            result == null ? null : List<dynamic>.from(result!.map((x) => x)),
        "paginate":
            paginate == null ? null : Map<String, dynamic>.from(paginate!),
        "dataFilter":
            dataFilter == null ? null : Map<String, dynamic>.from(dataFilter!),
      };
}
