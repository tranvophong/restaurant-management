import 'package:servesys/core/error/app_exception.dart';

class ServerException extends AppException {
  ServerException() : super(message: 'Lỗi server');
}