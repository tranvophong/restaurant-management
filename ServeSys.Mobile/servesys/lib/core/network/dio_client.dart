import 'package:dio/dio.dart';
import 'package:servesys/core/network/api_client.dart';
import 'package:servesys/core/network/api_endpoints.dart';
import 'package:servesys/core/services/auth_storage_service.dart';
import 'package:servesys/features/auth/data/models/auth_response.dart';

// ── Dio configuration with Auth Interceptor ────────────────────────────────
class DioClient implements ApiClient {
  late final Dio dio;
  late final _AuthInterceptor _interceptor;

  static DioClient? _instance;
  factory DioClient(AuthStorageService authStorage) {
    _instance ??= DioClient._internal(authStorage);
    return _instance!;
  }

  DioClient._internal(AuthStorageService authStorage) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    _interceptor = _AuthInterceptor(dio, authStorage);
    dio.interceptors.add(_interceptor);
  }

  /// Wire this AFTER [AuthBloc] is created to enable force-logout when both
  /// access token and refresh token are expired.
  ///
  /// Example (in main.dart):
  /// ```dart
  /// deps.dioClient.onSessionExpired = () => authBloc.add(AuthLogoutRequested());
  /// ```
  set onSessionExpired(void Function() callback) {
    _interceptor.onSessionExpired = callback;
  }

  @override
  Future get(String path) async {
    final response = await dio.get(path);
    return response.data;
  }

  @override
  Future post(String path, {Object? data}) async {
    final response = await dio.post(path, data: data);
    return response.data;
  }
}

// ── Auth interceptor ────────────────────────────────────────────────────────
class _AuthInterceptor extends Interceptor {
  final Dio dio;
  final AuthStorageService storage;

  /// Set from outside to trigger force-logout when refresh fails.
  void Function()? onSessionExpired;

  // Paths that do NOT require an Authorization header.
  static const _publicPaths = {
    ApiEndpoints.login,
    ApiEndpoints.refreshToken,
  };

  _AuthInterceptor(this.dio, this.storage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_publicPaths.contains(options.path)) {
      return handler.next(options);
    }

    final token = await storage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Attempt silent refresh on 401, but skip auth endpoints to avoid loops.
    if (err.response?.statusCode == 401 &&
        !_publicPaths.contains(err.requestOptions.path)) {
      try {
        final refreshed = await _refreshTokens();
        if (refreshed) {
          final token = await storage.getToken();
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $token';
          final response = await dio.fetch(opts);
          return handler.resolve(response);
        }
      } catch (e) {
        // Refresh failed — clear session then force-logout via callback
        await storage.clear();
        onSessionExpired?.call();
      }
    }
    handler.next(err);
  }

  // ── Private helpers ──────────────────────────────────────────────────────

  Future<bool> _refreshTokens() async {
    final storedRefreshToken = await storage.getRefreshToken();
    if (storedRefreshToken == null || storedRefreshToken.isEmpty) return false;

    // Separate Dio instance to avoid interceptor loop
    final refreshDio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    final response = await refreshDio.post(
      ApiEndpoints.refreshToken,
      data: {'refreshToken': storedRefreshToken},
    );

    final body = response.data as Map<String, dynamic>;
    if (body['success'] == true && body['data'] != null) {
      final data = body['data'] as Map<String, dynamic>;
      // Save refreshed tokens via the same abstract storage
      await storage.save(
        AuthResponseData(
          token: data['token'] as String,
          refreshToken: data['refreshToken'] as String,
          expiration: DateTime.parse(data['expiration'] as String),
          email: data['email'] as String,
          fullName: data['fullName'] as String,
        ),
      );
      return true;
    }
    return false;
  }
}
