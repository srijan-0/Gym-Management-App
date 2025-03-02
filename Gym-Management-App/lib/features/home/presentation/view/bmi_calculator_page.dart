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
        const SnackBar(content: Text("Please enter valid numbers!")),
      );
      return;
    }

    double bmi = weight / ((height / 100) * (height / 100)); // BMI Formula
    setState(() {
      _bmi = bmi;
      _bmiCategory = _getBMICategory(bmi);
    });
  }

  /// ✅ Determine BMI Category
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
      appBar: AppBar(
        title: const Text("BMI Calculator"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter your weight & height to calculate BMI:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            /// ✅ Weight Input
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Weight (kg)",
                prefixIcon: const Icon(Icons.fitness_center),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// ✅ Height Input
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Height (cm)",
                prefixIcon: const Icon(Icons.height),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// ✅ Calculate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculateBMI,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  backgroundColor: Colors.deepPurple,
                ),
                child: const Text("Calculate BMI",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
            ),

            const SizedBox(height: 30),

            /// ✅ Display BMI Result
            if (_bmi != null)
              Center(
                child: Column(
                  children: [
                    Text(
                      "Your BMI: ${_bmi!.toStringAsFixed(1)}",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
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
          ],
        ),
      ),
    );
  }
}
