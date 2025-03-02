import 'package:dartz/dartz.dart';
import 'package:login/features/cart/domain/entities/cart_entity.dart';
import 'package:login/features/cart/domain/repositories/cart_repository.dart';

class GetCartItemsUseCase {
  final CartRepository repository;

  // ✅ Corrected Constructor Syntax
  GetCartItemsUseCase(this.repository);

  // ✅ Call Function to Fetch Cart Items
  Future<Either<String, List<CartEntity>>> call() {
    return repository.getCartItems();
  }
}
