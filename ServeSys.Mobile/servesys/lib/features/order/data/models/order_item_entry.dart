import 'package:servesys/features/menu/domain/entities/menu_item.dart';

class OrderItemEntry {
  final MenuItem menuItem;
  int quantity;

  OrderItemEntry({
    required this.menuItem,
    this.quantity = 0,
  });

  int get subtotal => (menuItem.price * quantity).toInt();
}