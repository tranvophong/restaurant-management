import 'package:dio/dio.dart';
import 'package:servesys/core/error/dio_error_mapper.dart';
import 'package:servesys/core/network/api_client.dart';
import 'package:servesys/core/network/api_endpoints.dart';
import 'package:servesys/core/network/api_response.dart';
import 'package:servesys/features/home/data/models/table_model.dart';
import 'package:servesys/features/home/domain/entities/table.dart';

class TableRepository {
  final ApiClient _apiClient;

  TableRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<Table>> getTables(int areaId) async {
    try {
      final json = await _apiClient.get(ApiEndpoints.tablesByArea(areaId));
      final response = ApiResponse<List<Table>>.fromJson(
        json,
        (data) => (data as List)
            .map((e) => TableModel.fromJson(e).toEntity())
            .toList(),
      );
      if (!response.success) {
        throw Exception(response.message ?? 'Tải danh dách bàn thất bại');
      }
      return response.data ?? [];
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }
}
