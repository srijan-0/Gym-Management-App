import 'package:flutter/material.dart';

class BMICalculatorPage extends StatefulWidget {
  const BMICalculatorPage({super.key});

  @override
  State<BMICalculatorPage> createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  double? _bmi;
  String _bmiCategory = "";

  /// ✅ BMI Calculation Logic
  void _calculateBMI() {
    double? weight = double.tryParse(_weightController.text);
    double? height = double.tryParse(_heightController.text);

    if (weight == null || height == null || height == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please enter valid numbers!"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    double bmi = weight / ((height / 100) * (height / 100)); // BMI Formula
    setState(() {
      _bmi = bmi;
      _bmiCategory = _getBMICategory(bmi);
    });
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return "Underweight 😔";
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return "Normal Weight 😊";
    } else if (bmi >= 25 && bmi < 29.9) {
      return "Overweight 😟";
    } else {
      return "Obese 😢";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // ✅ Dark Theme Background
      appBar: AppBar(
        title: const Text("BMI Calculator"),
        backgroundColor: Colors.deepPurple.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ✅ Dark Theme Heading
            const Text(
              "Enter your weight & height to calculate BMI:",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 20),

            /// ✅ Weight Input (Dark Mode)
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white), // Text color
              decoration: InputDecoration(
                labelText: "Weight (kg)",
                labelStyle:
                    const TextStyle(color: Colors.white70), // Label color
                prefixIcon:
                    const Icon(Icons.fitness_center, color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white54),
                ),
                filled: true,
                fillColor: Colors.grey[900], // Dark field background
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Height (cm)",
                labelStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.height, color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white54),
                ),
                filled: true,
                fillColor: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculateBMI,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Calculate BMI",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            if (_bmi != null)
              Center(
                child: Card(
                  color: Colors.grey[850], // Dark card color
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "Your BMI: ${_bmi!.toStringAsFixed(1)}",
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _bmiCategory,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _bmiCategory.contains("Normal")
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
