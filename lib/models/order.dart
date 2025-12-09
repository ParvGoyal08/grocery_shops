import 'cart_item.dart';

enum OrderStatus { pending, processing, delivered, cancelled }

class Order {
  final String id;
  final String customerId;
  final String customerName;
  final String shopId;
  final String shopName;
  final List<OrderItem> items;
  final double totalAmount;
  final DateTime orderDate;
  final double distance; // in km
  final int estimatedDeliveryMinutes;
  OrderStatus status;

  Order({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.shopId,
    required this.shopName,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.distance,
    required this.estimatedDeliveryMinutes,
    this.status = OrderStatus.pending,
  });
}

class OrderItem {
  final String itemId;
  final String itemName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  OrderItem({
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory OrderItem.fromCartItem(CartItem cartItem) {
    return OrderItem(
      itemId: cartItem.item.id,
      itemName: cartItem.item.name,
      quantity: cartItem.quantity,
      unitPrice: cartItem.item.price,
      totalPrice: cartItem.totalPrice,
    );
  }
}
