import 'package:servesys/features/home/domain/enums/table_status.dart';

class Table {
  int id;
  String name;
  TableStatus status;
  int chairs;
  bool isAvailable;

  Table({
    required this.id,
    required this.name,
    required this.status,
    required this.chairs,
    required this.isAvailable,
  });
}
