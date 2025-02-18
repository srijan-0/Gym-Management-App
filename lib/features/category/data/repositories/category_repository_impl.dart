import 'package:dartz/dartz.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../data_sources/category_remote_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<CategoryEntity>>> getAllCategories() async {
    try {
      final categories = await remoteDataSource.getAllCategories();

      // ✅ Convert CategoryModel to CategoryEntity
      final List<CategoryEntity> categoryEntities = categories
          .map((category) => CategoryEntity(
                id: category.id,
                cName: category.cName,
                cDescription: category.cDescription,
                cImage: category.cImage,
                cStatus: category.cStatus,
              ))
          .toList();

      return Right(categoryEntities);
    } catch (e) {
      return Left("Failed to fetch categories");
    }
  }
}
