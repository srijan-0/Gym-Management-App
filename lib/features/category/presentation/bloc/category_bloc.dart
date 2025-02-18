import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_all_categories.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetAllCategories getAllCategories;

  CategoryBloc({required this.getAllCategories}) : super(CategoryInitial()) {
    on<FetchCategories>((event, emit) async {
      emit(CategoryLoading());
      final result = await getAllCategories();

      result.fold(
        (failure) => emit(CategoryError(failure)),
        (categories) => emit(CategoryLoaded(categories)),
      );
    });
  }
}
