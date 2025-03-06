import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/features/cart/domain/entities/cart_entity.dart';
import 'package:login/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:login/features/cart/presentation/bloc/cart_event.dart';
import 'package:mocktail/mocktail.dart';

class MockCartEntity extends Mock implements CartEntity {}

void main() {
  late CartBloc cartBloc;

  setUp(() {
    cartBloc = CartBloc();
    registerFallbackValue(MockCartEntity());
  });

  tearDown(() {
    cartBloc.close();
  });

  group('CartBloc', () {
    blocTest<CartBloc, CartState>(
      'emits initial cart state when GetCartItemsEvent is triggered',
      build: () => cartBloc,
      act: (bloc) => bloc.add(GetCartItemsEvent()),
      expect: () => [
        const CartState(
          cartItems: [],
          totalPrice: 0.0,
          error: null,
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits updated cart state when AddToCartEvent is triggered',
      build: () => cartBloc,
      act: (bloc) => bloc.add(AddToCartEvent(CartEntity(
        productId: '1',
        productName: 'Test Product',
        productImage: 'image1.jpg',
        quantity: 1,
        price: 10.0,
      ))),
      expect: () => [
        const CartState(
          cartItems: [
            CartEntity(
              productId: '1',
              productName: 'Test Product',
              productImage: 'image1.jpg',
              quantity: 1,
              price: 10.0,
            ),
          ],
          totalPrice: 10.0,
          error: null,
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits updated cart state with multiple items when AddToCartEvent is triggered multiple times',
      build: () => cartBloc,
      act: (bloc) {
        bloc.add(AddToCartEvent(CartEntity(
          productId: '1',
          productName: 'Test Product 1',
          productImage: 'image1.jpg',
          quantity: 1,
          price: 10.0,
        )));
        bloc.add(AddToCartEvent(CartEntity(
          productId: '2',
          productName: 'Test Product 2',
          productImage: 'image2.jpg',
          quantity: 1,
          price: 15.0,
        )));
      },
      expect: () => [
        const CartState(
          cartItems: [
            CartEntity(
              productId: '1',
              productName: 'Test Product 1',
              productImage: 'image1.jpg',
              quantity: 1,
              price: 10.0,
            ),
          ],
          totalPrice: 10.0,
          error: null,
        ),
        const CartState(
          cartItems: [
            CartEntity(
              productId: '1',
              productName: 'Test Product 1',
              productImage: 'image1.jpg',
              quantity: 1,
              price: 10.0,
            ),
            CartEntity(
              productId: '2',
              productName: 'Test Product 2',
              productImage: 'image2.jpg',
              quantity: 1,
              price: 15.0,
            ),
          ],
          totalPrice: 25.0,
          error: null,
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits updated cart state when RemoveFromCartEvent is triggered',
      build: () => cartBloc,
      seed: () => const CartState(
        cartItems: [
          CartEntity(
            productId: '1',
            productName: 'Test Product',
            productImage: 'image1.jpg',
            quantity: 1,
            price: 10.0,
          ),
        ],
        totalPrice: 10.0,
        error: null,
      ),
      act: (bloc) => bloc.add(RemoveFromCartEvent('1')),
      expect: () => [
        const CartState(
          cartItems: [],
          totalPrice: 0.0,
          error: null,
        ),
      ],
    );
  });
}
