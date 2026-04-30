import 'package:servesys/features/order/domain/entities/order_detail.dart';
import 'package:servesys/features/order/domain/enums/order_item_status.dart';

class OrderDetailModel {
  final String orderCode;
  final int tableId;
  final String notes;
  final double totalPrice;
  final List<OrderItemDetailModel> items;
  final DateTime createdAt;

  OrderDetailModel({
    required this.orderCode,
    required this.tableId,
    required this.notes,
    required this.totalPrice,
    required this.items,
    required this.createdAt,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      orderCode: json['orderCode'] ?? '',
      tableId: json['tableId'] ?? 0,
      notes: json['notes'] ?? '',
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItemDetailModel.fromJson(item))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  OrderDetail toEntity() {
    return OrderDetail(
      orderCode: orderCode,
      tableId: tableId,
      notes: notes,
      totalPrice: totalPrice,
      items: items.map((item) => item.toEntity()).toList(),
      createdAt: createdAt,
    );
  }
}

class OrderItemDetailModel {
  final int menuItemId;
  final int quantity;
  final String title;
  final String description;
  final double price;
  final String? imgUrl;
  final String staffName;
  final String? notes;
  final OrderItemStatus status;

  OrderItemDetailModel({
    required this.menuItemId,
    required this.quantity,
    required this.title,
    required this.description,
    required this.price,
    required this.imgUrl,
    required this.staffName,
    required this.status,
    this.notes,
  });

  factory OrderItemDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderItemDetailModel(
      menuItemId: json['menuItemId'] ?? 0,
      quantity: json['quantity'] ?? 0,
      notes: json['notes'],
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'],
      imgUrl: json['imgUrl'],
      staffName: json['staffName'],
      title: json['title'],
      status: OrderItemStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderItemStatus.pending,
      ),
    );
  }

  OrderItemDetail toEntity() {
    return OrderItemDetail(
      menuItemId: menuItemId,
      quantity: quantity,
      notes: notes,
      price: price,
      description: description,
      imgUrl: imgUrl,
      staffName: staffName,
      status: status,
      title: title,
    );
  }
}
