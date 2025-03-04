import 'package:login/features/product/domain/entities/product_entity.dart';

class CartManager {
  static final CartManager _instance = CartManager._internal();

  factory CartManager() => _instance;

  CartManager._internal();

  final List<ProductEntity> _cartItems = [];

  List<ProductEntity> get cartItems => _cartItems;

  void addToCart(ProductEntity product) {
    _cartItems.add(product);
  }

  void clearCart() {
    _cartItems.clear();
  }

  void removeFromCart(ProductEntity product) {
    _cartItems.remove(product);
  }

  double get totalPrice => _cartItems.fold(0, (sum, item) => sum + item.price);
}
