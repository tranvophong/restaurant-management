import 'package:servesys/features/menu/domain/entities/menu_item.dart';

abstract class MenuItemState {}

class MenuItemInitial extends MenuItemState {}

class MenuItemLoading extends MenuItemState {}

class MenuItemSuccess extends MenuItemState {
  final List<MenuItem> items;
  MenuItemSuccess({required this.items});
}

class MenuItemError extends MenuItemState {
  final String message;
  MenuItemError(this.message);
}
