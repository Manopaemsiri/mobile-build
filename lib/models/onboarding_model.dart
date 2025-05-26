// To parse this JSON data, do
//
//     final onboardingModel = onboardingModelFromJson(jsonString);

import 'dart:convert';

OnboardingModel onboardingModelFromJson(String str) =>
    OnboardingModel.fromJson(json.decode(str));

String onboardingModelToJson(OnboardingModel data) =>
    json.encode(data.toJson());

class OnboardingModel {
  OnboardingModel({
    required this.heading,
    required this.title,
    required this.body,
    required this.image,
    this.note,
  });

  final String heading;
  final String title;
  final String body;
  final String image;
  final String? note;

  factory OnboardingModel.fromJson(Map<String, dynamic> json) =>
    OnboardingModel(
      heading: json["heading"],
      title: json["title"],
      body: json["body"],
      image: json["image"],
      note: json["note"],
    );

  Map<String, dynamic> toJson() => {
      "heading": heading,
      "title": title,
      "body": body,
      "image": image,
      "note": note,
    };
}
