import 'package:flutter/material.dart';
import 'package:servesys/core/utils/index.dart';

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
      home: const TableScreen(),
    );
  }
}

// ─── Data models ─────────────────────────────────────────────────────────────
enum TableStatus { empty, occupied, reserved, paying }

class TableData {
  final String id;
  final int chairs;
  final TableStatus status;
  final String? note;
  final String? time;
  final String? total;

  const TableData({
    required this.id,
    required this.chairs,
    required this.status,
    this.note,
    this.time,
    this.total,
  });
}

// ─── Static data ─────────────────────────────────────────────────────────────
const List<TableData> tables = [
  TableData(id: 'B01', chairs: 4, status: TableStatus.occupied, total: '1.250k', time: null),
  TableData(id: 'A04', chairs: 2, status: TableStatus.empty),
  TableData(id: 'V02', chairs: 8, status: TableStatus.reserved, time: '19:30'),
  TableData(id: 'B05', chairs: 4, status: TableStatus.paying, note: 'Vừa thanh toán'),
  TableData(id: 'B07', chairs: 4, status: TableStatus.occupied, time: '45p', total: '820k'),
  TableData(id: 'A09', chairs: 2, status: TableStatus.empty),
];

// ─── Screen ───────────────────────────────────────────────────────────────────
class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  int _selectedFloor = 0;
  int _selectedNav = 0;

  final List<String> _floors = ['Tất cả', 'Tầng 1', 'Tầng 2', 'Ngoài trời'];

  int get _emptyCount => tables.where((t) => t.status == TableStatus.empty).length;
  int get _occupiedCount => tables.where((t) => t.status == TableStatus.occupied).length;

  Color _statusColor(TableStatus s) {
    switch (s) {
      case TableStatus.empty:
        return AppColors.success;
      case TableStatus.occupied:
        return AppColors.error;
      case TableStatus.reserved:
        return AppColors.info;
      case TableStatus.paying:
        return AppColors.warning;
    }
  }

  String _statusLabel(TableStatus s) {
    switch (s) {
      case TableStatus.empty:
        return 'BÀN TRỐNG';
      case TableStatus.occupied:
        return 'ĐANG CÓ KHÁCH';
      case TableStatus.reserved:
        return 'ĐÃ ĐẶT TRƯỚC';
      case TableStatus.paying:
        return 'ĐANG ĐÓN';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildGreeting(),
            _buildSummaryBadges(),
            _buildFloorTabs(),
            Expanded(child: _buildGrid()),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── Top bar ──────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo / brand
          Row(
            children: [
              Icon(Icons.restaurant_menu, color: AppColors.primary, size: 20),
              const SizedBox(width: 6),
              Text(
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
          // Avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: AppColors.background, size: 20),
          ),
        ],
      ),
    );
  }

  // ── Greeting ─────────────────────────────────────────────────────────────
  Widget _buildGreeting() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                const Text('👋', style: TextStyle(fontSize: 22)),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              'Hôm nay bạn có 12 bàn cần phục vụ.',
              style: TextStyle(color: AppColors.onSurfaceMuted, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  // ── Summary badges ────────────────────────────────────────────────────────
  Widget _buildSummaryBadges() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _summaryBadge('${_emptyCount.toString().padLeft(2, '0')} Bàn trống', AppColors.success),
          const SizedBox(width: 10),
          _summaryBadge('${_occupiedCount.toString().padLeft(2, '0')} Đang có khách', AppColors.error),
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
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  // ── Floor tabs ────────────────────────────────────────────────────────────
  Widget _buildFloorTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_floors.length, (i) {
            final selected = i == _selectedFloor;
            return GestureDetector(
              onTap: () => setState(() => _selectedFloor = i),
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
                  _floors[i],
                  style: TextStyle(
                    color: selected ? AppColors.onPrimary : AppColors.onSurfaceMuted,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ── Grid ─────────────────────────────────────────────────────────────────
  Widget _buildGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: tables.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (_, i) => _TableCard(table: tables[i]),
      ),
    );
  }

  // ── FAB ───────────────────────────────────────────────────────────────────
  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: AppColors.primary,
      child: const Icon(Icons.add, color: AppColors.onPrimary),
    );
  }

  // ── Bottom nav ────────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    final items = [
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final selected = i == _selectedNav;
              return GestureDetector(
                onTap: () => setState(() => _selectedNav = i),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      items[i].$1,
                      color: selected ? AppColors.primary : AppColors.onSurfaceMuted,
                      size: 22,
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
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─── Table Card ───────────────────────────────────────────────────────────────
class _TableCard extends StatelessWidget {
  final TableData table;

  const _TableCard({required this.table});

  Color get _statusColor {
    switch (table.status) {
      case TableStatus.empty:
        return AppColors.success;
      case TableStatus.occupied:
        return AppColors.error;
      case TableStatus.reserved:
        return AppColors.info;
      case TableStatus.paying:
        return AppColors.warning;
    }
  }

  String get _statusLabel {
    switch (table.status) {
      case TableStatus.empty:
        return 'BÀN TRỐNG';
      case TableStatus.occupied:
        return 'ĐANG CÓ KHÁCH';
      case TableStatus.reserved:
        return 'ĐÃ ĐẶT TRƯỚC';
      case TableStatus.paying:
        return 'ĐANG ĐÓN';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = table.status == TableStatus.empty;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _statusColor.withOpacity(0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: _statusColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: ID + status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                table.id,
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              _StatusBadge(label: _statusLabel, color: _statusColor),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${table.chairs} GHẾ',
            style: const TextStyle(color: AppColors.onSurfaceMuted, fontSize: 11),
          ),
          const Spacer(),

          // Empty table → Mở bàn button
          if (isEmpty)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.success,
                  side: const BorderSide(color: AppColors.success),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                child: const Text('Mở bàn'),
              ),
            ),

          // Occupied / reserved / paying → info rows
          if (!isEmpty) ...[
            if (table.total != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TỔNG CỘNG',
                    style: const TextStyle(color: AppColors.onSurfaceMuted, fontSize: 10),
                  ),
                  Text(
                    table.total!,
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            if (table.time != null)
              Row(
                children: [
                  Icon(
                    table.status == TableStatus.reserved
                        ? Icons.calendar_today
                        : Icons.access_time,
                    color: _statusColor,
                    size: 13,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    table.time!,
                    style: TextStyle(color: _statusColor, fontSize: 12),
                  ),
                ],
              ),
            if (table.note != null)
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 13),
                  const SizedBox(width: 4),
                  Text(
                    table.note!,
                    style: const TextStyle(color: AppColors.warning, fontSize: 11),
                  ),
                ],
              ),
          ],
        ],
      ),
    );
  }
}

// ─── Status badge ─────────────────────────────────────────────────────────────
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