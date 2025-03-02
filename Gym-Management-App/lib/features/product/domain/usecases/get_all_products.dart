import 'package:dartz/dartz.dart';

import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetAllProducts {
  final ProductRepository repository;

  GetAllProducts(this.repository);

  Future<Either<String, List<ProductEntity>>> call() {
    return repository.getAllProducts();
  }
}
