import 'dart:convert';

import 'package:flutter/foundation.dart'; //
import 'package:http/http.dart' as http;

import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  static const String baseUrl = "http://10.0.2.2:8000/api/product/";

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final response = await client.get(Uri.parse("${baseUrl}all-product"));

    debugPrint("API Response: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)["Products"];
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch products");
    }
  }
}
