enum UserRole { shopOwner, customer }

class User {
  final String id;
  final String username;
  final String password;
  final UserRole role;
  final String? shopId; // Only for shop owners
  String name;
  double? latitude;
  double? longitude;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
    this.shopId,
    required this.name,
    this.latitude,
    this.longitude,
  });

  bool get isShopOwner => role == UserRole.shopOwner;
  bool get isCustomer => role == UserRole.customer;
}
