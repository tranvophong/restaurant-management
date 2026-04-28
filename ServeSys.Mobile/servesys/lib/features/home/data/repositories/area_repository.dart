import 'package:servesys/core/base/base_repository.dart';
import 'package:servesys/core/network/api_endpoints.dart';
import 'package:servesys/features/home/data/models/area_model.dart';
import 'package:servesys/features/home/domain/entities/area.dart';

class AreaRepository extends BaseRepository {
  AreaRepository(super.apiClient);

  Future<List<Area>> getAreas() => handle(
    (apiClient) => apiClient.get(ApiEndpoints.areas),
    (data) =>
        (data as List).map((e) => AreaModel.fromJson(e).toEntity()).toList(),
  );
}
