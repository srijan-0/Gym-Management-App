import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login/core/layout/footer_widget.dart';
import 'package:login/features/auth/data/repository/notice_repository_impl.dart';
import 'package:login/features/auth/domain/entity/notice.dart';
import 'package:login/features/cart/presentation/pages/cart_page.dart';
import 'package:login/features/category/data/data_sources/category_remote_data_source.dart';
import 'package:login/features/category/data/repositories/category_repository_impl.dart';
import 'package:login/features/category/domain/entities/category_entity.dart';
import 'package:login/features/product/prsentation/pages/product_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late Future<List<CategoryEntity>> _categories;
  late Future<List<Notice>> _notices;

  @override
  void initState() {
    super.initState();
    _categories = _fetchCategories();
    _notices = _fetchNotices();
  }

  /// ✅ Fetch Categories
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

  /// ✅ Fetch Notices
  Future<List<Notice>> _fetchNotices() async {
    final repository = NoticeRepositoryImpl(http.Client());
    return await repository.getNotices();
  }

  /// ✅ Handle Category Tap → Opens Product Page with Filtered Products
  void _onCategoryTapped(CategoryEntity category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProductPage(selectedCategory: category, fromCategory: true),
      ),
    );
  }

  /// ✅ Handle Navigation Bar Taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gym Tracker',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: _buildPageContent(),
      bottomNavigationBar: FooterWidget(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  /// ✅ Handle Different Pages Based on Navigation
  Widget _buildPageContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return _buildCategoryPage();
      case 2:
        return const ProductPage();
      case 3:
        return const CartPage();
      default:
        return _buildHomePage();
    }
  }

  /// ✅ Home Page (Restored Notices)
  Widget _buildHomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "🏋️ Welcome to Your Gym!",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 20),
          const Text("📢 Latest Notices",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          /// ✅ Notice Section
          FutureBuilder<List<Notice>>(
            future: _notices,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || snapshot.data!.isEmpty) {
                return const Center(child: Text('No notices available.'));
              } else {
                final notices = snapshot.data!;
                return Column(
                  children: notices.map((notice) {
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        title: Text(notice.title,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        subtitle: Text(notice.description,
                            style: const TextStyle(fontSize: 14)),
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  /// ✅ Build Category Card Widget
  Widget _buildCategoryCard(CategoryEntity category) {
    String imageUrl =
        "http://10.0.2.2:8000/uploads/categories/${category.cImage}";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(imageUrl, height: 60,
              errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.image_not_supported,
                size: 60, color: Colors.grey);
          }),
          const SizedBox(height: 10),
          Text(category.cName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple)),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              category.cDescription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Categories Page
  Widget _buildCategoryPage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "📂 Explore Categories",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple),
          ),
          const SizedBox(height: 10),
          const Text(
            "Select a category to view products and get tailored suggestions for your fitness journey.",
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          FutureBuilder<List<CategoryEntity>>(
            future: _categories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || snapshot.data!.isEmpty) {
                return const Center(child: Text('No categories available.'));
              } else {
                final categories = snapshot.data!;
                return GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
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
          ),
        ],
      ),
    );
  }
}
