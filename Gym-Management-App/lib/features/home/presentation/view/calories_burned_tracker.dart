import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CaloriesBurnedTracker extends StatefulWidget {
  const CaloriesBurnedTracker({super.key});

  @override
  _CaloriesBurnedTrackerState createState() => _CaloriesBurnedTrackerState();
}

class _CaloriesBurnedTrackerState extends State<CaloriesBurnedTracker> {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  int _steps = 0;
  double _caloriesBurned = 0.0;
  int _activeMinutes = 0;
  int _floorsClimbed = 0;
  double _lastZ = 0.0;
  double _totalElevationGain = 0.0;
  final double _caloriesPerStep = 0.04;
  final double _stepLength = 0.0008;
  final double _threshold = 1.5;
  double _lastAccel = 0.0;
  final int _stepGoal = 10000;
  DateTime? _lastStepTime;

  @override
  void initState() {
    super.initState();
    _loadSavedSteps();
    _initAccelerometer();
  }

  Future<void> _loadSavedSteps() async {
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

  void _initAccelerometer() {
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      double acceleration =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

      if ((acceleration - _lastAccel).abs() > _threshold) {
        setState(() {
          _steps++;
          _caloriesBurned = _steps * _caloriesPerStep;
        });

        /// 🔹 Track Active Minutes
        DateTime now = DateTime.now();
        if (_lastStepTime == null ||
            now.difference(_lastStepTime!).inSeconds > 60) {
          _activeMinutes++;
          _lastStepTime = now;
        }

        _saveSteps();
      }
      _lastAccel = acceleration;

      /// 🔹 Detect Floors Climbed
      double verticalMovement = event.z - _lastZ;
      if (verticalMovement.abs() > 0.5) {
        _totalElevationGain += verticalMovement;
        if (_totalElevationGain >= 3.0) {
          // 3 meters = 1 floor
          setState(() {
            _floorsClimbed++;
            _totalElevationGain = 0; // Reset after counting
          });
          _saveSteps();
        }
      }
      _lastZ = event.z;
    });
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

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = (_steps / _stepGoal).clamp(0.0, 1.0);
    double distance = _steps * _stepLength;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:
            const Text("Step Tracker", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// 📌 Circular Progress Chart for Steps
            SizedBox(
              height: 250,
              width: 250,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: progress * 100,
                          radius: 15,
                          color: Colors.green,
                          showTitle: false,
                        ),
                        PieChartSectionData(
                          value: (1 - progress) * 100,
                          radius: 15,
                          color: Colors.red,
                          showTitle: false,
                        ),
                      ],
                      sectionsSpace: 0,
                      centerSpaceRadius: 85,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _steps.toString(),
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        "STEPS",
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 📌 Stats Row (Distance, Calories, Time, Floors)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(Icons.directions_walk,
                    "${distance.toStringAsFixed(1)} MILES"),
                _buildStatItem(Icons.local_fire_department,
                    "${_caloriesBurned.toStringAsFixed(0)} KCAL"),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(Icons.access_time, "$_activeMinutes MIN"),
                _buildStatItem(Icons.stairs, "$_floorsClimbed FLOORS"),
              ],
            ),

            const SizedBox(height: 20),

            /// 📌 Reset Button
            ElevatedButton(
              onPressed: _resetSteps,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                "Reset Steps",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 📌 Helper Method to Build Small Info Cards
  Widget _buildStatItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        const SizedBox(height: 5),
        Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ],
    );
  }
}
