import 'dart:convert';

import 'package:coffee2u/controller/language_controller.dart';

/*
  dayIndex :
    0 = วันอาทิตย์
    1 = วันจันทร์
    2 = วันอังคาร
    3 = วันพุธ
    4 = วันพฤหัสบดี
    5 = วันศุกร์
    6 = วันเสาร์
*/

PackingDayModel packingDayModelFromJson(String str) =>
    PackingDayModel.fromJson(json.decode(str));
String packingDayModelToJson(PackingDayModel model) =>
    json.encode(model.toJson());

class PackingDayModel {
  PackingDayModel({
    this.dayIndex,
    this.startTime,
    this.endTime,
    this.duration,
  });
  int? dayIndex;
  String? startTime;
  String? endTime;
  int? duration;

  factory PackingDayModel.fromJson(Map<String, dynamic> json) =>
    PackingDayModel(
      dayIndex: json["dayIndex"] == null
        ? null
        : int.parse(json["dayIndex"].toString().trim()),
      startTime: json["startTime"].toString().trim(),
      endTime: json["endTime"].toString().trim(),
      duration: json["duration"] == null
        ? null
        : int.parse(json["duration"].toString().trim()),
    );
  Map<String, dynamic> toJson() => {
    "dayIndex": dayIndex,
    "startTime": startTime,
    "endTime": endTime,
    "duration": duration,
  };

  displayDay(LanguageController controller) {
    if (dayIndex == null) {
      return '';
    } else {
      return [
        controller.getLang('Sunday'),
        controller.getLang('Monday'),
        controller.getLang('Tuesday'),
        controller.getLang('Wednesday'),
        controller.getLang('Thursday'),
        controller.getLang('Friday'),
        controller.getLang('Saturday')
      ][dayIndex!];
    }
  }
}
