// import 'package:flutter/material.dart';
// import 'package:login/core/layout/footer_widget.dart';
// import 'package:login/features/cart/presentation/pages/cart_manager.dart';
// import 'package:login/features/product/prsentation/pages/product_page.dart';

// class CartPage extends StatefulWidget {
//   const CartPage({super.key});

//   @override
//   State<CartPage> createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   void _removeFromCart(product) {
//     setState(() {
//       CartManager().removeFromCart(product);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cartItems =
//         CartManager().cartItems; // ✅ Get cart items from Singleton

//     return Scaffold(
//       appBar: AppBar(title: const Text("Cart")),
//       body: cartItems.isEmpty
//           ? const Center(child: Text("Your cart is empty!"))
//           : Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: cartItems.length,
//                     itemBuilder: (context, index) {
//                       final product = cartItems[index];

//                       // Ensure image URLs are correctly formatted
//                       final String imageUrl = (product.images.isNotEmpty)
//                           ? "http://10.0.2.2:8000/uploads/products/${product.images[0]}"
//                           : "http://10.0.2.2:8000/uploads/products/default.jpg";

//                       return Card(
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 5),
//                         elevation: 3,
//                         child: ListTile(
//                           leading: Image.network(
//                             imageUrl,
//                             width: 50,
//                             height: 50,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) {
//                               return const Icon(Icons.image_not_supported,
//                                   size: 50);
//                             },
//                           ),
//                           title: Text(product.name),
//                           subtitle: Text("Price: \$${product.price}"),
//                           trailing: IconButton(
//                             icon: const Icon(Icons.remove_circle,
//                                 color: Colors.red),
//                             onPressed: () => _removeFromCart(product),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     children: [
//                       Text(
//                         'Total: \$${CartManager().totalPrice.toStringAsFixed(2)}',
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 10),
//                       ElevatedButton(
//                         onPressed: () {},
//                         child: const Text('Proceed to Checkout'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//       bottomNavigationBar: FooterWidget(
//         currentIndex: 3,
//         onItemTapped: (index) {
//           if (index == 2) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ProductPage()),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

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
          title: const Text("Confirm Checkout"),
          content: const Text("Are you sure you want to proceed to checkout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  CartManager().clearCart(); // Clear cart items
                });

                Navigator.of(context).pop(); // Close dialog

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Checkout successful!")),
                );
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItems =
        CartManager().cartItems; // ✅ Get cart items from Singleton

    return Scaffold(
      appBar:
          AppBar(automaticallyImplyLeading: false, title: const Text("Cart")),
      body: cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty!"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final product = cartItems[index];

                      // Ensure image URLs are correctly formatted
                      final String imageUrl = (product.images.isNotEmpty)
                          ? "http://10.0.2.2:8000/uploads/products/${product.images[0]}"
                          : "http://10.0.2.2:8000/uploads/products/default.jpg";

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        elevation: 3,
                        child: ListTile(
                          leading: Image.network(
                            imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported,
                                  size: 50);
                            },
                          ),
                          title: Text(product.name),
                          subtitle: Text("Price: \$${product.price}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.red),
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
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _confirmCheckout, // Show confirmation dialog
                        child: const Text('Proceed to Checkout'),
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
