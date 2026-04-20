// area_state.dart
import 'package:servesys/features/home/domain/entities/table.dart';

abstract class TableState {}

class TableInitial extends TableState {}

class TableLoading extends TableState {}

class TableSuccess extends TableState {
  final List<Table> tables;
  int selectedIndex;
  TableSuccess({required this.tables, this.selectedIndex = -1});
  
  TableSuccess copyWith({List<Table>? tables, int? selectedIndex}) {
    return TableSuccess(
      tables: tables ?? this.tables,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

class TableError extends TableState {
  final String message;
  TableError(this.message);
}