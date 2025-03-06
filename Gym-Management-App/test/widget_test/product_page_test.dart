import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/features/category/domain/entities/category_entity.dart';
import 'package:login/features/product/domain/entities/product_entity.dart';
import 'package:login/features/product/prsentation/pages/product_page.dart';
import 'package:mocktail/mocktail.dart';

class MockCategory extends Mock implements CategoryEntity {}

class MockProduct extends Mock implements ProductEntity {}

void main() {
  Widget createTestableWidget({CategoryEntity? selectedCategory}) {
    return MaterialApp(
      home: ProductPage(selectedCategory: selectedCategory),
    );
  }

  testWidgets('should show "No products available" when there are no products',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget());

    await tester.pumpAndSettle();

    expect(find.text("No products available."), findsOneWidget);
  });
}
