import 'package:equatable/equatable.dart';

import '../../domain/entities/cart_entity.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetCartItemsEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final CartEntity cartItem;
  AddToCartEvent(this.cartItem);
}

class RemoveFromCartEvent extends CartEvent {
  final String productId;
  RemoveFromCartEvent(this.productId);
}
