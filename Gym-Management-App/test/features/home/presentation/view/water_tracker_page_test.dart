import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/features/home/presentation/view/water_tracker_page.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  setUp(() {});

  Widget createTestableWidget() {
    return const MaterialApp(home: WaterTrackerPage());
  }

  testWidgets('✅ should render all UI elements', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget());

    // **Assert**
    expect(find.text("Water Tracker"), findsOneWidget);
    expect(find.text("Daily Water Intake Goal"), findsOneWidget);
    expect(find.text("250ml"), findsOneWidget);
    expect(find.text("500ml"), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('✅ should add 250ml of water intake when button is pressed',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget());

    await tester.tap(find.text("250ml"));
    await tester.pumpAndSettle();

    expect(find.textContaining("0.3L"), findsOneWidget);
  });

  testWidgets('✅ should add 500ml of water intake when button is pressed',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget());

    await tester.tap(find.text("500ml"));
    await tester.pumpAndSettle();

    expect(find.textContaining("0.5L"), findsOneWidget);
  });

  testWidgets('✅ should not exceed 3.0L daily goal',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget());

    for (int i = 0; i < 10; i++) {
      await tester.tap(find.text("500ml"));
      await tester.pumpAndSettle();
    }

    expect(find.textContaining("3.0L"), findsOneWidget);
  });

  testWidgets('✅ should reset water intake to 0.0L when reset button is tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget());

    await tester.tap(find.text("500ml"));
    await tester.pumpAndSettle();
    expect(find.textContaining("0.5L"), findsOneWidget);

    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pumpAndSettle();

    expect(find.textContaining("0.0L"), findsOneWidget);
  });
}
