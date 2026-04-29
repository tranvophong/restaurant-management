import 'package:flutter/material.dart';
import 'package:servesys/core/utils/appcolor_util.dart';

enum OrderStatus { preparing, served, pending }

class OrderItem {
  final String name;
  final OrderStatus status;
  final double price;
  final String note;
  final int quantity;
  final String orderedBy;

  const OrderItem({
    required this.name,
    required this.status,
    required this.price,
    required this.note,
    required this.quantity,
    required this.orderedBy,
  });
}

// ─── Main Screen ────────────────────────────────────────────────────────────

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  static const List<OrderItem> _items = [
    OrderItem(
      name: 'Wagyu Ribeye',
      status: OrderStatus.preparing,
      price: 85.00,
      note: 'Medium Rare. No salt on frites.',
      quantity: 1,
      orderedBy: 'Alex M.',
    ),
    OrderItem(
      name: 'Heirloom Tomato Salad',
      status: OrderStatus.served,
      price: 18.00,
      note: 'Dressing on side.',
      quantity: 1,
      orderedBy: 'Alex M.',
    ),
    OrderItem(
      name: 'Dark Chocolate Tart',
      status: OrderStatus.pending,
      price: 24.00,
      note: 'Hold until mains cleared.',
      quantity: 2,
      orderedBy: 'Sarah K.',
    ),
  ];

  static const double _subtotal = 127.00;
  static const double _taxRate = 0.085;
  static const double _tax = _subtotal * _taxRate;
  static const double _total = _subtotal + _tax;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const _AppBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const _OrderHeader(),
                  const SizedBox(height: 20),
                  ..._items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _OrderItemCard(item: item),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const _PriceSummary(
                    subtotal: _subtotal,
                    tax: _tax,
                    total: _total,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          const _BottomBar(),
        ],
      ),
    );
  }
}

// ─── App Bar ────────────────────────────────────────────────────────────────

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
            onTap: () {
              Navigator.maybePop(context);
            },
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

// ─── Order Header ────────────────────────────────────────────────────────────

class _OrderHeader extends StatelessWidget {
  const _OrderHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TABLE 12',
          style: TextStyle(
            color: AppColors.onSurfaceMuted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Text(
              'Order #4920',
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                '3 Items Active',
                style: TextStyle(
                  color: AppColors.onSurfaceMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Opened at 19:42 by Server: Alex M.',
          style: TextStyle(color: AppColors.onSurfaceMuted, fontSize: 12),
        ),
      ],
    );
  }
}

// ─── Order Item Card ─────────────────────────────────────────────────────────

class _OrderItemCard extends StatelessWidget {
  final OrderItem item;
  const _OrderItemCard({required this.item});

  Color get _statusColor {
    switch (item.status) {
      case OrderStatus.preparing:
        return AppColors.warning;
      case OrderStatus.served:
        return AppColors.success;
      case OrderStatus.pending:
        return AppColors.onSurfaceMuted;
    }
  }

  String get _statusLabel {
    switch (item.status) {
      case OrderStatus.preparing:
        return 'PREPARING';
      case OrderStatus.served:
        return 'SERVED';
      case OrderStatus.pending:
        return 'PENDING';
    }
  }

  Color get _cardBorderColor {
    if (item.status == OrderStatus.preparing) {
      return AppColors.warning.withOpacity(0.35);
    }
    return AppColors.border;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorderColor, width: 1),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Name + Status + Price row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    _StatusBadge(label: _statusLabel, color: _statusColor),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '\$${item.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // ── Note + circle icon
          Row(
            children: [
              Expanded(
                child: Text(
                  item.note,
                  style: const TextStyle(
                    color: AppColors.onSurfaceMuted,
                    fontSize: 12,
                  ),
                ),
              ),
              const Icon(
                Icons.radio_button_unchecked,
                color: AppColors.border,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 10),
          // ── Quantity + Ordered by
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                'Ordered by: ${item.orderedBy}',
                style: const TextStyle(
                  color: AppColors.onSurfaceMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Status Badge ────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ─── Price Summary ───────────────────────────────────────────────────────────

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
        _PriceRow(label: 'Subtotal', value: '\$${subtotal.toStringAsFixed(2)}'),
        const SizedBox(height: 8),
        _PriceRow(label: 'Tax (8.5%)', value: '\$${tax.toStringAsFixed(2)}'),
        const SizedBox(height: 16),
        const Divider(color: AppColors.border),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total',
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              '\$${total.toStringAsFixed(2)}',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  const _PriceRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.onSurfaceMuted, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─── Bottom Bar ──────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  const _BottomBar();

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
              onTap: () {},
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
                  Icon(Icons.payment_rounded, color: AppColors.onPrimary, size: 18),
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