import 'dart:convert';

import 'package:coffee2u/controller/language_controller.dart';

WorkingHourModel workingHourModelFromJson(String str) =>
  WorkingHourModel.fromJson(json.decode(str));
String workingHourModelToJson(WorkingHourModel model) =>
  json.encode(model.toJson());

class WorkingHourModel {
  WorkingHourModel({
    this.dayIndex = 0,
    this.isOpened = 0,
    this.startTime,
    this.endTime,
  });

  int dayIndex;
  int isOpened;
  String? startTime;
  String? endTime;

  factory WorkingHourModel.fromJson(Map<String, dynamic> json) =>
    WorkingHourModel(
      dayIndex: json["dayIndex"] ?? 0,
      isOpened: json["isOpened"] ?? 0,
      startTime: json["startTime"],
      endTime: json["endTime"],
    );

  Map<String, dynamic> toJson() => {
    "dayIndex": dayIndex,
    "isOpened": isOpened,
    "startTime": startTime,
    "endTime": endTime,
  };

  String displayDay(LanguageController controller) {
    if(dayIndex == 0){
      return controller.getLang("Sunday");
    }else if(dayIndex == 1){
      return controller.getLang("Monday");
    }else if(dayIndex == 2){
      return controller.getLang("Tuesday");
    }else if(dayIndex == 3){
      return controller.getLang("Wednesday");
    }else if(dayIndex == 4){
      return controller.getLang("Thursday");
    }else if(dayIndex == 5){
      return controller.getLang("Friday");
    }else if(dayIndex == 6){
      return controller.getLang("Saturday");
    }else{
      return '';
    }
  }
}