abstract class OrderSubmissionState {}

class OrderSubmissionInitial extends OrderSubmissionState {}

class OrderSubmissionLoading extends OrderSubmissionState {}

class OrderSubmissionSuccess extends OrderSubmissionState {
  int tableId;
  OrderSubmissionSuccess(this.tableId);
}

class OrderSubmissionError extends OrderSubmissionState {
  final String message;
  OrderSubmissionError(this.message);
}