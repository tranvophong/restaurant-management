import 'package:servesys/features/home/domain/entities/table.dart';
import 'package:servesys/features/home/domain/enums/table_status.dart';
import 'package:servesys/features/home/extensions/table_status_parsing.dart';

class TableModel {
  int id;
  String name;
  TableStatus status;
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
      status: json['status'].toString().toTableStatus(),
      chairs: json['seats'],
      isAvailable: json['isAvailable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status.name,
      'seats': chairs,
      'isAvailable': isAvailable,
    };
  }

  Table toEntity() {
    return Table(id: id, name: name, status: status, chairs: chairs, isAvailable: isAvailable);
  }
}
