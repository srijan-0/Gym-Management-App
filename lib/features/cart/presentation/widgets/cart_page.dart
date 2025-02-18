import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:login/features/cart/presentation/bloc/cart_state.dart';
import 'package:login/features/cart/presentation/widgets/cart_item_widget.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛒 Shopping Cart'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            return state.items.isEmpty
                ? const Center(child: Text('Your cart is empty 🛍️'))
                : ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      return CartItemWidget(cartItem: state.items[index]);
                    },
                  );
          } else if (state is CartError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No items in cart.'));
        },
      ),
    );
  }
}
