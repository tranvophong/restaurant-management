import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servesys/features/order/data/repositories/order_repository.dart';
import 'order_detail_state.dart';

class OrderDetailCubit extends Cubit<OrderDetailState> {
  final OrderRepository _orderRepository;

  OrderDetailCubit(this._orderRepository) : super(OrderDetailInitial());

  Future<void> getOrderDetail(int tableId) async {
    emit(OrderDetailLoading());
    try {
      final order = await _orderRepository.getOrderByCode(tableId);
      emit(OrderDetailSuccess(order));
    } catch (e) {
      emit(OrderDetailError(e.toString()));
    }
  }
}
