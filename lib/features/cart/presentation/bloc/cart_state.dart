import 'package:equatable/equatable.dart';

import '../../domain/entities/cart_entity.dart';

abstract class CartState extends Equatable {
  @override
  List<Object> get props => [];
}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartEntity> items;
  CartLoaded(this.items);
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}
