import 'package:servesys/core/network/api_response.dart';

class AppException implements Exception {
  final String message;
  final List<ApiError> errors;

  const AppException({
    required this.message,
    this.errors = const [],
  });

  /// Convenience: true when the server returned more than one error.
  bool get hasMultipleErrors => errors.length > 1;

  @override
  String toString() => message;
}
