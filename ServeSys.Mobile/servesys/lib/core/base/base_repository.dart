import 'package:dio/dio.dart';
import 'package:servesys/core/error/app_exception.dart';
import 'package:servesys/core/error/dio_error_mapper.dart';
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
        throw AppException(message: response.firstErrorMessage.description);
      }

      return response.data as T;
    } on DioException catch (dioEx) {
      throw DioErrorMapper.map(dioEx);
    } 
    catch (e) {
      rethrow;
    }
  }
}