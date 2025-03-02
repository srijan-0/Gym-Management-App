import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/cart_model.dart';

abstract class CartRemoteDataSource {
  Future<void> addToCart(CartModel cartItem);

  getCartItems() {}

  removeFromCart(String productId) {}
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final http.Client client;
  static const String baseUrl = "http://10.0.2.2:8000/api/order/";

  CartRemoteDataSourceImpl({required this.client});

  @override
  Future<void> addToCart(CartModel cartItem) async {
    final response = await client.post(
      Uri.parse("${baseUrl}create-order"),
      body: jsonEncode({
        "allProduct": [
          {"id": cartItem.productId, "quantity": cartItem.quantity}
        ],
        "user": "USER_ID", // Replace with actual user ID
        "amount": cartItem.price * cartItem.quantity,
        "address": "User Address", // Replace with actual address
        "phone": "User Phone" // Replace with actual phone number
      }),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to add item to cart");
    }
  }

  @override
  getCartItems() {
    // TODO: implement getCartItems
    throw UnimplementedError();
  }

  @override
  removeFromCart(String productId) {
    // TODO: implement removeFromCart
    throw UnimplementedError();
  }
}
