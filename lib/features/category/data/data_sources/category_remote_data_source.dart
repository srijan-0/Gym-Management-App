import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getAllCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final http.Client client;
  static const String baseUrl =
      "http://10.0.2.2:8000/api/category/"; // For emulator
  // static const String baseUrl = "http://192.168.101.4:8000/api/category/";

  // ✅ Correct constructor initialization
  CategoryRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final response = await client.get(Uri.parse("${baseUrl}all-category"));

      debugPrint("API Response: ${response.body}"); // ✅ Print API response

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // ✅ Extract categories list from "Categories" key
        final List<dynamic> categoryList = jsonResponse["Categories"] ?? [];

        return categoryList
            .map((json) => CategoryModel.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to fetch categories: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
      throw Exception("Error fetching categories");
    }
  }
}
