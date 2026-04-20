import 'package:servesys/core/base/base_repository.dart';
import 'package:servesys/core/network/api_endpoints.dart';
import 'package:servesys/features/home/data/models/table_model.dart';
import 'package:servesys/features/home/domain/entities/table.dart';

class TableRepository extends BaseRepository{
  TableRepository(super.apiClient);

  Future<List<Table>> getTables(int areaId) => handle(
    (apiClient) => apiClient.get(ApiEndpoints.tablesByArea(areaId)),
    (data) =>
        (data as List).map((e) => TableModel.fromJson(e).toEntity()).toList(),
  );
}
