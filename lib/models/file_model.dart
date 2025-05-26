import 'dart:convert';
import 'package:coffee2u/constants/app_constants.dart';

FileModel fileModelFromJson(String str) => FileModel.fromJson(json.decode(str));
String fileModelToJson(FileModel model) => json.encode(model.toJson());

class FileModel {
  FileModel({
    this.originalname = '',
    this.mimetype = '',
    this.filename = '',
    this.size = 0,
    this.path = '',
  });

  String originalname;
  String mimetype;
  String filename;
  int size;
  String path;

  factory FileModel.fromJson(Map<String, dynamic> json) => FileModel(
    originalname: json["originalname"] ?? '',
    mimetype: json["mimetype"] ?? '',
    filename: json["filename"] ?? '',
    size: json["size"] == null? 0: int.parse(json["size"].toString()),
    path: json["path"] == null
      ? '': json["path"].replaceFirst("http://localhost:4700/", cdnUrl),
  );

  Map<String, dynamic> toJson() => {
    "originalname": originalname,
    "mimetype": mimetype,
    "filename": filename,
    "size": size,
    "path": path,
  };

  bool isValid() {
    return originalname != '' && mimetype != '' && filename != '' 
      && path != ''? true: false;
  }
}