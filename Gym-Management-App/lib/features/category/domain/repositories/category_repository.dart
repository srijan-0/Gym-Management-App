import 'package:dartz/dartz.dart';

import '../entities/category_entity.dart';

abstract class CategoryRepository {
  Future<Either<String, List<CategoryEntity>>> getAllCategories();
}
