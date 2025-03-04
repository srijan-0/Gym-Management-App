import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/features/home/presentation/view/bmi_calculator_page.dart';

void main() {
  /// ✅ Helper function to create the testable widget
  Widget createTestableWidget() {
    return const MaterialApp(home: BMICalculatorPage());
  }

  testWidgets('✅ should render all UI elements', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget());

    expect(find.text("BMI Calculator"), findsOneWidget);
    expect(find.text("Enter your weight & height to calculate BMI:"),
        findsOneWidget);
    expect(find.text("Weight (kg)"), findsOneWidget);
    expect(find.text("Height (cm)"), findsOneWidget);
    expect(find.text("Calculate BMI"), findsOneWidget);
  });

  testWidgets('✅ should calculate BMI correctly and display the result',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget());

    await tester.enterText(find.byType(TextField).at(0), "70");
    await tester.enterText(find.byType(TextField).at(1), "175");
    await tester.tap(find.text("Calculate BMI"));
    await tester.pumpAndSettle();

    expect(find.textContaining("Your BMI:"), findsOneWidget);
    expect(find.textContaining("Normal Weight"), findsOneWidget);
  });

  testWidgets('✅ should show underweight category when BMI is low',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget());

    await tester.enterText(find.byType(TextField).at(0), "45");
    await tester.enterText(find.byType(TextField).at(1), "175");
    await tester.tap(find.text("Calculate BMI"));
    await tester.pumpAndSettle();

    expect(find.textContaining("Underweight"), findsOneWidget);
  });

  testWidgets('✅ should show overweight category when BMI is high',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget());

    await tester.enterText(find.byType(TextField).at(0), "90");
    await tester.enterText(find.byType(TextField).at(1), "175");
    await tester.tap(find.text("Calculate BMI"));
    await tester.pumpAndSettle();

    expect(find.textContaining("Overweight"), findsOneWidget);
  });

  testWidgets('✅ should show obese category when BMI is very high',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget());

    await tester.enterText(find.byType(TextField).at(0), "110");
    await tester.enterText(find.byType(TextField).at(1), "170");
    await tester.tap(find.text("Calculate BMI"));
    await tester.pumpAndSettle();

    expect(find.textContaining("Obese"), findsOneWidget);
  });

  testWidgets(' should show error message when input is invalid',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget());

    await tester.enterText(find.byType(TextField).at(0), "abc");
    await tester.enterText(find.byType(TextField).at(1), "def");
    await tester.tap(find.text("Calculate BMI"));
    await tester.pumpAndSettle();

    expect(find.text("Please enter valid numbers!"), findsOneWidget);
  });

  testWidgets(' should show error message when height is 0',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget());

    await tester.enterText(find.byType(TextField).at(0), "70");
    await tester.enterText(find.byType(TextField).at(1), "0");
    await tester.tap(find.text("Calculate BMI"));
    await tester.pumpAndSettle();

    expect(find.text("Please enter valid numbers!"), findsOneWidget);
  });
}
