import 'dart:async';
import 'dart:math' as math;

import 'package:dartz/dartz.dart' as dartz;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login/core/layout/footer_widget.dart';
import 'package:login/features/auth/data/repository/notice_repository_impl.dart';
import 'package:login/features/auth/domain/entity/notice.dart';
import 'package:login/features/auth/presentation/view/login_view.dart';
import 'package:login/features/cart/presentation/pages/cart_page.dart';
import 'package:login/features/category/data/data_sources/category_remote_data_source.dart';
import 'package:login/features/category/data/repositories/category_repository_impl.dart';
import 'package:login/features/category/domain/entities/category_entity.dart';
import 'package:login/features/home/presentation/view/bmi_calculator_page.dart';
import 'package:login/features/home/presentation/view/calories_burned_tracker.dart';
import 'package:login/features/home/presentation/view/notice_list_page.dart';
import 'package:login/features/home/presentation/view/water_tracker_page.dart';
import 'package:login/features/product/prsentation/pages/product_page.dart';
import 'package:sensors_plus/sensors_plus.dart';
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
  double _waterIntake = 0.0;
  final double _dailyGoal = 3.0;
  int _steps = 0;
  final int _stepGoal = 10000;

  StreamSubscription? _accelerometerSubscription;
  static const double _shakeThreshold = 20.0;
  DateTime? _lastShakeTime;
  static const Duration _shakeCooldown = Duration(seconds: 2);

  @override
  void initState() {
    _loadWaterIntake();
    super.initState();
    _categories = _fetchCategories();
    _notices = _fetchNotices();
    _loadSteps();
    _daysLeftForRenewal = _fetchMembershipDaysLeft();
    _initShakeDetection();
  }

  void _initShakeDetection() {
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      double acceleration =
          math.sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      print('Acceleration: $acceleration');
      if (acceleration > _shakeThreshold) {
        DateTime now = DateTime.now();
        if (_lastShakeTime == null ||
            now.difference(_lastShakeTime!) > _shakeCooldown) {
          _lastShakeTime = now;
          _handleLogout();
        }
      }
    });
  }

  Future<void> _handleLogout() async {
    print('Logout initiated');
    bool confirm = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm && mounted) {
      try {
        print('Clearing login data from SharedPreferences');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // Remove only login-related data (adjust key as per your app)
        await prefs.remove(
            'user_token'); // Replace 'user_token' with your actual login key
        print('Login data cleared, preserving steps and water intake');

        if (mounted) {
          print('Navigating to LoginView');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginView()),
          );
        }
      } catch (e) {
        print('Logout error: $e');
      }
    } else {
      print('Logout cancelled or widget not mounted');
    }
  }

  Future<void> _loadSteps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _steps = prefs.getInt('steps') ?? 0;
    });
  }

  Future<void> _loadWaterIntake() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _waterIntake = prefs.getDouble('water_intake') ?? 0.0;
    });
  }

  Future<int> _fetchMembershipDaysLeft() async {
    await Future.delayed(const Duration(seconds: 1));
    return 28;
  }

  Future<List<CategoryEntity>> _fetchCategories() async {
    final repository = CategoryRepositoryImpl(
      remoteDataSource: CategoryRemoteDataSourceImpl(client: http.Client()),
    );

    final dartz.Either<String, List<CategoryEntity>> result =
        await repository.getAllCategories();

    return result.fold((failure) {
      debugPrint("Error fetching categories: $failure");
      return [];
    }, (categories) => categories);
  }

  Future<List<Notice>> _fetchNotices() async {
    final repository = NoticeRepositoryImpl(http.Client());
    return await repository.getNotices();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              size: 28,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoticeListPage(notices: _notices),
                ),
              );
            },
          ),
          if (kDebugMode)
            IconButton(
              icon: const Icon(
                Icons.logout,
                size: 28,
                color: Colors.black,
              ),
              onPressed: _handleLogout,
              tooltip: 'Debug Logout (Emulator Only)',
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return _buildPageContent(constraints);
        },
      ),
      bottomNavigationBar: FooterWidget(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildPageContent(BoxConstraints constraints) {
    double screenWidth = constraints.maxWidth;
    switch (_selectedIndex) {
      case 0:
        return _buildHomePage(screenWidth);
      case 1:
        return _buildCategoryPage(screenWidth);
      case 2:
        return const ProductPage();
      case 3:
        return const CartPage();
      default:
        return _buildHomePage(screenWidth);
    }
  }

  Widget _buildHomePage(double screenWidth) {
    bool isTablet = screenWidth > 600;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildStepProgress(),
                      const SizedBox(height: 15),
                      _buildMembershipBox(height: 100),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                SizedBox(
                  width: 120,
                  child: _buildWaterBottle(height: isTablet ? 150 : 200),
                ),
              ],
            ),
            const SizedBox(height: 30),
            GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isTablet ? 4 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: isTablet ? 1.2 : 1.0,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                List<Map<String, dynamic>> gridItems = [
                  {
                    "icon": Icons.calculate,
                    "title": "BMI Calculator",
                    "color": Colors.blue.shade100,
                    "action": () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BMICalculatorPage()));
                    }
                  },
                  {
                    "icon": Icons.category,
                    "title": "Categories",
                    "color": Colors.orange.shade100,
                    "action": () => _onItemTapped(1)
                  },
                  {
                    "icon": Icons.shopping_bag,
                    "title": "Products",
                    "color": Colors.green.shade100,
                    "action": () => _onItemTapped(2)
                  },
                  {
                    "icon": Icons.shopping_cart,
                    "title": "Cart",
                    "color": Colors.red.shade100,
                    "action": () => _onItemTapped(3)
                  },
                ];

                return _buildHomeOptionBox(
                  gridItems[index]["icon"],
                  gridItems[index]["title"],
                  gridItems[index]["color"],
                  gridItems[index]["action"],
                  height: isTablet ? 120 : 140,
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStepProgress() {
    double progress = (_steps / _stepGoal).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const CaloriesBurnedTracker()),
        ).then((_) => _loadSteps());
      },
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 140,
              width: 140,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: progress * 100,
                      radius: 12,
                      color: Colors.green,
                      showTitle: false,
                    ),
                    PieChartSectionData(
                      value: (1 - progress) * 100,
                      radius: 12,
                      color: Colors.red,
                      showTitle: false,
                    ),
                  ],
                  sectionsSpace: 0,
                  centerSpaceRadius: 50,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _steps.toString(),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Text(
                  "STEPS",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticesBox({double height = 140}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoticeListPage(notices: _notices),
          ),
        );
      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.deepPurple, width: 1),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.notifications_active, color: Colors.deepPurple),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Latest Notices",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<List<Notice>>(
                    future: _notices,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading latest notices...");
                      } else if (snapshot.hasError || snapshot.data!.isEmpty) {
                        return const Text("No notices available.");
                      } else {
                        return Text(
                          snapshot.data!.first.title,
                          maxLines: 2,
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
    );
  }

  Widget _buildWaterBottle({double height = 240}) {
    double fillHeight = (_waterIntake / _dailyGoal) * height;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WaterTrackerPage()),
        ).then((_) => _loadWaterIntake());
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Water Intake",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 90,
                height: height,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 3),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Container(
                width: 90,
                height: fillHeight.clamp(0, height),
                decoration: BoxDecoration(
                  color: Colors.blue.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "${_waterIntake.toStringAsFixed(1)}L / $_dailyGoal L",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipBox({double height = 130}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green, width: 1),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Icon(Icons.card_membership, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Membership Renewal",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Days left: 28",
                    style: TextStyle(color: Colors.green.shade700)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPage(double screenWidth) {
    bool isTablet = screenWidth > 600;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "📂 Explore Categories",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          FutureBuilder<List<CategoryEntity>>(
            future: _categories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No categories available.'));
              }

              final categories = snapshot.data!;
              return GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isTablet ? 3 : 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return _buildCategoryCard(categories[index]);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(CategoryEntity category) {
    return Card(
      child: ListTile(
        title: Text(category.cName),
        subtitle: Text(category.cDescription),
      ),
    );
  }

  Widget _buildHomeOptionBox(
      IconData icon, String title, Color color, VoidCallback onTap,
      {double height = 110}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.black87),
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
    );
  }
}
