import 'item.dart';

class CartItem {
  final Item item;
  int quantity;

  CartItem({
    required this.item,
    required this.quantity,
  });

  double get totalPrice => item.price * quantity;
}
