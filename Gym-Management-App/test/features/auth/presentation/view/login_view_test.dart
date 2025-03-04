import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/features/auth/presentation/view/login_view.dart';
import 'package:login/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:mocktail/mocktail.dart';

/// **Mock Class for LoginBloc**
class MockLoginBloc extends Mock implements LoginBloc {}

void main() {
  late MockLoginBloc mockLoginBloc;

  setUp(() {
    mockLoginBloc = MockLoginBloc();
  });

  Widget createTestableWidget(Widget child) {
    return BlocProvider<LoginBloc>.value(
      value: mockLoginBloc,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('should render login screen correctly',
      (WidgetTester tester) async {
    // **Arrange**
    await tester.pumpWidget(createTestableWidget(LoginView()));

    // **Assert: Check if UI elements exist**
    expect(find.text('FitZone'), findsOneWidget);
    expect(find.text('Your Fitness Journey Starts Here'), findsOneWidget);
    expect(find.byType(TextFormField),
        findsNWidgets(2)); // Email & Password fields
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget); // Sign In Button
  });

  testWidgets('should show validation error when fields are empty',
      (WidgetTester tester) async {
    // **Arrange**
    await tester.pumpWidget(createTestableWidget(LoginView()));

    // **Act**
    await tester.tap(find.byType(ElevatedButton)); // Tap Login button
    await tester.pumpAndSettle();

    // **Assert**
    expect(find.text("Enter your email"), findsOneWidget);
    expect(find.text("Enter your password"), findsOneWidget);
  });

  testWidgets('should allow user to enter email and password',
      (WidgetTester tester) async {
    // **Arrange**
    await tester.pumpWidget(createTestableWidget(LoginView()));

    // **Act**
    await tester.enterText(
        find.byType(TextFormField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.pumpAndSettle();

    // **Assert**
    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.text('password123'), findsOneWidget);
  });
}
