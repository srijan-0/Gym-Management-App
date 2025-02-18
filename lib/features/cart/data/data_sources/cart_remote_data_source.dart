import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/cart_model.dart';

abstract class CartRemoteDataSource {
  Future<List<CartModel>> getCartItems();
  Future<void> addToCart(CartModel cartItem);
  Future<void> removeFromCart(String productId);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final http.Client client;
  static const String baseUrl = "http://10.0.2.2:8000/api/order/";

  CartRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CartModel>> getCartItems() async {
    final response = await client.get(Uri.parse("${baseUrl}order-by-user"));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['Order'];
      return data.map((json) => CartModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch cart items");
    }
  }

  @override
  Future<void> addToCart(CartModel cartItem) async {
    final response = await client.post(
      Uri.parse("${baseUrl}create-order"),
      body: jsonEncode({
        "allProduct": [cartItem.toJson()]
      }),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to add item to cart");
    }
  }

  @override
  Future<void> removeFromCart(String productId) async {
    final response = await client.post(
      Uri.parse("${baseUrl}delete-order"),
      body: jsonEncode({"oId": productId}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to remove item from cart");
    }
  }
}
