import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/features/auth/presentation/view/register_view.dart';
import 'package:login/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:mocktail/mocktail.dart';

/// **Mock Class for RegisterBloc**
class MockRegisterBloc extends Mock implements RegisterBloc {}

/// **Fix: Define Fake Bloc Events**
class FakeRegisterCustomerEvent extends Fake implements Registercustomer {}

void main() {
  late MockRegisterBloc mockRegisterBloc;

  setUpAll(() {
    /// **🔥 Fix: Register Fake Events in Mocktail**
    registerFallbackValue(FakeRegisterCustomerEvent());
  });

  setUp(() {
    mockRegisterBloc = MockRegisterBloc();
  });

  Widget createTestableWidget(Widget child) {
    return BlocProvider<RegisterBloc>.value(
      value: mockRegisterBloc,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets(' should render RegisterView correctly',
      (WidgetTester tester) async {
    // **Arrange**
    await tester.pumpWidget(createTestableWidget(const RegisterView()));

    // **Assert**
    expect(find.text("Create an Account"), findsOneWidget);
    expect(find.byType(TextFormField),
        findsNWidgets(4)); // Name, Email, Password, Confirm Password
    expect(
        find.byType(ElevatedButton), findsOneWidget); // Create Account Button
  });

  testWidgets(
      'should allow user to enter name, email, password, and confirm password',
      (WidgetTester tester) async {
    // **Arrange**
    await tester.pumpWidget(createTestableWidget(const RegisterView()));

    // **Act**
    await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'password123');
    await tester.enterText(find.byType(TextFormField).at(3), 'password123');
    await tester.pumpAndSettle();

    // **Assert**
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.text('password123'), findsNWidgets(2));
  });
}
