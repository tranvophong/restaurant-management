import 'package:dio/dio.dart';
import 'package:servesys/core/error/app_exception.dart';
import 'package:servesys/core/error/network_exception.dart';
import 'package:servesys/core/error/server_exception.dart';
import 'package:servesys/core/network/api_response.dart';

class DioErrorMapper {
  static AppException map(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionError:
        return NetworkException();

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;

        // Try to extract structured errors from the response body first.
        // The server may return { "success": false, "message": "...", "errors": [...] }
        // even on 4xx responses.
        final body = e.response?.data;
        if (body is Map<String, dynamic>) {
          try {
            final apiResponse = ApiResponse.fromJson(body, null);
            final allErrors = apiResponse.allErrorMessages;
            if (allErrors.isNotEmpty) {
              return AppException(
                message: allErrors.first.description,
                errors: allErrors,
              );
            }
          } catch (_) {
            // Body wasn't a valid ApiResponse — fall through to status-based fallback.
          }
        }

        // Status-based fallback when body couldn't be parsed.
        if (statusCode == 500) return ServerException();
        return AppException(message: 'Lỗi server: $statusCode');

      default:
        return AppException(message: 'Đã xảy ra lỗi');
    }
  }
}
