import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servesys/features/menu/domain/entities/menu_item.dart';
import 'package:servesys/features/order/data/models/order_item_entry.dart';

class OrderDraftCubit extends Cubit<List<OrderItemEntry>> {
  OrderDraftCubit() : super([]);

  void increment(MenuItem item) {
    final current = List<OrderItemEntry>.from(state);
    final index = current.indexWhere((e) => e.menuItem.id == item.id);

    if (index == -1) {
      current.add(OrderItemEntry(menuItem: item, quantity: 1));
    } else {
      current[index].quantity++;
    }
    emit(List.from(current));
  }

  void decrement(MenuItem item) {
    final current = List<OrderItemEntry>.from(state);
    final index = current.indexWhere((e) => e.menuItem.id == item.id);
    if (index == -1) return;

    if (current[index].quantity <= 1) {
      current.removeAt(index);
    } else {
      current[index].quantity--;
    }
    emit(List.from(current));
  }

  int quantityOf(int itemId) {
    final entry = state.where((e) => e.menuItem.id == itemId);
    return entry.isEmpty ? 0 : entry.first.quantity;
  }

  int get totalItems => state.fold(0, (s, e) => s + e.quantity);
  int get totalPrice => state.fold(0, (s, e) => s + e.subtotal);

  List<Map<String, dynamic>> toOrderPayload() {
    return state.map((e) => {
      'menuItemId': e.menuItem.id,
      'quantity': e.quantity,
      'notes': '', // Support item-level notes if needed later
    }).toList();
  }
}