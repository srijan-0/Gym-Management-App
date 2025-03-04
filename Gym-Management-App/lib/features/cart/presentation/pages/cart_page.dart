import 'package:flutter/material.dart';
import 'package:login/core/layout/footer_widget.dart';
import 'package:login/features/cart/presentation/pages/cart_manager.dart';
import 'package:login/features/product/prsentation/pages/product_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void _removeFromCart(product) {
    setState(() {
      CartManager().removeFromCart(product);
    });
  }

  void _confirmCheckout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              Colors.grey[900], // ✅ Dark background for alert dialog
          title: const Text(
            "Confirm Checkout",
            style: TextStyle(color: Colors.white), // ✅ White text
          ),
          content: const Text(
            "Are you sure you want to proceed to checkout?",
            style: TextStyle(color: Colors.white70), // ✅ Light grey text
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  CartManager().clearCart();
                });

                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Checkout successful!",
                        style: TextStyle(color: Colors.white)),
                    backgroundColor:
                        Colors.deepPurpleAccent, // ✅ Dark theme snack bar
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent),
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = CartManager().cartItems;

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // ✅ Dark theme background
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Cart",
            style: TextStyle(color: Colors.white)), // ✅ White title
        backgroundColor: Colors.deepPurple.shade900,
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                "Your cart is empty!",
                style: TextStyle(
                    color:
                        Colors.white70), // ✅ Light grey for empty cart message
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final product = cartItems[index];

                      final String imageUrl = (product.images.isNotEmpty)
                          ? "http://10.0.2.2:8000/uploads/products/${product.images[0]}"
                          : "http://10.0.2.2:8000/uploads/products/default.jpg";

                      return Card(
                        color: Colors.grey[900], // ✅ Dark theme card
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        elevation: 3,
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                8), // ✅ Rounded image corners
                            child: Image.network(
                              imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image_not_supported,
                                    size: 50, color: Colors.white70);
                              },
                            ),
                          ),
                          title: Text(
                            product.name,
                            style: const TextStyle(
                                color: Colors
                                    .white), // ✅ White text for product name
                          ),
                          subtitle: Text(
                            "Price: \$${product.price}",
                            style: const TextStyle(
                                color: Colors
                                    .white70), // ✅ Light grey text for price
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.redAccent),
                            onPressed: () => _removeFromCart(product),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Total: \$${CartManager().totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white), // ✅ White text
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _confirmCheckout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.deepPurpleAccent, // ✅ Dark theme button
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Proceed to Checkout",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: FooterWidget(
        currentIndex: 3,
        onItemTapped: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductPage()),
            );
          }
        },
      ),
    );
  }
}
