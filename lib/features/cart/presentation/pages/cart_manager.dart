import 'package:login/features/product/domain/entities/product_entity.dart';

class CartManager {
  // Singleton instance
  static final CartManager _instance = CartManager._internal();

  // Factory constructor to return the same instance
  factory CartManager() => _instance;

  // Private constructor
  CartManager._internal();

  // Cart items list
  final List<ProductEntity> _cartItems = [];

  // Get cart items
  List<ProductEntity> get cartItems => _cartItems;

  // Add item to cart
  void addToCart(ProductEntity product) {
    _cartItems.add(product);
  }

  // Remove item from cart
  void removeFromCart(ProductEntity product) {
    _cartItems.remove(product);
  }

  // Get total price
  double get totalPrice => _cartItems.fold(0, (sum, item) => sum + item.price);
}
