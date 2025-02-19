import '../../domain/entities/cart_entity.dart';

class CartModel extends CartEntity {
  const CartModel({
    required super.productId,
    required super.productName,
    required super.productImage,
    required super.quantity,
    required super.price,
  });

  /// **🔹 Factory Constructor - Converts JSON to `CartModel`**
  factory CartModel.fromJson(Map<String, dynamic> json) {
    final productData = json['id'] ?? {}; // Handling potential null value
    return CartModel(
      productId: productData['_id'] ?? '', // Extract product ID
      productName: productData['pName'] ?? 'Unknown Product',
      productImage:
          (productData['pImages'] != null && productData['pImages'].isNotEmpty)
              ? productData['pImages'][0]
              : 'default.jpg', // Use first image or default image
      quantity: json['quantity'] ?? 1, // Default quantity to 1 if missing
      price: (productData['pPrice'] ?? 0).toDouble(), // Convert price to double
    );
  }

  /// **🔹 Converts `CartModel` to JSON (for API calls)**
  Map<String, dynamic> toJson() {
    return {
      "id": productId,
      "quantity": quantity,
    };
  }
}
