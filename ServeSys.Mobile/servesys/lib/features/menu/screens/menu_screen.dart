import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servesys/core/utils/appcolor_util.dart';
import 'package:servesys/features/menu/bloc/menu_category_cubit.dart';
import 'package:servesys/features/menu/bloc/menu_category_state.dart';
import 'package:servesys/features/menu/bloc/menu_item_cubit.dart';
import 'package:servesys/features/menu/bloc/menu_item_state.dart';
import 'package:servesys/features/menu/domain/entities/menu_item.dart';
import 'package:shimmer/shimmer.dart';

// ─── Menu Screen ──────────────────────────────────────────────────────────────
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildCategoryChips(),
            Expanded(child: _buildGrid()),
          ],
        ),
      ),
    );
  }

  // ─── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Hamburger icon
              Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: List.generate(
                  3,
                  (_) => Container(
                    width: 18,
                    height: 2,
                    decoration: BoxDecoration(
                      color: AppColors.onSurface,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'ServeSys',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Search Bar ────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          style: const TextStyle(color: AppColors.onSurface, fontSize: 14),
          decoration: const InputDecoration(
            hintText: 'Tìm tên món...',
            hintStyle: TextStyle(color: AppColors.onSurfaceMuted, fontSize: 14),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: AppColors.onSurfaceMuted,
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  // ─── Category Chips ────────────────────────────────────────────────────────
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

  // ─── Grid ──────────────────────────────────────────────────────────────────
  Widget _buildGrid() {
    return BlocBuilder<MenuItemCubit, MenuItemState>(
      builder: (context, state) {
        if (state is MenuItemLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MenuItemError) {
          return Center(child: Text(state.message));
        }

        if (state is MenuItemSuccess) {
          final query = _searchController.text.toLowerCase();

          final items = state.items.where((item) {
            return item.name.toLowerCase().contains(query);
          }).toList();

          if (items.isEmpty) {
            return const Center(child: Text('Không tìm thấy món'));
          }

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
              return _MenuCard(item: items[index], qty: 0);
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}

// ─── Menu Card Widget ─────────────────────────────────────────────────────────
class _MenuCard extends StatefulWidget {
  final MenuItem item;
  final int qty;

  const _MenuCard({required this.item, required this.qty});

  @override
  State<_MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<_MenuCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.hardEdge,
          child: Opacity(
            opacity: item.isAvailable ? 1.0 : 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Image area ──
                _buildImageArea(),
                // ── Info area ──
                Expanded(child: _buildInfoArea()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageArea() {
    final item = widget.item;
    return SizedBox(
      height: 130,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.85),
                  AppColors.background,
                ],
              ),
            ),
          ),
          // Decorative circles
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.3),
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            left: 10,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.2),
              ),
            ),
          ),
          // Out-of-stock overlay
          if (!item.isAvailable)
            Container(
              color: Colors.black.withOpacity(0.65),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Text(
                    'HẾT MÓN',
                    style: TextStyle(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoArea() {
    final item = widget.item;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          Text(
            item.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 3),
          // Description
          Text(
            item.description ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.onSurfaceMuted,
              fontSize: 11,
            ),
          ),
          const Spacer(),
          // Price + Add button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Price
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: _formatPrice(item.price),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    const TextSpan(
                      text: ' đ',
                      style: TextStyle(
                        color: AppColors.onSurfaceMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    final s = price.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write('.');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }
}
