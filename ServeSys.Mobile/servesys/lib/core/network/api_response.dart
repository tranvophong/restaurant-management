class ApiError {
  final String code;
  final String description;

  const ApiError({required this.code, required this.description});

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: (json['code'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
    );
  }
}

class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final List<ApiError> errors;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.errors = const []
  });

  /// Returns the most user-friendly error string available:
  /// 1. First error description from [errors] (most specific)
  /// 2. [message] from the top-level response
  /// 3. Fallback empty string
  List<ApiError> get allErrorMessages {
    if (errors.isNotEmpty) {
      return errors;
    }
    if (message != null && message!.isNotEmpty) {
      return [ApiError(code: '', description: message!)];
    }
    return [];
  }

  ApiError get firstErrorMessage {
    // Priority 1: errors array (most specific, e.g. field-level validation)
    if (errors.isNotEmpty && errors.first.description.isNotEmpty) {
      return errors.first;
    }
    // Priority 2: top-level message (server returns only message without errors)
    if (message != null && message!.isNotEmpty) {
      return ApiError(code: '', description: message!);
    }
    return const ApiError(code: '', description: '');
  }

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    final rawErrors = json['errors'];
    final errors = (rawErrors is List)
        ? rawErrors
            .whereType<Map<String, dynamic>>()
            .map(ApiError.fromJson)
            .toList()
        : <ApiError>[];

    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
      errors: errors,
    );
  }
}
