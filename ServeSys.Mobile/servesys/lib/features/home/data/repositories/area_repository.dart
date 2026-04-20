import 'package:dio/dio.dart';
import 'package:servesys/core/error/dio_error_mapper.dart';
import 'package:servesys/core/network/api_client.dart';
import 'package:servesys/core/network/api_endpoints.dart';
import 'package:servesys/core/network/api_response.dart';
import 'package:servesys/features/home/data/models/area_model.dart';
import 'package:servesys/features/home/domain/entities/area.dart';

class AreaRepository {
  final ApiClient _apiClient;

  AreaRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<Area>> getAreas() async {
    try {
      final json = await _apiClient.get(ApiEndpoints.areas);
      final response = ApiResponse<List<Area>>.fromJson(
        json,
        (data) => (data as List)
            .map((e) => AreaModel.fromJson(e).toEntity())
            .toList(),
      );
      if (!response.success) {
        throw Exception(response.message ?? 'Tải danh dách khu vực thất bại');
      }
      return response.data ?? [];
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }
}
