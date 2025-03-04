import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/features/product/domain/entities/product_entity.dart';
import 'package:login/features/product/domain/repositories/product_repository.dart';
import 'package:login/features/product/domain/usecases/get_all_products.dart';
import 'package:mocktail/mocktail.dart';

/// Mock Class
class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late GetAllProducts getAllProducts;
  late MockProductRepository mockProductRepository;

  setUpAll(() {
    registerFallbackValue(
      ProductEntity(
        id: "1",
        name: "Laptop",
        description: "A high-performance laptop",
        price: 999.99,
        quantity: 5,
        categoryId: "10",
        categoryName: "Electronics",
        images: ["https://example.com/image1.png"],
        status: "Available",
        ratingsReviews: [],
      ),
    );
  });

  setUp(() {
    mockProductRepository = MockProductRepository();
    getAllProducts = GetAllProducts(mockProductRepository);
  });

  /// **Test Data**
  final testProducts = [
    ProductEntity(
      id: "1",
      name: "Laptop",
      description: "A high-performance laptop",
      price: 999.99,
      quantity: 5,
      categoryId: "10",
      categoryName: "Electronics",
      images: ["https://example.com/image1.png"],
      status: "Available",
      ratingsReviews: [],
    ),
    ProductEntity(
      id: "2",
      name: "Smartphone",
      description: "A latest-gen smartphone",
      price: 799.99,
      quantity: 10,
      categoryId: "10",
      categoryName: "Electronics",
      images: ["https://example.com/image2.png"],
      status: "Available",
      ratingsReviews: [],
    ),
  ];

  test('should return a list of products when successful', () async {
    when(() => mockProductRepository.getAllProducts())
        .thenAnswer((_) async => Future.value(Right(testProducts)));

    final result = await getAllProducts();

    expect(result, Right(testProducts));

    verify(() => mockProductRepository.getAllProducts()).called(1);
  });

  test('should return an error message when fetching products fails', () async {
    when(() => mockProductRepository.getAllProducts()).thenAnswer(
        (_) async => Future.value(Left("Failed to fetch products")));

    final result = await getAllProducts();

    expect(result, Left("Failed to fetch products"));

    verify(() => mockProductRepository.getAllProducts()).called(1);
  });
}
