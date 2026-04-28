import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servesys/core/di/app_dependencies.dart';
import 'package:servesys/core/utils/index.dart';
import 'package:servesys/features/auth/bloc/auth_bloc.dart';
import 'package:servesys/features/auth/bloc/auth_event.dart';
import 'package:servesys/features/auth/bloc/auth_state.dart';
import 'package:servesys/features/auth/data/repositories/auth_repository.dart';
import 'package:servesys/core/network/dio_client.dart';
import 'package:servesys/features/auth/screens/login_screen.dart';
import 'package:servesys/features/home/bloc/area_cubit.dart';
import 'package:servesys/features/home/bloc/table_cubit.dart';
import 'package:servesys/features/home/data/repositories/area_repository.dart';
import 'package:servesys/features/home/data/repositories/table_repository.dart';
import 'package:servesys/features/home/screens/home_screen.dart';
import 'package:servesys/features/menu/bloc/menu_category_cubit.dart';
import 'package:servesys/features/menu/bloc/menu_item_cubit.dart';
import 'package:servesys/features/menu/data/repositories/menu_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDependencies.init();
  await AppDependencies.instance.authStorage.clear();

  final deps = AppDependencies.instance;

  // Create AuthBloc early so we can wire the force-logout callback on DioClient.
  // This avoids a circular dependency: DioClient is created before AuthBloc in
  // AppDependencies.init(), so the callback must be set separately here.
  final authBloc = AuthBloc(
    AuthRepository(deps.dioClient, storage: deps.authStorage),
  )..add(AuthSessionChecked());

  // Wire the callback: when both access & refresh tokens are expired the
  // interceptor will call this, which logs the user out immediately.
  (deps.dioClient as DioClient).onSessionExpired =
      () => authBloc.add(AuthLogoutRequested());
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: Colors.transparent,
  //     statusBarIconBrightness: Brightness.light,
  //   ),
  // );
  runApp(ServeSysApp(authBloc: authBloc));
}

class ServeSysApp extends StatelessWidget {
  final AuthBloc authBloc;
  const ServeSysApp({super.key, required this.authBloc});

  @override
  Widget build(BuildContext context) {
    // Resolve singletons from the composition root
    final deps = AppDependencies.instance;

    return MaterialApp(
      title: 'ServeSys',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'sans-serif',
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          // Auth — pre-created in main() so the force-logout callback can be wired.
          BlocProvider<AuthBloc>.value(value: authBloc),
          // Home
          BlocProvider(
            create: (_) =>
                AreaCubit(areaRepository: AreaRepository(deps.dioClient))
                  ..loadAreas(),
          ),
          BlocProvider(
            create: (_) =>
                TableCubit(tableRepository: TableRepository(deps.dioClient))
                  ..loadTables(-1),
          ),
          // Menu
          BlocProvider(
            create: (_) =>
                MenuCategoryCubit(
                    menuRepository: MenuRepository(deps.dioClient))
                  ..loadCategories(),
          ),
          BlocProvider(
            create: (_) =>
                MenuItemCubit(menuRepository: MenuRepository(deps.dioClient))
                  ..loadMenuItems(-1),
          ),
        ],
        child: const _AuthGate(),
      ),
    );
  }
}

/// Listens to [AuthBloc] and shows the correct screen based on session state.
///
/// Uses [buildWhen] to keep [LoginScreen] alive during [AuthLoading] and
/// [AuthFailure] so that the [BlocListener] inside [LoginScreen] is not
/// remounted after state has already settled — which would miss the change.
/// Error SnackBars are handled here via [BlocConsumer.listener] instead.
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      // Only rebuild the screen layout for states that actually change which
      // screen is shown. AuthLoading & AuthFailure during login should NOT
      // unmount LoginScreen — the button's own BlocBuilder handles the spinner.
      buildWhen: (_, current) =>
          current is AuthInitial ||
          current is AuthAuthenticated ||
          current is AuthUnauthenticated,
      builder: (context, state) {
        if (state is AuthAuthenticated) return const HomeScreen();
        if (state is AuthInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // AuthUnauthenticated (and retained for AuthLoading / AuthFailure)
        return const LoginScreen();
      },
      // Show SnackBar when login fails — LoginScreen is already mounted at
      // this point because buildWhen excluded AuthFailure from rebuilding.
      listenWhen: (_, current) => current is AuthFailure,
      listener: (context, state) {
        if (state is! AuthFailure) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline_rounded,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      state.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFFE53935),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 4),
            ),
          );
      },
    );
  }
}
