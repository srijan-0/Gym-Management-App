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
import 'package:login/features/home/presentation/view/bmi_calculator_page.dart';
import 'package:login/features/home/presentation/view/notice_list_page.dart';
import 'package:login/features/home/presentation/view/water_tracker_page.dart';
import 'package:login/features/product/prsentation/pages/product_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late Future<List<CategoryEntity>> _categories;
  late Future<List<Notice>> _notices;
  late Future<int> _daysLeftForRenewal;
  double _waterIntake = 0.0; // Current intake
  final double _dailyGoal = 3.0; // 3L goal

  @override
  void initState() {
    _loadWaterIntake();
    super.initState();
    _categories = _fetchCategories();
    _notices = _fetchNotices();
    _daysLeftForRenewal = _fetchMembershipDaysLeft();
  }

  Future<void> _loadWaterIntake() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _waterIntake = prefs.getDouble('water_intake') ?? 0.0;
    });
  }

  /// ✅ Fetch Random Membership Days Left
  /// ✅ Return Fixed Membership Days (28 Days)
  Future<int> _fetchMembershipDaysLeft() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return 28; // Fixed value: 28 days left
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
          'Welcome Srijan',
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

  Widget _buildHomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          /// ✅ Membership + Water Bottle Layout
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ✅ Membership & Notices (Left Side)
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildMembershipBox(), // Membership Renewal
                    const SizedBox(height: 10),
                    _buildNoticesBox(), // Latest Notices
                  ],
                ),
              ),

              const SizedBox(width: 10), // Space between sections

              /// ✅ Water Bottle (Right Side)
              Expanded(
                flex: 1,
                child: _buildWaterBottle(),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// ✅ Four Navigation Boxes (BMI, Categories, Products, Cart)
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              _buildHomeOptionBox(
                icon: Icons.calculate,
                title: "BMI Calculator",
                color: Colors.blue.shade100,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BMICalculatorPage()),
                  );
                },
              ),
              _buildHomeOptionBox(
                icon: Icons.category,
                title: "Categories",
                color: Colors.orange.shade100,
                onTap: () => _onItemTapped(1),
              ),
              _buildHomeOptionBox(
                icon: Icons.shopping_bag,
                title: "Products",
                color: Colors.green.shade100,
                onTap: () => _onItemTapped(2),
              ),
              _buildHomeOptionBox(
                icon: Icons.shopping_cart,
                title: "Cart",
                color: Colors.red.shade100,
                onTap: () => _onItemTapped(3),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// ✅ Membership Renewal Box
  Widget _buildMembershipBox() {
    return FutureBuilder<int>(
      future: _daysLeftForRenewal,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          int daysLeft = snapshot.data ?? 0;
          return GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Membership renewal feature coming soon!"),
                ),
              );
            },
            child: Card(
              color: daysLeft > 5 ? Colors.green.shade50 : Colors.red.shade50,
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.card_membership,
                        size: 30,
                        color: daysLeft > 5 ? Colors.green : Colors.red),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Membership Renewal",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            daysLeft > 5
                                ? "You have $daysLeft days left."
                                : "⚠️ Only $daysLeft days left! Renew soon.",
                            style: TextStyle(
                              color: daysLeft > 5 ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 18),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  /// ✅ Notices Section
  Widget _buildNoticesBox() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoticeListPage(notices: _notices),
          ),
        );
      },
      child: Card(
        color: Colors.deepPurple.shade50,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.notifications_active,
                  size: 30, color: Colors.deepPurple),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Latest Notices",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 5),
                    FutureBuilder<List<Notice>>(
                      future: _notices,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("Loading latest notices...");
                        } else if (snapshot.hasError ||
                            snapshot.data!.isEmpty) {
                          return const Text("No notices available.");
                        } else {
                          return Text(
                            snapshot.data!.first.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  size: 18, color: Colors.deepPurple),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ Water Bottle UI (Right Side)
  Widget _buildWaterBottle() {
    double fillHeight = (_waterIntake / _dailyGoal) * 150; // Scale height

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WaterTrackerPage()),
        ).then((_) => _loadWaterIntake()); // Reload intake after returning
      },
      child: Column(
        children: [
          const Text(
            "Water Intake",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          /// Water Bottle Shape
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              /// Bottle Outline
              Container(
                width: 80,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 3),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              /// Water Level (Fills Based on Intake)
              Container(
                width: 80,
                height: fillHeight,
                decoration: BoxDecoration(
                  color: Colors.blue.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// Display current intake
          Text(
            "${_waterIntake.toStringAsFixed(1)}L / $_dailyGoal L",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// ✅ Helper Widget to Create Navigation Boxes
  Widget _buildHomeOptionBox({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.black87),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ Build Category Card Widge
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
