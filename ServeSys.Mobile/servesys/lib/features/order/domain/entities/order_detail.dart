import 'package:servesys/features/order/domain/enums/order_item_status.dart';

class OrderDetail {
  final String orderCode;
  final int tableId;
  final String notes;
  final double totalPrice;
  final double tax = 0;
  final List<OrderItemDetail> items;
  final DateTime createdAt;

  const OrderDetail({
    required this.orderCode,
    required this.tableId,
    required this.notes,
    required this.totalPrice,
    required this.items,
    required this.createdAt,
  });

  double get subtotal => totalPrice;
  double get totalWithTax => totalPrice + tax;

  /// Sort: SERVED items go last, others sorted ascending by orderAt
  List<OrderItemDetail> get sortedItems {
    final nonServed = items
        .where((i) => i.status != OrderItemStatus.served)
        .toList()
      ..sort((a, b) {
        if (a.orderAt == null && b.orderAt == null) return 0;
        if (a.orderAt == null) return 1;
        if (b.orderAt == null) return -1;
        return a.orderAt!.compareTo(b.orderAt!);
      });

    final served = items
        .where((i) => i.status == OrderItemStatus.served)
        .toList()
      ..sort((a, b) {
        if (a.orderAt == null && b.orderAt == null) return 0;
        if (a.orderAt == null) return 1;
        if (b.orderAt == null) return -1;
        return a.orderAt!.compareTo(b.orderAt!);
      });

    return [...nonServed, ...served];
  }
}

class OrderItemDetail {
  final int menuItemId;
  final int quantity;
  final String title;
  final String description;
  final double price;
  final String? imgUrl;
  final String staffName;
  final String? notes;
  final OrderItemStatus status;
  final DateTime? orderAt;

  OrderItemDetail({
    required this.menuItemId,
    required this.quantity,
    required this.title,
    required this.description,
    required this.price,
    required this.imgUrl,
    required this.staffName,
    required this.status,
    this.notes,
    this.orderAt
  });
}
