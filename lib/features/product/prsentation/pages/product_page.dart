import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login/core/layout/footer_widget.dart';
import 'package:login/core/layout/header_widget.dart';
import 'package:login/features/category/data/data_sources/category_remote_data_source.dart';
import 'package:login/features/category/data/repositories/category_repository_impl.dart';
import 'package:login/features/category/domain/entities/category_entity.dart';
import 'package:login/features/home/presentation/view/home_screen.dart';
import 'package:login/features/product/data/data_sources/product_remote_data_source.dart';
import 'package:login/features/product/data/repositories/product_repository_impl.dart';
import 'package:login/features/product/domain/entities/product_entity.dart';

class ProductPage extends StatefulWidget {
  final CategoryEntity? selectedCategory;
  final bool fromCategory; // ✅ New Parameter

  const ProductPage(
      {super.key, this.selectedCategory, this.fromCategory = false});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Future<List<ProductEntity>> _products;
  late Future<List<CategoryEntity>> _categories;
  CategoryEntity? _selectedCategory;
  final int _selectedIndex = 2; // ✅ Default to "Products" in Navigation

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
    _categories = _fetchCategories();
    _products = _fetchProducts(categoryId: _selectedCategory?.id);
  }

  Future<List<CategoryEntity>> _fetchCategories() async {
    final repository = CategoryRepositoryImpl(
      remoteDataSource: CategoryRemoteDataSourceImpl(client: http.Client()),
    );

    final dartz.Either<String, List<CategoryEntity>> result =
        await repository.getAllCategories();

    return result.fold(
      (failure) {
        debugPrint("Error fetching categories: $failure");
        return [];
      },
      (categories) {
        return [
          CategoryEntity(
              id: "",
              cName: "All Categories",
              cDescription: "",
              cImage: "",
              cStatus: ''),
          ...categories
        ];
      },
    );
  }

  Future<List<ProductEntity>> _fetchProducts({String? categoryId}) async {
    final repository = ProductRepositoryImpl(
      remoteDataSource: ProductRemoteDataSourceImpl(client: http.Client()),
    );

    final dartz.Either<String, List<ProductEntity>> result =
        await repository.getAllProducts();

    return result.fold(
      (failure) {
        debugPrint("Error fetching products: $failure");
        return [];
      },
      (products) {
        if (categoryId == null || categoryId.isEmpty) {
          return products;
        }
        return products
            .where((product) => product.categoryId == categoryId)
            .toList();
      },
    );
  }

  void _onCategorySelected(CategoryEntity? category) {
    setState(() {
      _selectedCategory = category;
      _products = _fetchProducts(categoryId: category?.id);
    });
  }

  void _onItemTapped(int index) {
    if (index == 0 || index == 3) {
      // Home or Profile
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomeScreen(), // ✅ Ensure this exists in your imports
        ),
        (route) => false, // Removes all previous routes from stack
      );
    } else if (index == 1) {
      // Categories
      Navigator.pop(context); // ✅ Works as expected
    } else if (index == 2) {
      // Products
      // Do nothing, already on Products page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderWidget(title: "Products", showBackButton: false),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<List<CategoryEntity>>(
              future: _categories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No categories available.'));
                } else {
                  final categories = snapshot.data!;
                  return DropdownButtonFormField<CategoryEntity>(
                    value: _selectedCategory ?? categories[0],
                    decoration: InputDecoration(
                      labelText: "Select Category",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: categories.map((category) {
                      return DropdownMenuItem<CategoryEntity>(
                        value: category,
                        child: Text(category.cName),
                      );
                    }).toList(),
                    onChanged: _onCategorySelected,
                  );
                }
              },
            ),
          ),
          if (_selectedCategory != null && _selectedCategory!.id.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedCategory!.cName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _selectedCategory!.cDescription,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "🛒 Suggested Products",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          Expanded(
            child: FutureBuilder<List<ProductEntity>>(
              future: _products,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products available.'));
                } else {
                  final products = snapshot.data!;
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(products[index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: widget.fromCategory
          ? FooterWidget(
              currentIndex: 2,
              onItemTapped: _onItemTapped) // ✅ Show navbar if from category
          : null, // ✅ Hide navbar if navigated directly
    );
  }

  /// **✅ Function to Display Product Cards**
  Widget _buildProductCard(ProductEntity product) {
    final imageUrl =
        "http://10.0.2.2:8000/uploads/products/${product.images.isNotEmpty ? product.images[0] : 'default.jpg'}";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image_not_supported,
                    size: 60, color: Colors.grey);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Category: ${product.categoryName}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "\$${product.price}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
