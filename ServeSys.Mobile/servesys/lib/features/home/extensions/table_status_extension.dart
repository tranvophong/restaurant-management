import 'dart:ui';

import 'package:servesys/core/utils/appcolor_util.dart';
import 'package:servesys/features/home/domain/enums/table_status.dart';

extension TableStatusUI on TableStatus {
  Color get color {
    switch (this) {
      case TableStatus.available:
        return AppColors.success;
      case TableStatus.occupied:
        return AppColors.error;
      case TableStatus.reserved:
        return AppColors.info;
    }
  }

  String get label {
    switch (this) {
      case TableStatus.available:
        return 'BÀN TRỐNG';
      case TableStatus.occupied:
        return 'ĐANG CÓ KHÁCH';
      case TableStatus.reserved:
        return 'ĐÃ ĐẶT TRƯỚC';
    }
  }
}