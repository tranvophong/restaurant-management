import 'package:servesys/core/services/auth_storage_service.dart';
import 'package:servesys/features/auth/data/models/auth_response.dart';

class InMemoryAuthStorage extends AuthStorageService {
  AuthResponseData? _data;

  @override
  Future<void> save(AuthResponseData data) async => _data = data;

  @override
  Future<void> clear() async => _data = null;

  @override
  Future<String?> getToken() async => _data?.token;

  @override
  Future<String?> getRefreshToken() async => _data?.refreshToken;

  @override
  Future<DateTime?> getExpiration() async => _data?.expiration;

  @override
  Future<String?> getEmail() async => _data?.email;

  @override
  Future<String?> getFullName() async => _data?.fullName;
}
