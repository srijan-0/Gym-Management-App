import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/features/category/domain/entities/category_entity.dart';
import 'package:login/features/category/domain/usecases/get_all_categories.dart';
import 'package:login/features/category/presentation/bloc/category_bloc.dart';
import 'package:login/features/category/presentation/bloc/category_event.dart';
import 'package:login/features/category/presentation/bloc/category_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllCategories extends Mock implements GetAllCategories {}

void main() {
  late MockGetAllCategories mockGetAllCategories;
  late CategoryBloc categoryBloc;

  setUp(() {
    mockGetAllCategories = MockGetAllCategories();
    categoryBloc = CategoryBloc(getAllCategories: mockGetAllCategories);
  });

  tearDown(() {
    categoryBloc.close();
  });

  final categoryList = [
    const CategoryEntity(
      id: "1",
      cName: "Electronics",
      cDescription: "Devices & Gadgets",
      cImage: "electronics.png",
      cStatus: "Active",
    ),
    const CategoryEntity(
      id: "2",
      cName: "Fashion",
      cDescription: "Clothing & Accessories",
      cImage: "fashion.png",
      cStatus: "Active",
    ),
  ];

  group('CategoryBloc', () {
    test('Initial state should be CategoryInitial', () {
      expect(categoryBloc.state, isA<CategoryInitial>());
    });

    blocTest<CategoryBloc, CategoryState>(
      'Emits [CategoryLoading, CategoryLoaded] when FetchCategories is added and succeeds',
      build: () {
        when(() => mockGetAllCategories())
            .thenAnswer((_) async => Right(categoryList));
        return categoryBloc;
      },
      act: (bloc) => bloc.add(FetchCategories()),
      expect: () => [
        isA<CategoryLoading>(),
        predicate((state) =>
            state is CategoryLoaded &&
            state.categories.length == categoryList.length &&
            state.categories.first.cName == categoryList.first.cName),
      ],
      verify: (_) {
        verify(() => mockGetAllCategories()).called(1);
      },
    );

    blocTest<CategoryBloc, CategoryState>(
      ' Emits [CategoryLoading, CategoryError] when FetchCategories is added and fails',
      build: () {
        when(() => mockGetAllCategories())
            .thenAnswer((_) async => Left("Failed to fetch categories"));
        return categoryBloc;
      },
      act: (bloc) => bloc.add(FetchCategories()),
      expect: () => [
        isA<CategoryLoading>(),
        isA<CategoryError>()
            .having((e) => e.message, 'message', 'Failed to fetch categories'),
      ],
      verify: (_) {
        verify(() => mockGetAllCategories()).called(1);
      },
    );
  });
}
