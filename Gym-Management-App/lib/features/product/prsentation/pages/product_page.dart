import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login/core/layout/footer_widget.dart';
import 'package:login/core/layout/header_widget.dart';
import 'package:login/features/cart/presentation/pages/cart_manager.dart';
import 'package:login/features/cart/presentation/pages/cart_page.dart';
import 'package:login/features/category/data/data_sources/category_remote_data_source.dart';
import 'package:login/features/category/data/repositories/category_repository_impl.dart';
import 'package:login/features/category/domain/entities/category_entity.dart';
import 'package:login/features/product/data/data_sources/product_remote_data_source.dart';
import 'package:login/features/product/data/repositories/product_repository_impl.dart';
import 'package:login/features/product/domain/entities/product_entity.dart';

class ProductPage extends StatefulWidget {
  final CategoryEntity? selectedCategory;
  final bool fromCategory;

  const ProductPage(
      {super.key, this.selectedCategory, this.fromCategory = false});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Future<List<ProductEntity>> _products;
  late Future<List<CategoryEntity>> _categories;
  CategoryEntity? _selectedCategory;

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

  void _onCategorySelected(CategoryEntity? category) {
    setState(() {
      _selectedCategory = category;
      _products = _fetchProducts(categoryId: category?.id);
    });
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

  void _addToCart(ProductEntity product) {
    CartManager().addToCart(product);
    setState(() {});
  }

  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CartPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: HeaderWidget(
        title: "Products",
        titleColor: Colors.white,
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: _navigateToCart,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FutureBuilder<List<CategoryEntity>>(
                  future: _categories,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                              color: Colors.deepPurpleAccent));
                    } else if (snapshot.hasError || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('No categories available.',
                              style: TextStyle(color: Colors.white70)));
                    } else {
                      final categories = snapshot.data!;
                      return DropdownButtonFormField<CategoryEntity>(
                        value: _selectedCategory ?? categories[0],
                        decoration: InputDecoration(
                          labelText: "Select Category",
                          labelStyle: const TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Colors.grey[900],
                        ),
                        dropdownColor: Colors.grey[900],
                        items: categories.map((category) {
                          return DropdownMenuItem<CategoryEntity>(
                            value: category,
                            child: Text(category.cName,
                                style: const TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                        onChanged: _onCategorySelected,
                      );
                    }
                  },
                ),
              ),
              Expanded(
                child: FutureBuilder<List<ProductEntity>>(
                  future: _products,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                              color: Colors.deepPurpleAccent));
                    } else if (snapshot.hasError || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('No products available.',
                              style: TextStyle(color: Colors.white70)));
                    } else {
                      final products = snapshot.data!;
                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.7,
                          mainAxisExtent: 260,
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
          );
        },
      ),
      bottomNavigationBar: FooterWidget(
        currentIndex: 2,
        onItemTapped: (index) {
          if (index == 3) {
            _navigateToCart();
          }
        },
      ),
    );
  }

  Widget _buildProductCard(ProductEntity product) {
    final imageUrl = product.images.isNotEmpty
        ? "http://10.0.2.2:8000/uploads/products/${product.images[0]}"
        : "http://10.0.2.2:8000/uploads/products/default.jpg";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      color: Colors.grey[900],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, __, ___) => const Icon(
                    Icons.image_not_supported,
                    size: 60,
                    color: Colors.white70),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(product.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 4),
                Text("Category: ${product.categoryName}",
                    style:
                        const TextStyle(fontSize: 14, color: Colors.white70)),
                const SizedBox(height: 4),
                Text("\$${product.price}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent)),
                const SizedBox(height: 6),
                ElevatedButton(
                    onPressed: () => _addToCart(product),
                    child: const Text("Add to Cart")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
