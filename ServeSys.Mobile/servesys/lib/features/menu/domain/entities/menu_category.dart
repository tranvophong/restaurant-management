class MenuCategory {
  int id;
  String name;
  String? description;
  int displayOrder;
  bool isActive;

  MenuCategory({
    required this.id,
    required this.name,
    this.description,
    required this.displayOrder,
    required this.isActive,
  });
}
