import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servesys/features/order/bloc/order_submission_state.dart';
import 'package:servesys/features/order/data/repositories/order_repository.dart';

class OrderSubmissionCubit extends Cubit<OrderSubmissionState> {
  final OrderRepository orderRepository;

  OrderSubmissionCubit(this.orderRepository) : super(OrderSubmissionInitial());

  Future<void> submitOrder(int tableId, String notes, List<Map<String, dynamic>> items) async {
    emit(OrderSubmissionLoading());
    try {
    final returnedOrder = await orderRepository.placeOrder(tableId, notes, items);
      emit(OrderSubmissionSuccess(returnedOrder.$1, returnedOrder.$2));
    } catch (e) {
      emit(OrderSubmissionError(e.toString()));
    }
  }
}
