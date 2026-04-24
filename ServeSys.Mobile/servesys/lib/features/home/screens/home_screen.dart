import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servesys/core/utils/index.dart';
import 'package:servesys/features/home/bloc/area_cubit.dart';
import 'package:servesys/features/home/bloc/area_state.dart';
import 'package:servesys/features/home/bloc/table_cubit.dart';
import 'package:servesys/features/home/bloc/table_state.dart';
import 'package:servesys/features/home/domain/entities/table.dart' as entities;
import 'package:servesys/features/home/domain/enums/table_status.dart';
import 'package:servesys/features/home/extensions/table_status_extension.dart';
import 'package:servesys/features/menu/screens/menu_screen.dart';
import 'package:shimmer/shimmer.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNav = 0;


  static const List<Widget> _screens = [
    _TablesTab(),
    MenuScreen(),    
    _OrdersTab(),  
    _ProfileTab(),  
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedNav,
          children: _screens,
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── Bottom Nav ────────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    const items = [
      (Icons.table_restaurant, 'Tables'),
      (Icons.restaurant_menu, 'Menu'),
      (Icons.receipt_long, 'Orders'),
      (Icons.person_outline, 'Profile'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final selected = i == _selectedNav;
              return GestureDetector(
                onTap: () => setState(() => _selectedNav = i),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          items[i].$1,
                          key: ValueKey(selected),
                          color: selected ? AppColors.primary : AppColors.onSurfaceMuted,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        items[i].$2,
                        style: TextStyle(
                          color: selected ? AppColors.primary : AppColors.onSurfaceMuted,
                          fontSize: 11,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Indicator dot
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: selected ? 18 : 0,
                        height: 3,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─── Tab 0: Tables ────────────────────────────────────────────────────────────
class _TablesTab extends StatelessWidget {
  const _TablesTab();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AreaCubit, AreaState>(
      listener: (context, state) {
        if (state is AreaSuccess) {
          context.read<TableCubit>().loadTables(state.selectedIndex);
        }
      },
      child: Column(
        children: [
          _buildTopBar(),
          _buildGreeting(),
          _buildSummaryBadges(context),
          _buildFloorTabs(context),
          Expanded(child: _buildGrid()),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.restaurant_menu, color: AppColors.primary, size: 20),
              const SizedBox(width: 6),
              const Text(
                'ServeSys',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          Container(
            width: 36, height: 36,
            decoration: const BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: AppColors.background, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Xin chào, Alex ',
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text('👋', style: TextStyle(fontSize: 22)),
              ],
            ),
            SizedBox(height: 2),
            Text(
              'Hôm nay bạn có 12 bàn cần phục vụ.',
              style: TextStyle(color: AppColors.onSurfaceMuted, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryBadges(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _summaryBadge('0 Bàn trống', AppColors.success),
          const SizedBox(width: 10),
          _summaryBadge('0 Đang có khách', AppColors.error),
          const SizedBox(width: 10),
          _summaryBadge('02', AppColors.info),
        ],
      ),
    );
  }

  Widget _summaryBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFloorTabs(BuildContext context) {
    return BlocBuilder<AreaCubit, AreaState>(
      builder: (context, state) {
        if (state is AreaLoading) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Shimmer.fromColors(
              baseColor: const Color(0xFFE0E0E0),
              highlightColor: const Color(0xFFF5F5F5),
              child: Row(
                children: List.generate(
                  4,
                  (_) => Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 80, height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        if (state is AreaError) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(state.message),
          );
        }

        if (state is AreaSuccess && state.areas.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Không có khu vực nào'),
          );
        }

        final successState = state as AreaSuccess;
        final areas = successState.areas;
        final selectedIndex = successState.selectedIndex;

        final allTabs = [
          _floorChip(
            label: 'Tất cả',
            selected: selectedIndex == -1,
            onTap: () => context.read<AreaCubit>().selectArea(-1),
          ),
          ...areas.map((area) => _floorChip(
            label: area.name,
            selected: area.id == selectedIndex,
            onTap: () => context.read<AreaCubit>().selectArea(area.id),
          )),
        ];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: allTabs),
          ),
        );
      },
    );
  }

  Widget _floorChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.onPrimary : AppColors.onSurfaceMuted,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return BlocBuilder<TableCubit, TableState>(
      builder: (context, state) {
        if (state is TableLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is TableError) {
          return Center(child: Text(state.message));
        }
        if (state is TableSuccess) {
          final tables = state.tables;
          if (tables.isEmpty) {
            return const Center(child: Text('Không có bàn'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tables.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (_, i) => _TableCard(table: tables[i]),
          );
        }
        return const SizedBox();
      },
    );
  }
}

// ─── Tab 2: Orders ────────────────────────────────────────────────────────────
class _OrdersTab extends StatelessWidget {
  const _OrdersTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long, color: AppColors.primary, size: 48),
          SizedBox(height: 12),
          Text(
            'Orders',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Màn hình quản lý đơn hàng',
            style: TextStyle(color: AppColors.onSurfaceMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ─── Tab 3: Profile ───────────────────────────────────────────────────────────
class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_outline, color: AppColors.primary, size: 48),
          SizedBox(height: 12),
          Text(
            'Profile',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Thông tin tài khoản',
            style: TextStyle(color: AppColors.onSurfaceMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ─── Table Card ───────────────────────────────────────────────────────────────
class _TableCard extends StatelessWidget {
  final entities.Table table;

  const _TableCard({required this.table});

  @override
  Widget build(BuildContext context) {
    final isEmpty = table.status == TableStatus.available;
    final statusColor = table.status.color;
    final statusLabel = table.status.label;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.35), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                table.id.toString(),
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              _StatusBadge(label: statusLabel, color: statusColor),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${table.chairs} GHẾ',
            style: const TextStyle(
              color: AppColors.onSurfaceMuted,
              fontSize: 11,
            ),
          ),
          const Spacer(),
          if (isEmpty)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.success,
                  side: const BorderSide(color: AppColors.success),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Mở bàn'),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Status Badge ─────────────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}