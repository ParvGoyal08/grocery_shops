class Item {
  final String id;
  final String shopId;
  String name;
  String? description;
  String imagePath;
  double price;
  int stockQuantity;

  Item({
    required this.id,
    required this.shopId,
    required this.name,
    this.description,
    required this.imagePath,
    required this.price,
    required this.stockQuantity,
  });

  Item copyWith({
    String? id,
    String? shopId,
    String? name,
    String? description,
    String? imagePath,
    double? price,
    int? stockQuantity,
  }) {
    return Item(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      name: name ?? this.name,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      price: price ?? this.price,
      stockQuantity: stockQuantity ?? this.stockQuantity,
    );
  }
}
