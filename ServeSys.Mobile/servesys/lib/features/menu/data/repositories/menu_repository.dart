import 'package:servesys/core/base/base_repository.dart';
import 'package:servesys/core/network/api_endpoints.dart';
import 'package:servesys/features/menu/data/models/menu_category_model.dart';
import 'package:servesys/features/menu/data/models/menu_item_model.dart';
import 'package:servesys/features/menu/domain/entities/menu_category.dart';
import 'package:servesys/features/menu/domain/entities/menu_item.dart';

class MenuRepository extends BaseRepository {
  MenuRepository(super.apiClient);

  Future<List<MenuCategory>> getMenuCategories() => handle(
    (apiClient) => apiClient.get(ApiEndpoints.menuCategories),
    (data) =>
        (data as List).map((e) => MenuCategoryModel.fromJson(e).toEntity()).toList(),
  );

  Future<List<MenuItem>> getMenuItemsByCategory(int categoryId) => handle(
    (apiClient) => apiClient.get(ApiEndpoints.menuItemsByCategory(categoryId)),
    (data) =>
        (data as List).map((e) => MenuItemModel.fromJson(e).toEntity()).toList(),
  );
}
