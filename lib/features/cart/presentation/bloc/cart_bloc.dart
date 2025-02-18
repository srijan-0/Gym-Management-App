import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/features/cart/domain/entities/cart_entity.dart';

import '../../domain/usecases/add_to_cart.dart';
import '../../domain/usecases/get_cart_items.dart';
import '../../domain/usecases/remove_from_cart.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItemsUseCase getCartItemsUseCase;
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;

  CartBloc({
    required this.getCartItemsUseCase,
    required this.addToCartUseCase,
    required this.removeFromCartUseCase,
  }) : super(CartLoading()) {
    on<GetCartItemsEvent>(_onGetCartItems);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
  }

  Future<void> _onGetCartItems(
      GetCartItemsEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    final Either<String, List<CartEntity>> result = await getCartItemsUseCase();
    result.fold(
      (failure) => emit(CartError(failure)),
      (items) => emit(CartLoaded(items)),
    );
  }

  Future<void> _onAddToCart(
      AddToCartEvent event, Emitter<CartState> emit) async {
    final Either<String, void> result = await addToCartUseCase(event.cartItem);
    result.fold(
      (failure) => emit(CartError(failure)),
      (_) => add(GetCartItemsEvent()), // Fetch updated cart after adding
    );
  }

  Future<void> _onRemoveFromCart(
      RemoveFromCartEvent event, Emitter<CartState> emit) async {
    final Either<String, void> result =
        await removeFromCartUseCase(event.productId);
    result.fold(
      (failure) => emit(CartError(failure)),
      (_) => add(GetCartItemsEvent()), // Fetch updated cart after removing
    );
  }
}
