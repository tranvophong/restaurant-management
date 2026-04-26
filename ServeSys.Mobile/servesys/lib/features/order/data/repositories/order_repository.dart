import 'package:servesys/core/base/base_repository.dart';
import 'package:servesys/core/network/api_endpoints.dart';

class OrderRepository extends BaseRepository {
  OrderRepository(super.apiClient);

  Future<void> placeOrder(int tableId, String notes, List<Map<String, dynamic>> items) {
    return handle<void>(
      (api) => api.post(ApiEndpoints.placeOrder, data: {
        'tableId': tableId,
        'notes': notes,
        'items': items,
      }),
      (json) => null,
    );
  }
}