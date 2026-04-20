import 'package:servesys/core/error/app_exception.dart';

class NetworkException extends AppException {
  NetworkException() : super(message: 'Lỗi kết nối mạng');
}