import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/features/home/presentation/view/calories_burned_tracker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  setUp(() {});

  Widget createTestableWidget() {
    return const MaterialApp(home: CaloriesBurnedTracker());
  }

  testWidgets('should render all UI elements', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget());

    expect(find.text("Step Tracker"), findsOneWidget);
    expect(find.text("STEPS"), findsOneWidget);
    expect(find.textContaining("MILES"), findsOneWidget);
    expect(find.textContaining("KCAL"), findsOneWidget);
    expect(find.textContaining("MIN"), findsOneWidget);
    expect(find.textContaining("FLOORS"), findsOneWidget);
    expect(find.byType(PieChart), findsOneWidget);
  });
}
