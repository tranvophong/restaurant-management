import 'package:servesys/core/network/api_client.dart';
import 'package:servesys/core/network/dio_client.dart';
import 'package:servesys/core/services/auth_storage_service.dart';
import 'package:servesys/core/services/shared_prefs_auth_storage.dart';

/// Composition root — holds every application-wide singleton.
///
/// Initialised once in [main] via [AppDependencies.init].
/// Access anywhere via [AppDependencies.instance].
///
/// To swap implementations (e.g. use InMemoryAuthStorage instead of
/// SharedPrefsAuthStorage), change only this file — nothing else changes.
class AppDependencies {
  AppDependencies._();

  static AppDependencies? _instance;

  /// The single, initialised instance.
  static AppDependencies get instance {
    assert(_instance != null,
        'AppDependencies.init() must be called before accessing instance.');
    return _instance!;
  }

  // ── Singletons ──────────────────────────────────────────────────────────

  late final AuthStorageService authStorage;
  late final ApiClient dioClient;

  // ── Initialisation ──────────────────────────────────────────────────────

  /// Call once at app startup, before [runApp].
  static Future<void> init() async {
    final deps = AppDependencies._();

    deps.authStorage = SharedPrefsAuthStorage();
    // deps.authStorage = InMemoryAuthStorage(); // flip for no-persistence

    deps.dioClient = DioClient(deps.authStorage);

    _instance = deps;
  }
}
