import '../../domain/entities/cart_entity.dart';

class CartModel extends CartEntity {
  const CartModel({
    required super.productId,
    required super.productName,
    required super.productImage,
    required super.quantity,
    required super.price,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      productId: json['id'],
      productName: json['pName'],
      productImage: json['pImages'][0], // Assuming first image is used
      quantity: json['quantity'],
      price: json['pPrice'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": productId,
      "quantity": quantity,
    };
  }
}
