import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servesys/features/home/bloc/table_state.dart';
import 'package:servesys/features/home/data/repositories/table_repository.dart';
import 'package:servesys/features/home/domain/enums/table_status.dart';

class TableCubit extends Cubit<TableState> {
  final TableRepository _repo;

  TableCubit({required TableRepository tableRepository}) : _repo = tableRepository, super(TableInitial());


  Future<void> loadTables(int areaId) async {
    emit(TableLoading());

    try {
      final tables = await _repo.getTables(areaId);

      emit(TableSuccess(tables: tables));
    } catch (e) {
      emit(TableError(e.toString()));
    }
  }

  void updateTableStatus(int tableId, TableStatus newStatus) {
  if (state is TableSuccess) {
    final current = state as TableSuccess;

    final updatedTables = current.tables.map((t) {
      if (t.id == tableId) {
        return t.copyWith(status: newStatus);
      }
      return t;
    }).toList();

    emit(TableSuccess(tables: updatedTables));
  }
}
}