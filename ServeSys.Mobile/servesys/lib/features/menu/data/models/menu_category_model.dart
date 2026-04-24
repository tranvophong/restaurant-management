import 'package:servesys/features/menu/domain/entities/menu_category.dart';

class MenuCategoryModel {
  int id;
  String name;
  String? description;
  int displayOrder;
  bool isActive;

  MenuCategoryModel({
    required this.id,
    required this.name,
    this.description,
    required this.displayOrder,
    required this.isActive,
  });

  factory MenuCategoryModel.fromJson(Map<String, dynamic> json) {
    return MenuCategoryModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      displayOrder: json['displayOrder'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'displayOrder': displayOrder,
      'isActive': isActive,
    };
  }

  MenuCategory toEntity() {
    return MenuCategory(
      id: id,
      name: name,
      description: description,
      displayOrder: displayOrder,
      isActive: isActive,
    );
  }
}
