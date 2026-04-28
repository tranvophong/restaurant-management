import 'package:servesys/core/error/app_exception.dart';

class ClientException extends AppException {
  ClientException() : super(message: 'Có lỗi xảy ra vui lòng thử lại');
}