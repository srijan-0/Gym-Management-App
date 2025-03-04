import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login/core/layout/footer_widget.dart';
import 'package:login/features/category/data/data_sources/category_remote_data_source.dart';
import 'package:login/features/category/data/repositories/category_repository_impl.dart';
import 'package:login/features/category/domain/entities/category_entity.dart';
import 'package:login/features/product/prsentation/pages/product_page.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late Future<List<CategoryEntity>> _categories;

  @override
  void initState() {
    super.initState();
    _categories = _fetchCategories();
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
      (categories) => categories,
    );
  }

  void _onCategoryTapped(CategoryEntity category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProductPage(selectedCategory: category, fromCategory: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // ✅ Dark background
      appBar: AppBar(
        title: const Text(
          "Categories",
          style: TextStyle(color: Colors.white),
        ),
        // centerTitle: true,
        backgroundColor:
            Colors.deepPurple.shade900, // ✅ Darker purple for contrast
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ✅ Dark Theme Heading
            const Text(
              "📂 Explore Categories",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),

            /// ✅ Dark Theme Subtitle
            const Text(
              "Select a category to view products.",
              style: TextStyle(
                  fontSize: 14, color: Colors.white70), // ✅ Light grey
            ),
            const SizedBox(height: 20),

            /// ✅ Category Grid (Dark Mode)
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                  if (constraints.maxWidth > 900) {
                    crossAxisCount = 4;
                  }
                  return FutureBuilder<List<CategoryEntity>>(
                    future: _categories,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                              color: Colors.deepPurpleAccent),
                        );
                      } else if (snapshot.hasError || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            'No categories available.',
                            style: TextStyle(
                                color: Colors.white70), // ✅ Light grey
                          ),
                        );
                      } else {
                        final categories = snapshot.data!;
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: 1.5,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => _onCategoryTapped(categories[index]),
                              child: _buildCategoryCard(categories[index]),
                            );
                          },
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      /// ✅ Footer with Dark Theme
      bottomNavigationBar: FooterWidget(
          currentIndex: 1,
          onItemTapped: (index) {
            // Handle navigation in the footer
          }),
    );
  }

  /// ✅ Category Card (Dark Theme)
  Widget _buildCategoryCard(CategoryEntity category) {
    String imageUrl =
        "http://10.0.2.2:8000/uploads/categories/${category.cImage}";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      color: Colors.grey[900], // ✅ Dark Grey for Card
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// ✅ Category Image with Dark Mode Error Icon
          Image.network(imageUrl, height: 60,
              errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.image_not_supported,
                size: 60, color: Colors.white); // ✅ Muted grey
          }),

          const SizedBox(height: 10),

          /// ✅ Category Name with Dark Text
          Text(
            category.cName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[300], // ✅ Softer white for better dark theme
            ),
          ),
        ],
      ),
    );
  }
}
