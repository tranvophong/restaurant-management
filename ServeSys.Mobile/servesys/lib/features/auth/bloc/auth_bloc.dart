import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servesys/core/di/app_dependencies.dart';
import 'package:servesys/core/error/app_exception.dart';
import 'package:servesys/features/auth/bloc/auth_event.dart';
import 'package:servesys/features/auth/bloc/auth_state.dart';
import 'package:servesys/features/auth/data/models/auth_response.dart';
import 'package:servesys/features/auth/data/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthSessionChecked>(_onSessionChecked);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  // ── Handlers ───────────────────────────────────────────────────────────────

  Future<void> _onSessionChecked(
    AuthSessionChecked event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final valid = await authRepository.isSessionValid();
      if (valid) {
        // Rebuild AuthResponseData from storage so UI can read user info
        final storage = AppDependencies.instance.authStorage;
        final data = await _readStoredData(storage);
        emit(data != null ? AuthAuthenticated(data) : AuthUnauthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (_) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (event.username.trim().isEmpty || event.password.isEmpty) {
      emit(AuthFailure('Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu.'));
      return;
    }

    emit(AuthLoading());
    try {
      final data = await authRepository.login(
        event.username.trim(),
        event.password,
      );
      emit(AuthAuthenticated(data));
    } catch (e) {
      if (e is AppException) {
        final msg = e.message.trim().isEmpty ? 'Đăng nhập thất bại' : e.message;
        emit(AuthFailure(msg, errors: e.errors));
      } else {
        final msg = e.toString().replaceFirst('Exception: ', '').trim();
        emit(AuthFailure(msg.isEmpty ? 'Đăng nhập thất bại' : msg));
      }
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await authRepository.logout();
    emit(AuthUnauthenticated());
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Future<AuthResponseData?> _readStoredData(dynamic storage) async {
    try {
      final token = await storage.getToken() as String?;
      final refreshToken = await storage.getRefreshToken() as String?;
      final expiration = await storage.getExpiration() as DateTime?;
      final email = await storage.getEmail() as String?;
      final fullName = await storage.getFullName() as String?;

      if (token == null ||
          refreshToken == null ||
          expiration == null ||
          email == null ||
          fullName == null) {
        return null;
      }
      return AuthResponseData(
        token: token,
        refreshToken: refreshToken,
        expiration: expiration,
        email: email,
        fullName: fullName,
      );
    } catch (_) {
      return null;
    }
  }
}
