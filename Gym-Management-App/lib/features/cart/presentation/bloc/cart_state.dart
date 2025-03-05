part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<CartEntity> cartItems;
  final double totalPrice;
  final String? error;

  const CartState({
    required this.cartItems,
    required this.totalPrice,
    this.error,
  });

  factory CartState.initial() {
    return const CartState(
      cartItems: [],
      totalPrice: 0.0,
      error: null,
    );
  }

  CartState copyWith({
    List<CartEntity>? cartItems,
    double? totalPrice,
    String? error,
  }) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
      totalPrice: totalPrice ?? this.totalPrice,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [cartItems, totalPrice, error];
}
