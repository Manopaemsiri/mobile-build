import 'dart:convert';

ResApiRead resApiReadFromJson(String str) => ResApiRead.fromJson(json.decode(str));
String resApiReadToJson(ResApiRead data) => json.encode(data.toJson());

class ResApiRead {
  ResApiRead({
    this.message,
    this.data,
  });

  String? message;
  DataModelRead? data;

  factory ResApiRead.fromJson(Map<String, dynamic> json) => ResApiRead(
    message: json["message"] ?? '',
    data: json["data"] == null
      ? null: DataModelRead.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data!.toJson(),
  };
}

class DataModelRead {
  DataModelRead({
    this.result,
  });

  dynamic result;

  factory DataModelRead.fromJson(Map<String, dynamic> json) => DataModelRead(
    result: json["result"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
  };
}
