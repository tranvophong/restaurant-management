abstract class OrderSubmissionState {}

class OrderSubmissionInitial extends OrderSubmissionState {}

class OrderSubmissionLoading extends OrderSubmissionState {}

class OrderSubmissionSuccess extends OrderSubmissionState {
  int tableId;
  String orderCode;
  OrderSubmissionSuccess(this.tableId, this.orderCode);
}

class OrderSubmissionError extends OrderSubmissionState {
  final String message;
  OrderSubmissionError(this.message);
}