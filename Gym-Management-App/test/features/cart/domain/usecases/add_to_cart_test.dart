import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/features/cart/domain/entities/cart_entity.dart';
import 'package:login/features/cart/domain/repositories/cart_repository.dart';
import 'package:login/features/cart/domain/usecases/add_to_cart.dart';
import 'package:mocktail/mocktail.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late AddToCartUseCase addToCartUseCase;
  late MockCartRepository mockCartRepository;

  setUpAll(() {
    registerFallbackValue(
      CartEntity(
        productId: "1",
        productName: "Test Product",
        productImage: "https://example.com/image.png",
        quantity: 1,
        price: 20.0,
      ),
    );
  });

  setUp(() {
    mockCartRepository = MockCartRepository();
    addToCartUseCase = AddToCartUseCase(mockCartRepository);
  });

  const testCartItem = CartEntity(
    productId: "1",
    productName: "Test Product",
    productImage: "https://example.com/image.png",
    quantity: 1,
    price: 20.0,
  );

  test('✅ should return void when item is added successfully', () async {
    when(() => mockCartRepository.addToCart(any()))
        .thenAnswer((_) async => Future.value(const Right(null)));

    final result = await addToCartUseCase(testCartItem);

    expect(result, const Right(null));

    verify(() => mockCartRepository.addToCart(testCartItem)).called(1);
  });

  test('should return error message when adding item fails', () async {
    when(() => mockCartRepository.addToCart(any()))
        .thenAnswer((_) async => Future.value(Left("Failed to add item")));

    final result = await addToCartUseCase(testCartItem);

    expect(result, Left("Failed to add item"));

    verify(() => mockCartRepository.addToCart(testCartItem)).called(1);
  });
}
