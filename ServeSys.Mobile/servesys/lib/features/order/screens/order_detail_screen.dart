import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servesys/core/di/app_dependencies.dart';
import 'package:servesys/core/utils/appcolor_util.dart';
import 'package:servesys/features/order/bloc/order_detail_cubit.dart';
import 'package:servesys/features/order/bloc/order_detail_state.dart';
import 'package:servesys/features/order/domain/entities/order_detail.dart';
import 'package:servesys/features/order/domain/enums/order_item_status.dart';
import 'package:servesys/features/order/data/repositories/order_repository.dart';
import 'package:servesys/features/order/screens/create_order_screen.dart';
import 'package:servesys/features/menu/bloc/menu_category_cubit.dart';
import 'package:servesys/features/menu/bloc/menu_item_cubit.dart';
import 'package:servesys/features/menu/data/repositories/menu_repository.dart';
import 'package:servesys/features/order/bloc/order_draft_cubit.dart';
import 'package:servesys/features/order/bloc/order_submission_cubit.dart';

class OrderDetailsScreen extends StatelessWidget {
  final int tableId;
  final String tableName;
  const OrderDetailsScreen({
    super.key,
    required this.tableId,
    required this.tableName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrderDetailCubit(OrderRepository(AppDependencies.instance.dioClient))
            ..getOrderDetail(tableId),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<OrderDetailCubit, OrderDetailState>(
          builder: (context, state) {
            if (state is OrderDetailLoading || state is OrderDetailInitial) {
              return const Column(
                children: [
                  _AppBar(),
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is OrderDetailError) {
              return Column(
                children: [
                  const _AppBar(),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            style: const TextStyle(color: AppColors.error),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            onPressed: () => context
                                .read<OrderDetailCubit>()
                                .getOrderDetail(tableId),
                            child: const Text(
                              'Retry',
                              style: TextStyle(color: AppColors.onPrimary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is OrderDetailSuccess) {
              final order = state.order;
              final sortedItems = order.sortedItems;
              final activeCount = order.items
                  .where((i) => i.status != OrderItemStatus.served)
                  .length;

              return Column(
                children: [
                  _AppBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          _OrderHeader(order: order, activeCount: activeCount),
                          const SizedBox(height: 20),
                          ...sortedItems.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _OrderItemCard(item: item),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _PriceSummary(
                            subtotal: order.subtotal,
                            tax: order.tax,
                            total: order.totalWithTax,
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  _BottomBar(tableId: tableId, tableName: tableName),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

// ─── App Bar ─────────────────────────────────────────────────────────────────

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.primary,
                size: 16,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Order Details',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(width: 36),
        ],
      ),
    );
  }
}

// ─── Order Header ─────────────────────────────────────────────────────────────

class _OrderHeader extends StatelessWidget {
  final OrderDetail order;
  final int activeCount;

  const _OrderHeader({required this.order, required this.activeCount});

  String _formatDateTime(DateTime dt) {
    final local = dt.toLocal();
    final h = local.hour.toString().padLeft(2, '0');
    final m = local.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TABLE ${order.tableId}',
          style: const TextStyle(
            color: AppColors.onSurfaceMuted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              'Order #${order.orderCode}',
              style: const TextStyle(
                color: AppColors.onSurface,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 10),
            // Active badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                '$activeCount Items Active',
                style: const TextStyle(
                  color: AppColors.onSurfaceMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Status Chip ──────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  final OrderItemStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      OrderItemStatus.preparing => (
        'PREPARING',
        const Color(0xFFFF8C42).withOpacity(0.15),
        const Color(0xFFFF8C42),
      ),
      OrderItemStatus.served => (
        'SERVED',
        const Color(0xFF4CAF82).withOpacity(0.15),
        const Color(0xFF4CAF82),
      ),
      OrderItemStatus.pending => (
        'PENDING',
        AppColors.surfaceElevated,
        AppColors.onSurfaceMuted,
      ),
      _ => (
        status.name.toUpperCase(),
        AppColors.surfaceElevated,
        AppColors.onSurfaceMuted,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ─── Order Item Card ──────────────────────────────────────────────────────────

class _OrderItemCard extends StatelessWidget {
  final OrderItemDetail item;
  const _OrderItemCard({required this.item});

  bool get _isServed => item.status == OrderItemStatus.served;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _isServed ? 0.55 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Name + Status + Price
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            color: _isServed
                                ? AppColors.onSurfaceMuted
                                : AppColors.onSurface,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            decoration: _isServed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            decorationColor: AppColors.onSurfaceMuted,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatusChip(status: item.status),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                  style: TextStyle(
                    color: _isServed
                        ? AppColors.onSurfaceMuted
                        : AppColors.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            // ── Notes/description
            if (item.notes != null && item.notes!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.notes!,
                      style: const TextStyle(
                        color: AppColors.onSurfaceMuted,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  // circle icon shown only for non-served items
                  if (!_isServed)
                    const Icon(
                      Icons.radio_button_unchecked,
                      color: AppColors.border,
                      size: 20,
                    )
                  else
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF4CAF82),
                      size: 20,
                    ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: _isServed
                    ? const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF4CAF82),
                        size: 20,
                      )
                    : const Icon(
                        Icons.radio_button_unchecked,
                        color: AppColors.border,
                        size: 20,
                      ),
              ),
            ],
            const SizedBox(height: 10),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 10),
            // ── Quantity + Ordered by
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    'x${item.quantity}',
                    style: const TextStyle(
                      color: AppColors.onSurfaceMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Ordered by: ${item.staffName}',
                  style: const TextStyle(
                    color: AppColors.onSurfaceMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Price Summary ────────────────────────────────────────────────────────────

class _PriceSummary extends StatelessWidget {
  final double subtotal;
  final double tax;
  final double total;

  const _PriceSummary({
    required this.subtotal,
    required this.tax,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(color: AppColors.border),
        const SizedBox(height: 12),
        _SummaryRow(
          label: 'Subtotal',
          value: '\$${subtotal.toStringAsFixed(2)}',
          labelStyle: const TextStyle(
            color: AppColors.onSurfaceMuted,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          valueStyle: const TextStyle(
            color: AppColors.onSurfaceMuted,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        _SummaryRow(
          label: 'Tax (8.5%)',
          value: '\$${tax.toStringAsFixed(2)}',
          labelStyle: const TextStyle(
            color: AppColors.onSurfaceMuted,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          valueStyle: const TextStyle(
            color: AppColors.onSurfaceMuted,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        _SummaryRow(
          label: 'Total',
          value: '\$${total.toStringAsFixed(2)}',
          labelStyle: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
          valueStyle: const TextStyle(
            color: AppColors.primary,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle labelStyle;
  final TextStyle valueStyle;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.labelStyle,
    required this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text(value, style: valueStyle),
      ],
    );
  }
}

// ─── Bottom Bar ───────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final int tableId;
  final String tableName;
  const _BottomBar({required this.tableId, required this.tableName});

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPad + 12),
      child: Row(
        children: [
          // ORDER MORE
          Expanded(
            child: GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (_) => MenuCategoryCubit(
                            menuRepository: MenuRepository(AppDependencies.instance.dioClient),
                          )..loadCategories(),
                        ),
                        BlocProvider(
                          create: (_) => MenuItemCubit(
                            menuRepository: MenuRepository(AppDependencies.instance.dioClient),
                          )..loadMenuItems(-1),
                        ),
                        BlocProvider(create: (_) => OrderDraftCubit(tableId: tableId, tableName: tableName)),
                        BlocProvider(
                          create: (_) => OrderSubmissionCubit(OrderRepository(AppDependencies.instance.dioClient)),
                        ),
                      ],
                      child: const CreateOrderScreen(),
                    ),
                  ),
                );
                
                if (context.mounted) {
                  context.read<OrderDetailCubit>().getOrderDetail(tableId);
                }
              },
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_shopping_cart_rounded,
                      color: AppColors.onSurfaceMuted,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'ORDER MORE',
                      style: TextStyle(
                        color: AppColors.onSurfaceMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // PAY
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 52,
              width: 110,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.payment_rounded,
                    color: AppColors.onPrimary,
                    size: 18,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'PAY',
                    style: TextStyle(
                      color: AppColors.onPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
