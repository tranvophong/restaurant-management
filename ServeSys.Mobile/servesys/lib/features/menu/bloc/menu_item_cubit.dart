import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servesys/core/error/app_exception.dart';
import 'package:servesys/features/menu/bloc/menu_item_state.dart';
import 'package:servesys/features/menu/data/repositories/menu_repository.dart';

class MenuItemCubit extends Cubit<MenuItemState> {
  final MenuRepository _menuRepository;

  MenuItemCubit({required MenuRepository menuRepository})
    : _menuRepository = menuRepository,
      super(MenuItemInitial());

  Future<void> loadMenuItems(int categoryId) async {
    emit(MenuItemLoading());
    try {
      final items = await _menuRepository.getMenuItemsByCategory(categoryId);
      emit(MenuItemSuccess(items: items));
    } catch (e) {
      if (e is AppException) {
        emit(MenuItemError(e.toString()));
      } else {
        emit(MenuItemError('Lỗi không xác định'));
      }
    }
  }
}
