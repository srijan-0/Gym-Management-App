import 'package:dartz/dartz.dart';

import '../../domain/entities/cart_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../data_sources/cart_remote_data_source.dart';
import '../models/cart_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<CartEntity>>> getCartItems() async {
    try {
      final items = await remoteDataSource.getCartItems();
      return Right(items);
    } catch (e) {
      return Left("Failed to fetch cart items");
    }
  }

  @override
  Future<Either<String, void>> addToCart(CartEntity cartItem) async {
    try {
      await remoteDataSource.addToCart(CartModel(
        productId: cartItem.productId,
        productName: cartItem.productName,
        productImage: cartItem.productImage,
        quantity: cartItem.quantity,
        price: cartItem.price,
      ));
      return const Right(null);
    } catch (e) {
      return Left("Failed to add to cart");
    }
  }

  @override
  Future<Either<String, void>> removeFromCart(String productId) async {
    try {
      await remoteDataSource.removeFromCart(productId);
      return const Right(null);
    } catch (e) {
      return Left("Failed to remove from cart");
    }
  }
}
