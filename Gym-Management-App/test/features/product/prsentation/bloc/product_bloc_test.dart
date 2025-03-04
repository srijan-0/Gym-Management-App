import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/features/product/domain/entities/product_entity.dart';
import 'package:login/features/product/domain/usecases/get_all_products.dart';
import 'package:login/features/product/prsentation/bloc/product_bloc.dart';
import 'package:login/features/product/prsentation/bloc/product_event.dart';
import 'package:login/features/product/prsentation/bloc/product_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllProducts extends Mock implements GetAllProducts {}

void main() {
  late ProductBloc productBloc;
  late MockGetAllProducts mockGetAllProducts;

  setUp(() {
    mockGetAllProducts = MockGetAllProducts();
    productBloc = ProductBloc(getAllProducts: mockGetAllProducts);
  });

  tearDown(() {
    productBloc.close();
  });

  final testProducts = [
    ProductEntity(
      id: "1",
      name: "Product 1",
      description: "Description 1",
      price: 10.0,
      quantity: 5,
      categoryId: "c1",
      categoryName: "Category 1",
      images: ["image1.jpg"],
      status: "available",
      ratingsReviews: [],
    ),
    ProductEntity(
      id: "2",
      name: "Product 2",
      description: "Description 2",
      price: 20.0,
      quantity: 10,
      categoryId: "c2",
      categoryName: "Category 2",
      images: ["image2.jpg"],
      status: "available",
      ratingsReviews: [],
    ),
  ];

  group('ProductBloc Tests', () {
    test('Initial state should be ProductInitial', () {
      expect(productBloc.state, ProductInitial());
    });

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductLoaded] when FetchProducts is successful',
      build: () {
        when(() => mockGetAllProducts()).thenAnswer(
          (_) async => Right(testProducts),
        );
        return productBloc;
      },
      act: (bloc) => bloc.add(FetchProducts()),
      expect: () => [
        ProductLoading(),
        ProductLoaded(testProducts),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductError] when FetchProducts fails',
      build: () {
        when(() => mockGetAllProducts()).thenAnswer(
          (_) async => Left("Failed to fetch products"),
        );
        return productBloc;
      },
      act: (bloc) => bloc.add(FetchProducts()),
      expect: () => [
        ProductLoading(),
        ProductError("Failed to fetch products"),
      ],
    );
  });
}
