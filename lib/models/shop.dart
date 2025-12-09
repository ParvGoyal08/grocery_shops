class Shop {
  final String id;
  final String ownerId;
  String name;
  String? description;
  String? address;
  double latitude;
  double longitude;

  Shop({
    required this.id,
    required this.ownerId,
    required this.name,
    this.description,
    this.address,
    required this.latitude,
    required this.longitude,
  });
}
