import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/features/category/data/repositories/category_repository_impl.dart';
import 'package:login/features/category/presentation/pages/category_page.dart';
import 'package:mocktail/mocktail.dart';

/// **Mock Class for Category Repository**
class MockCategoryRepository extends Mock implements CategoryRepositoryImpl {}

void main() {
  late MockCategoryRepository mockCategoryRepository;

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
  });

  Widget createTestableWidget(Widget child) {
    return MaterialApp(home: child);
  }

  testWidgets('should show CircularProgressIndicator while loading',
      (WidgetTester tester) async {
    // **Arrange**
    await tester.pumpWidget(createTestableWidget(const CategoryPage()));

    // **Assert**
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show "No categories available" when fetching fails',
      (WidgetTester tester) async {
    // **Arrange**
    when(() => mockCategoryRepository.getAllCategories())
        .thenAnswer((_) async => Future.value(Left("API Error")));

    await tester.pumpWidget(createTestableWidget(const CategoryPage()));
    await tester.pumpAndSettle();

    // **Assert**
    expect(find.text('No categories available.'), findsOneWidget);
  });
}
