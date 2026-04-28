import 'dart:convert';

import 'package:servesys/core/base/base_repository.dart';
import 'package:servesys/core/network/api_endpoints.dart';
import 'package:servesys/core/services/auth_storage_service.dart';
import 'package:servesys/features/auth/data/models/auth_response.dart';

class AuthRepository extends BaseRepository {
  final AuthStorageService storage;

  AuthRepository(super.apiClient, {required this.storage});

  Future<AuthResponseData> login(String username, String password) async {
    final data = await handle<AuthResponseData>(
      (api) => api.post(
        ApiEndpoints.login,
        data: {'username': username, 'password': password},
      ),
      (json) => AuthResponseData.fromJson(json as Map<String, dynamic>),
    );

    await storage.save(data);
    return data;
  }

  /// Clears tokens
  Future<void> logout() async {
    await handle((apiClient) => apiClient.get(ApiEndpoints.logout), (json) => null);
    storage.clear();
  }

  /// Checks whether the current session is still valid.
  Future<bool> isSessionValid() => storage.isSessionValid();
}
