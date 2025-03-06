import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/features/category/domain/entities/category_entity.dart';
import 'package:login/features/category/domain/repositories/category_repository.dart';
import 'package:login/features/category/domain/usecases/get_all_categories.dart';
import 'package:mocktail/mocktail.dart';

/// Mock Class
class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  late GetAllCategories getAllCategories;
  late MockCategoryRepository mockCategoryRepository;

  setUpAll(() {
    registerFallbackValue(
      CategoryEntity(
        id: "1",
        cName: "Electronics",
        cDescription: "Devices and gadgets",
        cImage: "https://example.com/image.png",
        cStatus: "Active",
      ),
    );
  });

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    getAllCategories = GetAllCategories(mockCategoryRepository);
  });

  /// **Test Data**
  final testCategories = [
    CategoryEntity(
      id: "1",
      cName: "Electronics",
      cDescription: "Devices and gadgets",
      cImage: "https://example.com/image1.png",
      cStatus: "Active",
    ),
    CategoryEntity(
      id: "2",
      cName: "Clothing",
      cDescription: "Fashion and apparel",
      cImage: "https://example.com/image2.png",
      cStatus: "Active",
    ),
  ];

  test('should return a list of categories when successful', () async {
    when(() => mockCategoryRepository.getAllCategories())
        .thenAnswer((_) async => Future.value(Right(testCategories)));

    final result = await getAllCategories();

    expect(result, Right(testCategories));

    verify(() => mockCategoryRepository.getAllCategories()).called(1);
  });

  test('should return an error message when fetching categories fails',
      () async {
    when(() => mockCategoryRepository.getAllCategories()).thenAnswer(
        (_) async => Future.value(Left("Failed to fetch categories")));

    final result = await getAllCategories();

    expect(result, Left("Failed to fetch categories"));

    verify(() => mockCategoryRepository.getAllCategories()).called(1);
  });
}
