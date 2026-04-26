abstract class OrderSubmissionState {}

class OrderSubmissionInitial extends OrderSubmissionState {}

class OrderSubmissionLoading extends OrderSubmissionState {}

class OrderSubmissionSuccess extends OrderSubmissionState {}

class OrderSubmissionError extends OrderSubmissionState {
  final String message;
  OrderSubmissionError(this.message);
}