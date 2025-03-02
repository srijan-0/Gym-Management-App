import 'package:flutter/material.dart';
import 'package:login/features/category/domain/entities/category_entity.dart';

class CategoryCard extends StatelessWidget {
  final CategoryEntity category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // ✅ Ensure full image URL
    String imageUrl =
        "http://10.0.2.2:8000/uploads/categories/${category.cImage}";

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ✅ Display category image with error handling
          ClipRRect(
            borderRadius:
                BorderRadius.circular(10), // Rounded corners for image
            child: Image.network(
              imageUrl,
              height: 80, width: 80,
              fit: BoxFit.cover, // ✅ Maintain aspect ratio
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image_not_supported,
                    size: 60, color: Colors.grey);
              },
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Display category name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              category.cName.isNotEmpty ? category.cName : "No Name",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
