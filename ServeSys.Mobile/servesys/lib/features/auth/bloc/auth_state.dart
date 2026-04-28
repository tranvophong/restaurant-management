import 'package:servesys/core/network/api_response.dart';
import 'package:servesys/features/auth/data/models/auth_response.dart';

sealed class AuthState {}

/// Initial state before the session check is performed.
final class AuthInitial extends AuthState {}

/// A login or session-check operation is in progress.
final class AuthLoading extends AuthState {}

/// A valid session exists (login succeeded or stored token is valid).
final class AuthAuthenticated extends AuthState {
  final AuthResponseData data;
  AuthAuthenticated(this.data);
}

/// No valid session — user must log in.
final class AuthUnauthenticated extends AuthState {}

/// Login failed.
/// - [message] → first/summary error, safe to show in a simple SnackBar.
/// - [errors] → full structured list, use when UI needs to render each error separately.
final class AuthFailure extends AuthState {
  final String message;
  final List<ApiError> errors;
  AuthFailure(this.message, {this.errors = const []});
}

