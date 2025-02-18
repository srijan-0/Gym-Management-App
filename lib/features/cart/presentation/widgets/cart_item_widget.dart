import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/features/cart/presentation/bloc/cart_event.dart';

import '../../domain/entities/cart_entity.dart';
import '../bloc/cart_bloc.dart';

class CartItemWidget extends StatelessWidget {
  final CartEntity cartItem;

  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: Image.network(
          "http://10.0.2.2:8000/uploads/products/${cartItem.productImage}",
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.image_not_supported, size: 50),
        ),
        title: Text(cartItem.productName,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("\$${cartItem.price} x ${cartItem.quantity}"),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            context
                .read<CartBloc>()
                .add(RemoveFromCartEvent(cartItem.productId));
          },
        ),
      ),
    );
  }
}
