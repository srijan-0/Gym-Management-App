import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/features/cart/domain/repositories/cart_repository.dart';
import 'package:login/features/cart/domain/usecases/remove_from_cart.dart';
import 'package:mocktail/mocktail.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late RemoveFromCartUseCase removeFromCartUseCase;
  late MockCartRepository mockCartRepository;

  setUp(() {
    mockCartRepository = MockCartRepository();
    removeFromCartUseCase = RemoveFromCartUseCase(mockCartRepository);
  });

  const testProductId = "1";

  test('should return void when item is successfully removed from cart',
      () async {
    when(() => mockCartRepository.removeFromCart(any()))
        .thenAnswer((_) async => Future.value(const Right(null)));

    final result = await removeFromCartUseCase(testProductId);

    expect(result, const Right(null));

    verify(() => mockCartRepository.removeFromCart(testProductId)).called(1);
  });

  test('should return error message when removing item from cart fails',
      () async {
    when(() => mockCartRepository.removeFromCart(any()))
        .thenAnswer((_) async => Future.value(Left("Failed to remove item")));

    final result = await removeFromCartUseCase(testProductId);

    expect(result, Left("Failed to remove item"));

    verify(() => mockCartRepository.removeFromCart(testProductId)).called(1);
  });
}
