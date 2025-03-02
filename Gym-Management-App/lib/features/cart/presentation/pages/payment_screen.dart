import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  final double totalAmount;

  const PaymentScreen({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Total Payment: \$${totalAmount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add payment processing logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Payment Successful!")),
                );
                Navigator.pop(context);
              },
              child: const Text("Pay Now"),
            ),
          ],
        ),
      ),
    );
  }
}
