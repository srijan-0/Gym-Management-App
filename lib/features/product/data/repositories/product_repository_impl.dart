import 'package:dartz/dartz.dart';

import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../data_sources/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<ProductEntity>>> getAllProducts() async {
    try {
      final List<ProductModel> products =
          await remoteDataSource.getAllProducts();

      // ✅ Convert List<ProductModel> to List<ProductEntity>
      final List<ProductEntity> productEntities = products.map((product) {
        return ProductEntity(
          id: product.id,
          name: product.name,
          description: product.description,
          price: product.price,
          quantity: product.quantity,
          categoryId: product.categoryId,
          categoryName: product.categoryName,
          images: product.images,
          status: product.status,
          ratingsReviews: product.ratingsReviews,
        );
      }).toList();

      return Right(productEntities);
    } catch (e) {
      return Left("Failed to fetch products: ${e.toString()}");
    }
  }
}
