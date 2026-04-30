import 'package:servesys/features/order/domain/entities/order_detail.dart';

abstract class OrderDetailState {}

class OrderDetailInitial extends OrderDetailState {}

class OrderDetailLoading extends OrderDetailState {}

class OrderDetailSuccess extends OrderDetailState {
  final OrderDetail order;

  OrderDetailSuccess(this.order);
}

class OrderDetailError extends OrderDetailState {
  final String message;

  OrderDetailError(this.message);
}
