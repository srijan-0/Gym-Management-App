import 'package:dartz/dartz.dart';

import '../repositories/cart_repository.dart';

class RemoveFromCartUseCase {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  Future<Either<String, void>> call(String productId) {
    return repository.removeFromCart(productId);
  }
}
