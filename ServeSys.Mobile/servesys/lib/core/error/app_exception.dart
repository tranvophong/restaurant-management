class AppException {
  String message;
  AppException({required this.message});

  @override
  String toString() {
    return this.message;
  }
}