import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String cName;
  final String cDescription;
  final String cImage;
  final String cStatus;

  CategoryModel({
    required this.id,
    required this.cName,
    required this.cDescription,
    required this.cImage,
    required this.cStatus,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    debugPrint("Parsing Category JSON: $json"); // ✅ Debugging JSON parsing

    return CategoryModel(
      id: json["_id"] ?? '', // ✅ Ensure "_id" is mapped correctly
      cName: json["cName"] ?? 'No Name', // ✅ Default if null
      cDescription: json["cDescription"] ?? 'No Description',
      cImage: json["cImage"] ?? '', // ✅ Avoid null images
      cStatus: json["cStatus"] ?? 'inactive',
    );
  }
}
