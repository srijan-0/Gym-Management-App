import 'package:dartz/dartz.dart';

import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class GetCartItemsUseCase {
  final CartRepository repository;

  GetCartItemsUseCase(this.repository);

  Future<Either<String, List<CartEntity>>> call() {
    return repository.getCartItems();
  }
}
