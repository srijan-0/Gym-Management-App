import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterTrackerPage extends StatefulWidget {
  const WaterTrackerPage({super.key});

  @override
  State<WaterTrackerPage> createState() => _WaterTrackerPageState();
}

class _WaterTrackerPageState extends State<WaterTrackerPage> {
  double _waterIntake = 0.0;
  final double _dailyGoal = 3.0;

  @override
  void initState() {
    super.initState();
    _loadWaterIntake();
  }

  Future<void> _loadWaterIntake() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _waterIntake = prefs.getDouble('water_intake') ?? 0.0;
    });
  }

  Future<void> _saveWaterIntake() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('water_intake', _waterIntake);
  }

  void _addWater(double amount) {
    setState(() {
      _waterIntake += amount;
      if (_waterIntake > _dailyGoal) _waterIntake = _dailyGoal;
    });
    _saveWaterIntake();
  }

  void _resetWaterIntake() {
    setState(() {
      _waterIntake = 0.0;
    });
    _saveWaterIntake();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          "Water Tracker",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple.shade900,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white70),
            onPressed: _resetWaterIntake,
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
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 180,
                  width: 180,
                  child: CircularProgressIndicator(
                    value: _waterIntake / _dailyGoal,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey.shade800,
                    color: Colors.blueAccent,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "${_waterIntake.toStringAsFixed(1)}L",
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      "of $_dailyGoal L",
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
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

  Widget _buildWaterButton(String label, double amount) {
    return ElevatedButton(
      onPressed: () => _addWater(amount),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        backgroundColor: Colors.blueGrey.shade700,
      ),
      child: Text(
        label,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
