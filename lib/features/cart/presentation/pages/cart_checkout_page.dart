import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/features/cart/presentation/bloc/cart_state.dart';

import '../bloc/cart_bloc.dart';

class CartCheckoutPage extends StatelessWidget {
  const CartCheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛍️ Checkout'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded && state.items.isNotEmpty) {
            double totalAmount = state.items
                .fold(0, (sum, item) => sum + (item.price * item.quantity));

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return ListTile(
                          title: Text(item.productName),
                          subtitle: Text("\$${item.price} x ${item.quantity}"),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  Text("Total: \$${totalAmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement checkout functionality
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple),
                    child: const Text("Proceed to Payment"),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text("No items to checkout."));
        },
      ),
    );
  }
}
