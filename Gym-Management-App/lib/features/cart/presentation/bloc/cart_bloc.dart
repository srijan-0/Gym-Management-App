import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:login/features/cart/domain/entities/cart_entity.dart';
import 'package:login/features/cart/presentation/bloc/cart_event.dart';

part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState.initial()) {
    on<GetCartItemsEvent>(_onGetCartItems);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
  }

  void _onGetCartItems(GetCartItemsEvent event, Emitter<CartState> emit) {
    // Simulate fetching cart items (you might replace this with a repository call)
    emit(state.copyWith(
      cartItems: state.cartItems,
      totalPrice: _calculateTotalPrice(state.cartItems),
      error: null,
    ));
  }

  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) {
    final updatedCartItems = List<CartEntity>.from(state.cartItems)
      ..add(event.cartItem);
    emit(state.copyWith(
      cartItems: updatedCartItems,
      totalPrice: _calculateTotalPrice(updatedCartItems),
      error: null,
    ));
  }

  void _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) {
    final updatedCartItems = state.cartItems
        .where((item) => item.productId != event.productId)
        .toList();
    emit(state.copyWith(
      cartItems: updatedCartItems,
      totalPrice: _calculateTotalPrice(updatedCartItems),
      error: null,
    ));
  }

  double _calculateTotalPrice(List<CartEntity> cartItems) {
    return cartItems.fold(0.0, (total, item) => total + item.price);
  }
}
