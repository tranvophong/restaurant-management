sealed class AuthEvent {}

/// Dispatched when the app starts to check whether a valid session exists.
final class AuthSessionChecked extends AuthEvent {}

/// Dispatched when the user submits the login form.
final class AuthLoginRequested extends AuthEvent {
  final String username;
  final String password;
  AuthLoginRequested({required this.username, required this.password});
}

/// Dispatched when the user logs out.
final class AuthLogoutRequested extends AuthEvent {}
