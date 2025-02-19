import 'package:equatable/equatable.dart';

class CartEntity extends Equatable {
  final String productId;
  final String productName;
  final String productImage;
  final int quantity;
  final double price;

  const CartEntity({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.price,
  });

  @override
  List<Object> get props =>
      [productId, productName, productImage, quantity, price];
}
