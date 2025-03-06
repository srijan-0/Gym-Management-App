import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/features/cart/domain/entities/cart_entity.dart';
import 'package:login/features/cart/domain/repositories/cart_repository.dart';
import 'package:login/features/cart/domain/usecases/get_cart_items.dart';
import 'package:mocktail/mocktail.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late GetCartItemsUseCase getCartItemsUseCase;
  late MockCartRepository mockCartRepository;

  setUp(() {
    mockCartRepository = MockCartRepository();
    getCartItemsUseCase = GetCartItemsUseCase(mockCartRepository);
  });

  final testCartItems = [
    CartEntity(
      productId: "1",
      productName: "Laptop",
      productImage: "https://example.com/laptop.png",
      quantity: 1,
      price: 999.99,
    ),
    CartEntity(
      productId: "2",
      productName: "Phone",
      productImage: "https://example.com/phone.png",
      quantity: 2,
      price: 699.99,
    ),
  ];

  test(' should return a list of cart items when successful', () async {
    when(() => mockCartRepository.getCartItems())
        .thenAnswer((_) async => Future.value(Right(testCartItems)));

    final result = await getCartItemsUseCase();

    expect(result, Right(testCartItems));

    verify(() => mockCartRepository.getCartItems()).called(1);
  });

  test(' should return an error message when fetching cart items fails',
      () async {
    when(() => mockCartRepository.getCartItems()).thenAnswer(
        (_) async => Future.value(Left("Failed to fetch cart items")));

    final result = await getCartItemsUseCase();

    expect(result, Left("Failed to fetch cart items"));

    verify(() => mockCartRepository.getCartItems()).called(1);
  });
}
