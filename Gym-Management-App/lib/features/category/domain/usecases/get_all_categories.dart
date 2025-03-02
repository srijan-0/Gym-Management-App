import 'package:dartz/dartz.dart';

import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class GetAllCategories {
  final CategoryRepository repository;

  GetAllCategories(this.repository);

  Future<Either<String, List<CategoryEntity>>> call() {
    return repository.getAllCategories();
  }
}
