import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterTrackerPage extends StatefulWidget {
  const WaterTrackerPage({super.key});

  @override
  State<WaterTrackerPage> createState() => _WaterTrackerPageState();
}

class _WaterTrackerPageState extends State<WaterTrackerPage> {
  double _waterIntake = 0.0; // Current water intake
  final double _dailyGoal = 3.0; // 3L daily goal

  @override
  void initState() {
    super.initState();
    _loadWaterIntake();
  }

  /// ✅ Load Water Intake from Storage
  Future<void> _loadWaterIntake() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _waterIntake = prefs.getDouble('water_intake') ?? 0.0;
    });
  }

  /// ✅ Save Water Intake
  Future<void> _saveWaterIntake() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('water_intake', _waterIntake);
  }

  /// ✅ Add Water Intake (250ml, 500ml)
  void _addWater(double amount) {
    setState(() {
      _waterIntake += amount;
      if (_waterIntake > _dailyGoal) _waterIntake = _dailyGoal; // Limit to goal
    });
    _saveWaterIntake();
  }

  /// ✅ Reset Water Intake
  void _resetWaterIntake() {
    setState(() {
      _waterIntake = 0.0;
    });
    _saveWaterIntake();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Water Tracker"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetWaterIntake, // Reset button
            tooltip: "Reset Water Intake",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Daily Water Intake Goal",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            /// ✅ Progress Bar
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 180,
                  width: 180,
                  child: CircularProgressIndicator(
                    value: _waterIntake / _dailyGoal,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.blue,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "${_waterIntake.toStringAsFixed(1)}L",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "of $_dailyGoal L",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// ✅ Add Water Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildWaterButton("250ml", 0.25),
                _buildWaterButton("500ml", 0.5),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Water Intake Buttons
  Widget _buildWaterButton(String label, double amount) {
    return ElevatedButton(
      onPressed: () => _addWater(amount),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        backgroundColor: Colors.blue.shade300,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
