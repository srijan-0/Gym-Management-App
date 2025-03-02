import 'package:dartz/dartz.dart';

import '../entities/cart_entity.dart';

abstract class CartRepository {
  Future<Either<String, void>> addToCart(CartEntity cartItem);
  Future<Either<String, void>> removeFromCart(String productId);
  Future<Either<String, List<CartEntity>>> getCartItems();
}
