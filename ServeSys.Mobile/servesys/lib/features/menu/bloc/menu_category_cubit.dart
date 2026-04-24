import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servesys/core/error/app_exception.dart';
import 'package:servesys/features/menu/bloc/menu_category_state.dart';
import 'package:servesys/features/menu/data/repositories/menu_repository.dart';

class MenuCategoryCubit extends Cubit<MenuCategoryState> {
  final MenuRepository _menuRepository;

  MenuCategoryCubit({required MenuRepository menuRepository})
    : _menuRepository = menuRepository,
      super(MenuCategoryInitial());

  Future<void> loadCategories() async {
    emit(MenuCategoryLoading());
    try {
      final categories = await _menuRepository.getMenuCategories();
      emit(MenuCategorySuccess(categories: categories));
    } catch (e) {
      if (e is AppException) {
        emit(MenuCategoryError(e.toString()));
      } else {
        emit(MenuCategoryError('Lỗi không xác định'));
      }
    }
  }

  void selectCategory(int index) {
    if (state is MenuCategorySuccess) {
      emit((state as MenuCategorySuccess).copyWith(selectedIndex: index));
    }
  }
}
