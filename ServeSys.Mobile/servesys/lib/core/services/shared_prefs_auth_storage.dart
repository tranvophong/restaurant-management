import 'package:shared_preferences/shared_preferences.dart';
import 'package:servesys/core/services/auth_storage_service.dart';
import 'package:servesys/features/auth/data/models/auth_response.dart';

/// SharedPreferences-backed implementation — token survives app restarts.
/// Swap for a flutter_secure_storage implementation whenever needed without
/// changing any BLoC, repository, or network code.
class SharedPrefsAuthStorage extends AuthStorageService {
  static const _keyToken = 'auth_token';
  static const _keyRefreshToken = 'auth_refresh_token';
  static const _keyExpiration = 'auth_expiration';
  static const _keyEmail = 'auth_email';
  static const _keyFullName = 'auth_full_name';

  SharedPreferences? _prefs;
  Future<SharedPreferences> get _p async =>
      _prefs ??= await SharedPreferences.getInstance();

  @override
  Future<void> save(AuthResponseData data) async {
    final p = await _p;
    await Future.wait([
      p.setString(_keyToken, data.token),
      p.setString(_keyRefreshToken, data.refreshToken),
      p.setString(_keyExpiration, data.expiration.toIso8601String()),
      p.setString(_keyEmail, data.email ?? ''),
      p.setString(_keyFullName, data.fullName),
    ]);
  }

  @override
  Future<void> clear() async {
    final p = await _p;
    await Future.wait([
      p.remove(_keyToken),
      p.remove(_keyRefreshToken),
      p.remove(_keyExpiration),
      p.remove(_keyEmail),
      p.remove(_keyFullName),
    ]);
  }

  @override
  Future<String?> getToken() async => (await _p).getString(_keyToken);

  @override
  Future<String?> getRefreshToken() async =>
      (await _p).getString(_keyRefreshToken);

  @override
  Future<DateTime?> getExpiration() async {
    final raw = (await _p).getString(_keyExpiration);
    return raw != null ? DateTime.tryParse(raw)?.toUtc() : null;
  }

  @override
  Future<String?> getEmail() async => (await _p).getString(_keyEmail);

  @override
  Future<String?> getFullName() async => (await _p).getString(_keyFullName);
}
