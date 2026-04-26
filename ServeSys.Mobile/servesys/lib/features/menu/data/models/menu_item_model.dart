import 'package:servesys/features/menu/domain/entities/menu_item.dart';

class MenuItemModel {
  int id;
  String name;
  String? description;
  double price;
  String? imageUrl;
  int displayOrder;
  bool isAvailable;
  bool isBestSeller;
  
  MenuItemModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    required this.displayOrder,
    required this.isAvailable,
    required this.isBestSeller
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      displayOrder: json['displayOrder'],
      isAvailable: _parseBool(json['isAvailable']),
      isBestSeller: _parseBool(json['isBestSeller'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'displayOrder': displayOrder,
      'isAvailable': isAvailable,
      'isBestSeller': isBestSeller
    };
  }

  MenuItem toEntity() {
    return MenuItem(
      id: id,
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl,
      displayOrder: displayOrder,
      isAvailable: isAvailable,
      isBestSeller: isBestSeller
    );
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true';
    return false; // default
  }
}
