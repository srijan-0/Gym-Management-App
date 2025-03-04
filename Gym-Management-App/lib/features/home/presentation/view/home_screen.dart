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

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late Future<List<CategoryEntity>> _categories;
  late Future<List<Notice>> _notices;
  double _waterIntake = 0.0;
  final double _dailyGoal = 3.0;
  int _steps = 0;
  final int _stepGoal = 10000;

  StreamSubscription? _accelerometerSubscription;
  static const double _shakeThreshold = 20.0;
  DateTime? _lastShakeTime;
  static const Duration _shakeCooldown = Duration(seconds: 2);

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadWaterIntake();
    _categories = _fetchCategories();
    _notices = _fetchNotices();
    _loadSteps();
    _initShakeDetection();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
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
            backgroundColor: Colors.grey[900],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Logout', style: TextStyle(color: Colors.white)),
            content: const Text('Are you sure you want to logout?',
                style: TextStyle(color: Colors.white70)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child:
                    const Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Yes',
                    style: TextStyle(color: Colors.blueAccent)),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm && mounted) {
      try {
        print('Clearing login data from SharedPreferences');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('user_token');
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
    setState(() => _steps = prefs.getInt('steps') ?? 0);
  }

  Future<void> _loadWaterIntake() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => _waterIntake = prefs.getDouble('water_intake') ?? 0.0);
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

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Welcome Srijan',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width > 600 ? 24 : 20,
          ),
        ),
        // centerTitle: true,
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        actions: [
          IconButton(
            icon:
                const Icon(Icons.notifications, size: 28, color: Colors.white),
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
              icon: const Icon(Icons.logout, size: 28, color: Colors.white),
              onPressed: _handleLogout,
              tooltip: 'Debug Logout (Emulator Only)',
            ),
        ],
      ),
      body: Container(
        color: const Color(0xFF121212),
        child: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return _buildPageContent(constraints);
            },
          ),
        ),
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
        padding:
            EdgeInsets.symmetric(horizontal: isTablet ? 30 : 15, vertical: 0),
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
                      SizedBox(height: isTablet ? 20 : 10),
                      _buildMembershipBox(height: isTablet ? 120 : 100),
                    ],
                  ),
                ),
                SizedBox(
                  width: isTablet ? 140 : 100,
                  child: _buildWaterBottle(height: isTablet ? 280 : 200),
                ),
              ],
            ),
            SizedBox(height: 0),
            GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isTablet ? 4 : 2,
                crossAxisSpacing: isTablet ? 15 : 10,
                mainAxisSpacing: isTablet ? 15 : 10,
                childAspectRatio:
                    isTablet ? 0.95 : 0.85, // Adjusted for taller boxes
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                List<Map<String, dynamic>> gridItems = [
                  {
                    "icon": Icons.calculate,
                    "title": "BMI Calculator",
                    "color": Colors.blue.shade800,
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
                    "color": Colors.orange.shade800,
                    "action": () => _onItemTapped(1)
                  },
                  {
                    "icon": Icons.shopping_bag,
                    "title": "Products",
                    "color": Colors.green.shade800,
                    "action": () => _onItemTapped(2)
                  },
                  {
                    "icon": Icons.shopping_cart,
                    "title": "Cart",
                    "color": Colors.red.shade800,
                    "action": () => _onItemTapped(3)
                  },
                ];

                return _buildHomeOptionBox(
                  gridItems[index]["icon"],
                  gridItems[index]["title"],
                  gridItems[index]["color"],
                  gridItems[index]["action"],
                  height: isTablet ? 110 : 90, // Updated height
                );
              },
            ),
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
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.red.shade800, Colors.red.shade600]),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4))
            ],
          ),
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
                        color: Colors.white,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: (1 - progress) * 100,
                        radius: 12,
                        color: Colors.black,
                        showTitle: false,
                      ),
                    ],
                    sectionsSpace: 1,
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
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "STEPS",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue.shade400, width: 1),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.notifications_active, color: Colors.blue.shade400),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Latest Notices",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<List<Notice>>(
                    future: _notices,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading latest notices...",
                            style: TextStyle(color: Colors.white70));
                      } else if (snapshot.hasError || snapshot.data!.isEmpty) {
                        return Text("No notices available.",
                            style: TextStyle(color: Colors.white70));
                      } else {
                        return Text(
                          snapshot.data!.first.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 18, color: Colors.blue.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterBottle({double height = 200}) {
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
          Text(
            "Water Intake",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 90,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue.shade400, width: 3),
                  color: Colors.grey.shade900,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 90,
                height: fillHeight.clamp(0, height),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.blue.shade600]),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "${_waterIntake.toStringAsFixed(1)}L / $_dailyGoal L",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipBox({double height = 100}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.green.shade800, Colors.green.shade600]),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4))
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(Icons.card_membership, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Membership Renewal",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                Text("Days left: 28", style: TextStyle(color: Colors.white70)),
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
      padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 30 : 15, vertical: isTablet ? 20 : 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "📂 Explore Categories",
            style: TextStyle(
                fontSize: isTablet ? 24 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          SizedBox(height: isTablet ? 15 : 10),
          FutureBuilder<List<CategoryEntity>>(
            future: _categories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(color: Colors.white));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                    child: Text('No categories available.',
                        style: TextStyle(color: Colors.white70)));
              }

              final categories = snapshot.data!;
              return GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isTablet ? 3 : 2,
                  childAspectRatio: isTablet ? 1.8 : 1.5,
                  crossAxisSpacing: isTablet ? 15 : 10,
                  mainAxisSpacing: isTablet ? 15 : 10,
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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.purple.shade800, Colors.purple.shade600]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          title: Text(category.cName,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: Text(category.cDescription,
              style: TextStyle(color: Colors.white70)),
        ),
      ),
    );
  }

  Widget _buildHomeOptionBox(
      IconData icon, String title, Color color, VoidCallback onTap,
      {double height = 100}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            color,
            color.withOpacity(0.7),
          ]),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
