import 'package:servesys/core/base/base_repository.dart';
import 'package:servesys/core/network/api_endpoints.dart';
import 'package:servesys/features/order/data/models/order_detail_model.dart';
import 'package:servesys/features/order/domain/entities/order_detail.dart';

class OrderRepository extends BaseRepository {
  OrderRepository(super.apiClient);

  Future<(int, String)> placeOrder(int tableId, String notes, List<Map<String, dynamic>> items) {
    return handle(
      (api) => api.post(ApiEndpoints.placeOrder, data: {
        'tableId': tableId,
        'notes': notes,
        'items': items,
      }),
      (json) => (json['tableId'] as int, json['orderCode'] as String),
    );
  }

  Future<OrderDetail> getOrderByCode(int tableId) {
    return handle(
      (api) => api.get(ApiEndpoints.orderDetail(tableId)),
      (json) => OrderDetailModel.fromJson(json).toEntity(),
    );
  }
}