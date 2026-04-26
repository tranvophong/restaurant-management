class MenuItem {
  int id;
  String name;
  String? description;
  double price;
  String? imageUrl;
  int displayOrder;
  bool isAvailable;
  bool isBestSeller;

  MenuItem({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    required this.displayOrder,
    required this.isAvailable,
    required this.isBestSeller
  });
}
