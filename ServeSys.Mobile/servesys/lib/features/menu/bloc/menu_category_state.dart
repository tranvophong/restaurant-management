import 'package:servesys/features/menu/domain/entities/menu_category.dart';

abstract class MenuCategoryState {}

class MenuCategoryInitial extends MenuCategoryState {}

class MenuCategoryLoading extends MenuCategoryState {}

class MenuCategorySuccess extends MenuCategoryState {
  final List<MenuCategory> categories;
  int selectedIndex;
  MenuCategorySuccess({required this.categories, this.selectedIndex = -1});

  MenuCategorySuccess copyWith({List<MenuCategory>? categories, int? selectedIndex}) {
    return MenuCategorySuccess(
      categories: categories ?? this.categories,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

class MenuCategoryError extends MenuCategoryState {
  final String message;
  MenuCategoryError(this.message);
}
