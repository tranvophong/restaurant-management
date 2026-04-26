import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servesys/core/utils/appcolor_util.dart';
import 'package:servesys/features/order/bloc/order_draft_cubit.dart';
import 'package:servesys/features/order/bloc/order_submission_cubit.dart';
import 'package:servesys/features/order/bloc/order_submission_state.dart';
import 'package:servesys/features/order/data/models/order_item_entry.dart';

class OrderConfirmSheet extends StatelessWidget {
  final int tableId;
  final String tableName;
  final String note;
  final String Function(int) formatPrice;

  const OrderConfirmSheet({
    super.key,
    required this.tableId,
    required this.tableName,
    required this.note,
    required this.formatPrice,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderSubmissionCubit, OrderSubmissionState>(
      listener: (context, submissionState) {
        if (submissionState is OrderSubmissionSuccess) {
          final messenger = ScaffoldMessenger.of(context);
          Navigator.pop(context); // Close the confirm sheet
          Navigator.pop(context); // Go back to Home Screen
          messenger.showSnackBar(
            SnackBar(
              content: Text('${tableName.toUpperCase()} Đặt món thành công!'),
              backgroundColor: AppColors.success,
            ),
          );
        } else if (submissionState is OrderSubmissionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${tableName.toUpperCase()} Đặt món lỗi: ${submissionState.message}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, submissionState) {
        final isLoading = submissionState is OrderSubmissionLoading;

        return BlocBuilder<OrderDraftCubit, List<OrderItemEntry>>(
          builder: (context, draft) {
            final cubit = context.read<OrderDraftCubit>();

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Title
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Xác nhận đơn – $tableName',
                          style: const TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.close,
                            color: AppColors.onSurfaceMuted,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1, color: AppColors.border),

                  // Danh sách món
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.45,
                    ),
                    child: draft.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(32),
                            child: Text(
                              'Chưa có món nào được chọn.',
                              style: TextStyle(color: AppColors.onSurfaceMuted),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: draft.length,
                            separatorBuilder: (_, __) => const Divider(
                              height: 1,
                              indent: 16,
                              endIndent: 16,
                              color: AppColors.border,
                            ),
                            itemBuilder: (_, i) {
                              final entry = draft[i];
                              return ListTile(
                                dense: true,
                                title: Text(
                                  entry.menuItem.name,
                                  style: const TextStyle(
                                    color: AppColors.onSurface,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  formatPrice(entry.menuItem.price.toInt()),
                                  style: const TextStyle(
                                    color: AppColors.onSurfaceMuted,
                                    fontSize: 12,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Nút trừ
                                    _SheetQtyButton(
                                      icon: Icons.remove,
                                      onTap: () =>
                                          cubit.decrement(entry.menuItem),
                                      enabled: entry.quantity > 0,
                                    ),
                                    SizedBox(
                                      width: 32,
                                      child: Center(
                                        child: Text(
                                          '${entry.quantity}',
                                          style: const TextStyle(
                                            color: AppColors.onSurface,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Nút cộng
                                    _SheetQtyButton(
                                      icon: Icons.add,
                                      onTap: () =>
                                          cubit.increment(entry.menuItem),
                                      enabled: entry.menuItem.isAvailable,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),

                  const Divider(height: 1, color: AppColors.border),

                  // Note (nếu có)
                  if (note.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.notes,
                            size: 14,
                            color: AppColors.onSurfaceMuted,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              note,
                              style: const TextStyle(
                                color: AppColors.onSurfaceMuted,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Tổng & nút xác nhận
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${cubit.totalItems} loại món',
                              style: const TextStyle(
                                color: AppColors.onSurfaceMuted,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              formatPrice(cubit.totalPrice),
                              style: const TextStyle(
                                color: AppColors.onSurface,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: draft.isEmpty || isLoading
                                ? null
                                : () {
                                    final items = cubit.toOrderPayload();
                                    context
                                        .read<OrderSubmissionCubit>()
                                        .submitOrder(tableId, note, items);
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.onPrimary,
                              disabledBackgroundColor: AppColors.border,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            icon: const Icon(
                              Icons.check_circle_outline,
                              size: 20,
                            ),
                            label: isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Gửi bếp',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// Nút +/- nhỏ dùng trong sheet
class _SheetQtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _SheetQtyButton({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 26,
        height: 26,
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
          size: 14,
          color: enabled ? AppColors.primary : AppColors.onSurfaceMuted,
        ),
      ),
    );
  }
}
