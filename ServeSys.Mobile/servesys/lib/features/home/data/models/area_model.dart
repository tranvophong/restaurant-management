import 'package:servesys/features/home/domain/entities/area.dart';

class AreaModel {
  int id;
  String name;

  AreaModel({
    required this.id,
    required this.name,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name
    };
  }

  Area toEntity() {
    return Area(
      id: id,
      name: name,
    );
  }
}