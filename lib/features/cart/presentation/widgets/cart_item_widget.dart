import 'package:flutter/material.dart';
import 'package:login/features/product/domain/entities/product_entity.dart';

class CartItemWidget extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onRemove;

  const CartItemWidget(
      {super.key, required this.product, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Image.network(
          product.images.isNotEmpty
              ? product.images[0]
              : "https://via.placeholder.com/50",
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.image_not_supported),
        ),
        title: Text(
          product.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
        trailing: IconButton(
          icon: const Icon(Icons.remove_circle, color: Colors.red),
          onPressed: onRemove,
        ),
      ),
    );
  }
}
