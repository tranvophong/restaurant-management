import 'package:servesys/features/auth/data/models/auth_response.dart';

/// Abstract interface for persisting / retrieving auth session data.
abstract class AuthStorageService {
  /// Persists (or caches) all session data after a successful login/refresh.
  Future<void> save(AuthResponseData data);

  /// Clears all stored session data (logout).
  Future<void> clear();

  /// Returns the current access token, or null if none is stored.
  Future<String?> getToken();

  /// Returns the current refresh token, or null if none is stored.
  Future<String?> getRefreshToken();

  /// Returns the token expiration, or null if none is stored.
  Future<DateTime?> getExpiration();

  /// Returns the stored email, or null.
  Future<String?> getEmail();

  /// Returns the stored full name, or null.
  Future<String?> getFullName();

  /// Returns true when a token exists and its expiration is in the future.
  Future<bool> isSessionValid() async {
    final token = await getToken();
    if (token == null || token.isEmpty) return false;
    final exp = await getExpiration();
    if (exp == null) return false;
    // exp is stored/parsed as UTC; compare against UTC now to be explicit.
    return exp.toUtc().isAfter(DateTime.now().toUtc());
  }
}
