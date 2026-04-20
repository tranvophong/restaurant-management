import 'package:servesys/core/network/api_client.dart';
import 'package:servesys/core/network/api_response.dart';

class BaseRepository {
  final ApiClient apiClient;

  BaseRepository(this.apiClient);

  Future<T> handle<T>(
    Future<dynamic> Function(ApiClient) request,
    T Function(dynamic) parser,
  ) async {
    try {
      final json = await request(apiClient);
      final response = ApiResponse<T>.fromJson(json, parser);

      if (!response.success) {
        throw Exception(response.message);
      }

      return response.data as T;
    } catch (e) {
      rethrow;
    }
  }
}