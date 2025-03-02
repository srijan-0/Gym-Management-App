import 'package:dartz/dartz.dart';

import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  Future<Either<String, void>> call(CartEntity cartItem) {
    return repository.addToCart(cartItem);
  }
}
