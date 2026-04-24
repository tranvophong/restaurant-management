import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servesys/core/network/dio_client.dart';
import 'package:servesys/core/utils/index.dart';
import 'package:servesys/features/home/bloc/area_cubit.dart';
import 'package:servesys/features/home/bloc/table_cubit.dart';
import 'package:servesys/features/home/data/repositories/area_repository.dart';
import 'package:servesys/features/home/data/repositories/table_repository.dart';
import 'package:servesys/features/home/screens/home_screen.dart';
import 'package:servesys/features/menu/bloc/menu_category_cubit.dart';
import 'package:servesys/features/menu/bloc/menu_item_cubit.dart';
import 'package:servesys/features/menu/data/repositories/menu_repository.dart';

void main() {
  runApp(const ServeSysApp());
}

class ServeSysApp extends StatelessWidget {
  const ServeSysApp({super.key});

  @override
  Widget build(BuildContext context) {
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
          BlocProvider(
            create: (_) =>
                AreaCubit(areaRepository: AreaRepository(DioClient()))
                  ..loadAreas(),
          ),
          BlocProvider(
            create: (_) =>
                TableCubit(tableRepository: TableRepository(DioClient()))
                  ..loadTables(-1),
          ),
          BlocProvider(
            create: (_) =>
                MenuCategoryCubit(menuRepository: MenuRepository(DioClient()))
                  ..loadCategories(),
          ),
          BlocProvider(create: (_) => MenuItemCubit(menuRepository: MenuRepository(DioClient()))..loadMenuItems(-1),)
        ],
        child: const HomeScreen(),
      ),
    );
  }
}
