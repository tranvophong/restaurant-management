import 'package:servesys/features/home/domain/entities/table.dart';

class TableModel {
  int id;
  String name;
  String status;
  int chairs;
  bool isAvailable;

  TableModel({
    required this.id,
    required this.name,
    required this.status,
    required this.chairs,
    required this.isAvailable,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      chairs: json['seats'],
      isAvailable: json['isAvailable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'seats': chairs,
      'isAvailable': isAvailable,
    };
  }

  Table toEntity() {
    return Table(id: id, name: name, status: status, chairs: chairs, isAvailable: isAvailable);
  }
}
