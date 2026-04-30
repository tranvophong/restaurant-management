import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servesys/core/utils/appcolor_util.dart';
import 'package:servesys/features/menu/bloc/menu_category_cubit.dart';
import 'package:servesys/features/menu/bloc/menu_category_state.dart';
import 'package:servesys/features/menu/bloc/menu_item_cubit.dart';
import 'package:servesys/features/menu/bloc/menu_item_state.dart';
import 'package:servesys/features/menu/domain/entities/menu_item.dart';
import 'package:servesys/features/order/bloc/order_draft_cubit.dart';
import 'package:servesys/features/order/bloc/order_submission_cubit.dart';
import 'package:servesys/features/order/data/models/order_item_entry.dart';
import 'package:servesys/features/order/widgets/order_confirm_sheet.dart';
import 'package:shimmer/shimmer.dart';

// ─── Main Screen ──────────────────────────────────────────────────────────────
class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  String _formatPrice(int price) {
    final formatted = price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return '${formatted}đ';
  }

  void _showConfirmOrder(BuildContext context) {
    final cubit = context.read<OrderDraftCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: cubit),
          BlocProvider.value(value: context.read<OrderSubmissionCubit>()),
        ],
        child: OrderConfirmSheet(
          tableId: cubit.tableId,
          tableName: cubit.tableName,
          note: _noteController.text,
          formatPrice: _formatPrice,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildNoteField(),
            _buildSearchField(),
            _buildCategoryChips(),
            Expanded(child: _buildMenuList()),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // ─── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.close, color: AppColors.error, size: 18),
            ),
          ),
          Text(
            'Tạo đơn – ${context.read<OrderDraftCubit>().tableName}',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Note Field ─────────────────────────────────────────────────────────────
  Widget _buildNoteField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: TextField(
        controller: _noteController,
        style: const TextStyle(color: AppColors.onSurface, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Thêm lưu ý cho bếp (ví dụ: Không hành, ít cay...)',
          hintStyle: const TextStyle(
            color: AppColors.onSurfaceMuted,
            fontSize: 13,
          ),
          filled: true,
          fillColor: AppColors.surfaceElevated,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  // ─── Search Field ───────────────────────────────────────────────────────────
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: AppColors.onSurface, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Tìm tên món',
          hintStyle: const TextStyle(
            color: AppColors.onSurfaceMuted,
            fontSize: 13,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.onSurfaceMuted,
            size: 20,
          ),
          filled: true,
          fillColor: AppColors.surfaceElevated,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  // ─── Category Chips ─────────────────────────────────────────────────────────
  Widget _buildCategoryChips() {
    return BlocBuilder<MenuCategoryCubit, MenuCategoryState>(
      builder: (context, state) {
        if (state is MenuCategoryLoading || state is MenuCategoryInitial) {
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
                    width: 80,
                    height: 36,
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

        if (state is MenuCategoryError) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(state.message),
          );
        }

        final successState = state as MenuCategorySuccess;
        final categories = [...successState.categories]
          ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
        final selectedIndex = successState.selectedIndex;

        return SizedBox(
          height: 42,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tất cả
                  GestureDetector(
                    onTap: () {
                      context.read<MenuItemCubit>().loadMenuItems(-1);
                      context.read<MenuCategoryCubit>().selectCategory(-1);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: selectedIndex == -1
                            ? AppColors.primary
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: selectedIndex == -1
                            ? null
                            : Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        'Tất cả',
                        style: TextStyle(
                          color: selectedIndex == -1
                              ? AppColors.onPrimary
                              : AppColors.onSurfaceMuted,
                          fontSize: 13,
                          fontWeight: selectedIndex == -1
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Danh sách còn lại
                  ...categories.map((cate) {
                    final selected = selectedIndex == cate.id;
                    return GestureDetector(
                      onTap: () {
                        context.read<MenuItemCubit>().loadMenuItems(cate.id);
                        context.read<MenuCategoryCubit>().selectCategory(
                          cate.id,
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primary
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: selected
                              ? null
                              : Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          cate.name,
                          style: TextStyle(
                            color: selected
                                ? AppColors.onPrimary
                                : AppColors.onSurfaceMuted,
                            fontSize: 13,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── Menu List ──────────────────────────────────────────────────────────────
  Widget _buildMenuList() {
    return BlocBuilder<MenuItemCubit, MenuItemState>(
      builder: (context, menuState) {
        if (menuState is! MenuItemSuccess) return const SizedBox();

        return BlocBuilder<OrderDraftCubit, List<OrderItemEntry>>(
          builder: (context, draft) {
            final query = _searchController.text.toLowerCase();
            final items = menuState.items
                .where((i) => i.name.toLowerCase().contains(query))
                .toList();

            return GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final qty = context.read<OrderDraftCubit>().quantityOf(item.id);
                return _buildMenuItem(item, qty);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildMenuItem(MenuItem item, int qty) {
    final cubit = context.read<OrderDraftCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                ? Image.network(
                    item.imageUrl!,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _fallbackIcon(),
                    loadingBuilder: (_, child, progress) =>
                        progress == null ? child : _shimmerBox(),
                  )
                : _fallbackIcon(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.isBestSeller)
                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: AppColors.warning,
                          size: 11,
                        ),
                        SizedBox(width: 3),
                        Text(
                          'BEST SELLER',
                          style: TextStyle(
                            color: AppColors.warning,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(item.price ~/ 1000)}k',
                      style: const TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  item.description ?? '',
                  style: const TextStyle(
                    color: AppColors.onSurfaceMuted,
                    fontSize: 12,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _QuantityButton(
                      icon: Icons.remove,
                      onTap: () => cubit.decrement(item),
                      enabled: qty > 0,
                    ),
                    SizedBox(width: 32, child: Center(child: Text('$qty'))),
                    _QuantityButton(
                      icon: Icons.add,
                      onTap: () => cubit.increment(item),
                      enabled: item.isAvailable,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Bottom Bar ─────────────────────────────────────────────────────────────
  Widget _buildBottomBar() {
    return BlocBuilder<OrderDraftCubit, List<OrderItemEntry>>(
      builder: (context, draft) {
        final cubit = context.read<OrderDraftCubit>();
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.border, width: 1)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ĐANG CHỌN',
                        style: TextStyle(
                          color: AppColors.onSurfaceMuted,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Số món: ${cubit.totalItems} loại',
                        style: const TextStyle(
                          color: AppColors.onSurfaceMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'TỔNG CỘNG',
                        style: TextStyle(
                          color: AppColors.onSurfaceMuted,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatPrice(cubit.totalPrice),
                        style: const TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: draft.isEmpty
                      ? null
                      : () => _showConfirmOrder(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.check_circle_outline, size: 20),
                  label: const Text(
                    'Xác nhận đơn',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _fallbackIcon() => Container(
    width: 72,
    height: 72,
    color: AppColors.surfaceElevated,
    child: const Icon(
      Icons.restaurant_menu,
      color: AppColors.onSurfaceMuted,
      size: 32,
    ),
  );

  Widget _shimmerBox() => Shimmer.fromColors(
    baseColor: const Color(0xFFE0E0E0),
    highlightColor: const Color(0xFFF5F5F5),
    child: Container(width: 72, height: 72, color: Colors.white),
  );
}

// ─── Quantity Button ──────────────────────────────────────────────────────────
class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _QuantityButton({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.primary.withOpacity(0.15)
              : AppColors.surfaceElevated,
          shape: BoxShape.circle,
          border: Border.all(
            color: enabled ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? AppColors.primary : AppColors.onSurfaceMuted,
        ),
      ),
    );
  }
}
