import 'dart:async';
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login/core/layout/footer_widget.dart';
import 'package:login/features/auth/data/repository/notice_repository_impl.dart';
import 'package:login/features/auth/domain/entity/notice.dart';
import 'package:login/features/auth/presentation/view/login_view.dart';
import 'package:login/features/home/presentation/view/bmi_calculator_page.dart';
import 'package:login/features/home/presentation/view/notice_list_page.dart';
import 'package:login/features/home/presentation/view/water_tracker_page.dart';
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
  late Future<List<Notice>> _notices;
  double _waterIntake = 0.0;
  final double _dailyGoal = 3.0;

  // Step Tracking Variables
  int _steps = 0;
  double _caloriesBurned = 0.0;
  int _activeMinutes = 0;
  int _floorsClimbed = 0;
  double _lastZ = 0.0;
  double _totalElevationGain = 0.0;
  final double _caloriesPerStep = 0.04;
  final double _stepLength = 0.0008;
  final double _stepThreshold = 2.0;
  double _lastAccel = 0.0;
  final int _stepGoal = 10000;
  DateTime? _lastStepTime;

  StreamSubscription? _accelerometerSubscription;
  static const double _shakeThreshold = 40.0;
  final int _shakeCount = 0;
  DateTime? _lastShakeTime;
  static const Duration _shakeCooldown = Duration(milliseconds: 500);
  static const Duration _shakeWindow = Duration(seconds: 2);

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadWaterIntake();
    _notices = _fetchNotices();
    _loadSteps();
    _initAccelerometer();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
  }

  void _initAccelerometer() {
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      double acceleration =
          math.sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

      if ((acceleration - _lastAccel).abs() > _stepThreshold) {
        DateTime now = DateTime.now();
        if (_lastStepTime == null ||
            now.difference(_lastStepTime!).inMilliseconds > 400) {
          setState(() {
            _steps++;
            _caloriesBurned = _steps * _caloriesPerStep;
          });
          if (_lastStepTime == null ||
              now.difference(_lastStepTime!).inSeconds > 60) {
            _activeMinutes++;
          }
          _lastStepTime = now;
          _saveSteps();
        }
      }
      _lastAccel = acceleration;

      double verticalMovement = event.z - _lastZ;
      if (verticalMovement.abs() > 0.6) {
        _totalElevationGain += verticalMovement;
        if (_totalElevationGain >= 3.0) {
          setState(() {
            _floorsClimbed++;
            _totalElevationGain = 0;
          });
          _saveSteps();
        }
      }
      _lastZ = event.z;
    });
  }

  Future<void> _loadSteps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int savedSteps = prefs.getInt('steps') ?? 0;
    int savedMinutes = prefs.getInt('activeMinutes') ?? 0;
    int savedFloors = prefs.getInt('floorsClimbed') ?? 0;
    String? lastSavedDate = prefs.getString('lastSavedDate');
    String todayDate = DateTime.now().toString().split(' ')[0];

    if (lastSavedDate == null || lastSavedDate != todayDate) {
      _resetSteps();
    } else {
      setState(() {
        _steps = savedSteps;
        _activeMinutes = savedMinutes;
        _floorsClimbed = savedFloors;
        _caloriesBurned = _steps * _caloriesPerStep;
      });
    }
  }

  Future<void> _saveSteps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('steps', _steps);
    await prefs.setInt('activeMinutes', _activeMinutes);
    await prefs.setInt('floorsClimbed', _floorsClimbed);
    await prefs.setString(
        'lastSavedDate', DateTime.now().toString().split(' ')[0]);
  }

  Future<void> _resetSteps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _steps = 0;
      _caloriesBurned = 0.0;
      _activeMinutes = 0;
      _floorsClimbed = 0;
    });
    await prefs.setInt('steps', 0);
    await prefs.setInt('activeMinutes', 0);
    await prefs.setInt('floorsClimbed', 0);
    await prefs.setString(
        'lastSavedDate', DateTime.now().toString().split(' ')[0]);
  }

  Future<void> _handleLogout() async {
    bool confirm = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.black,
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_token');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginView()));
    }
  }

  Future<void> _loadWaterIntake() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => _waterIntake = prefs.getDouble('water_intake') ?? 0.0);
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
            letterSpacing: 1.2,
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width > 600 ? 30 : 22,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications,
                size: 30, color: Colors.white70),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NoticeListPage(notices: _notices)));
            },
          ),
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.logout, size: 30, color: Colors.white70),
              onPressed: _handleLogout,
              tooltip: 'Debug Logout (Emulator Only)',
            ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) =>
                _buildHomePage(constraints.maxWidth, constraints.maxHeight),
          ),
        ),
      ),
      bottomNavigationBar: FooterWidget(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildHomePage(double screenWidth, double screenHeight) {
    bool isTablet = screenWidth > 600;
    double paddingHorizontal = isTablet ? 48 : 16; // Wider padding for tablets
    double paddingVertical = isTablet ? 24 : 16;

    // Calculate available height for content (subtract app bar and padding)
    double availableHeight = screenHeight -
        (isTablet ? 56 : 48) - // App bar height (adjust based on your app bar)
        (paddingVertical * 2); // Vertical padding

    return isTablet
        ? Padding(
            padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal,
              vertical: paddingVertical,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step Progress on the left (50% width)
                Expanded(
                  flex: 1,
                  child: _buildStepProgress(isTablet,
                      availableHeight * 0.9), // Increased height for tablets
                ),
                SizedBox(width: 24), // Spacing between columns
                // Membership, BMI, and Water in a horizontal row on the right (50% width)
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildMembershipBox(
                                    height: availableHeight * 0.3,
                                    width: double.infinity,
                                    isTablet: isTablet),
                                SizedBox(height: 16),
                                _buildHomeOptionBox(
                                  Icons.calculate,
                                  "BMI Calculator",
                                  Colors.blue.shade800,
                                  () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BMICalculatorPage())),
                                  height: availableHeight * 0.3,
                                  width: double.infinity,
                                  isTablet: isTablet,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              width:
                                  16), // Spacing between Membership/BMI and Water
                          Expanded(
                            flex: 1,
                            child: _buildWaterBottle(
                                height: availableHeight * 0.3,
                                isTablet: isTablet),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal,
              vertical: paddingVertical,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepProgress(isTablet, 180), // Default height for phones
                SizedBox(height: 20),
                if (isTablet &&
                    screenWidth > 1000) // Stack vertically on very wide tablets
                  Column(
                    children: [
                      _buildMembershipAndBMICards(
                          isTablet, 140), // Default height for phones
                      SizedBox(height: 20),
                      _buildWaterBottle(
                          height: 200,
                          isTablet: isTablet), // Default height for phones
                    ],
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex:
                            2, // 2/3 of the width for Membership and BMI column
                        child: _buildMembershipAndBMICards(isTablet, 140),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        flex: 1, // 1/3 of the width for Water Intake
                        child: _buildWaterBottle(
                            height: 200,
                            isTablet: isTablet), // Default height for phones
                      ),
                    ],
                  ),
              ],
            ),
          );
  }

  Widget _buildMembershipAndBMICards(bool isTablet, double maxHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMembershipBox(
            height: isTablet ? maxHeight * 0.5 : 140,
            width: double.infinity,
            isTablet: isTablet),
        SizedBox(height: isTablet ? 16 : 16),
        _buildHomeOptionBox(
          Icons.calculate,
          "BMI Calculator",
          Colors.blue.shade800,
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => BMICalculatorPage())),
          height: isTablet ? maxHeight * 0.5 : 140,
          width: double.infinity,
          isTablet: isTablet,
        ),
      ],
    );
  }

  Widget _buildStepProgress(bool isTablet, double maxHeight) {
    double progress = (_steps / _stepGoal).clamp(0.0, 1.0);
    double distance = _steps * _stepLength;

    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 12),
      decoration: BoxDecoration(
        color:
            Colors.grey[900], // Slightly lighter dark background for contrast
        borderRadius: BorderRadius.circular(isTablet ? 24 : 12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: isTablet ? 14 : 8,
            offset: Offset(0, isTablet ? 8 : 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: isTablet
                ? maxHeight * 0.6
                : 180, // Increased height for tablets
            width:
                isTablet ? maxHeight * 0.6 : 180, // Increased width for tablets
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: progress * 100,
                        radius:
                            isTablet ? 50 : 20, // Increased radius for tablets
                        color: Colors.blueAccent, // Brighter color for progress
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: (1 - progress) * 100,
                        radius:
                            isTablet ? 50 : 20, // Increased radius for tablets
                        color: Colors.blueAccent.withOpacity(0.2),
                        showTitle: false,
                      ),
                    ],
                    sectionsSpace: 2,
                    centerSpaceRadius: isTablet
                        ? 100
                        : 70, // Increased center space for tablets
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _steps.toString(),
                      style: TextStyle(
                        fontSize: isTablet
                            ? 70
                            : 36, // Increased text size for tablets
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Steps",
                      style: TextStyle(
                        fontSize: isTablet
                            ? 28
                            : 16, // Increased text size for tablets
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: isTablet ? 20 : 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(Icons.directions_walk,
                  "${distance.toStringAsFixed(1)} mi", isTablet),
              _buildStatItem(Icons.local_fire_department,
                  "${_caloriesBurned.toStringAsFixed(0)} kcal", isTablet),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                  Icons.access_time, "$_activeMinutes min", isTablet),
              _buildStatItem(Icons.stairs, "$_floorsClimbed floors", isTablet),
            ],
          ),
          SizedBox(height: isTablet ? 20 : 16),
          ElevatedButton(
            onPressed: _resetSteps,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent, // Brighter button color
              padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 28 : 16, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isTablet ? 14 : 8)),
            ),
            child: Text(
              "Reset Steps",
              style:
                  TextStyle(fontSize: isTablet ? 18 : 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text, bool isTablet) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: isTablet ? 24 : 18),
        SizedBox(height: isTablet ? 10 : 6),
        Text(
          text,
          style: TextStyle(fontSize: isTablet ? 16 : 12, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildWaterBottle({double height = 200, required bool isTablet}) {
    double fillHeight = (_waterIntake / _dailyGoal) * height;

    return GestureDetector(
      onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const WaterTrackerPage()))
          .then((_) => _loadWaterIntake()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Water Intake",
            style: TextStyle(
              fontSize: isTablet ? 18 : 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isTablet ? 12 : 10),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: isTablet ? 100 : 80,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isTablet ? 22 : 18),
                  border: Border.all(
                      color: Colors.blueAccent.withOpacity(0.8),
                      width: isTablet ? 4 : 2),
                  color:
                      Colors.grey[900], // Match background for better contrast
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: isTablet ? 100 : 80,
                height: fillHeight.clamp(0, height),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent.withOpacity(0.8),
                      Colors.blueAccent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: BorderRadius.circular(isTablet ? 22 : 18),
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 10 : 8),
          Text(
            "${_waterIntake.toStringAsFixed(1)}L / $_dailyGoal L",
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipBox(
      {double height = 160,
      double width = double.infinity,
      required bool isTablet}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade700, Colors.teal.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: isTablet ? 10 : 8,
            offset: Offset(0, isTablet ? 4 : 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(isTablet ? 12 : 10),
      child: Row(
        children: [
          Icon(Icons.card_membership,
              color: Colors.white70, size: isTablet ? 24 : 20),
          SizedBox(width: isTablet ? 16 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Membership",
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: isTablet ? 4 : 4),
                Text(
                  "Days left: 28",
                  style: TextStyle(
                      fontSize: isTablet ? 14 : 12, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeOptionBox(
      IconData icon, String title, Color color, VoidCallback onTap,
      {double height = 160,
      double width = double.infinity,
      required bool isTablet}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.9), color.withOpacity(0.6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: isTablet ? 10 : 8,
              offset: Offset(0, isTablet ? 4 : 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: isTablet ? 28 : 24, color: Colors.white70),
            SizedBox(height: isTablet ? 10 : 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
