import 'package:servesys/features/home/domain/enums/table_status.dart';

extension TableStatusParsing on String {
  TableStatus toTableStatus() {
    return TableStatus.values.firstWhere(
      (e) => e.name == toLowerCase(),
      orElse: () => throw Exception('Invalid status: $this'),
    );
  }
}