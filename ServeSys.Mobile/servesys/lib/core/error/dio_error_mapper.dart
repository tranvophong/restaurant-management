import 'package:dio/dio.dart';
import 'package:servesys/core/error/app_exception.dart';
import 'package:servesys/core/error/network_exception.dart';
import 'package:servesys/core/error/server_exception.dart';

class DioErrorMapper {
  static AppException map(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return NetworkException();

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;

        // if (statusCode == 401) {
        //   return UnauthorizedException();
        // } else
        if (statusCode == 500) {
          return ServerException();
        } else {
          return AppException(message: 'Lỗi server: $statusCode');
        }

      case DioExceptionType.connectionError:
        return NetworkException();

      default:
        return AppException(message: 'Đã xảy ra lỗi');
    }
  }
}