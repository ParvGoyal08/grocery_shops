import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];
  final Uuid _uuid = const Uuid();

  List<Order> get allOrders => List.unmodifiable(_orders);

  List<Order> getOrdersByCustomerId(String customerId) {
    return _orders.where((o) => o.customerId == customerId).toList();
  }

  List<Order> getOrdersByShopId(String shopId) {
    return _orders.where((o) => o.shopId == shopId).toList();
  }

  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.id == orderId);
    } catch (e) {
      return null;
    }
  }

  Order createOrder({
    required String customerId,
    required String customerName,
    required String shopId,
    required String shopName,
    required List<CartItem> cartItems,
    required double distance,
    required int estimatedDeliveryMinutes,
  }) {
    final orderItems = cartItems.map((ci) => OrderItem.fromCartItem(ci)).toList();
    final totalAmount = cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

    final order = Order(
      id: _uuid.v4(),
      customerId: customerId,
      customerName: customerName,
      shopId: shopId,
      shopName: shopName,
      items: orderItems,
      totalAmount: totalAmount,
      orderDate: DateTime.now(),
      distance: distance,
      estimatedDeliveryMinutes: estimatedDeliveryMinutes,
      status: OrderStatus.pending,
    );

    _orders.insert(0, order); // Add to beginning for recent first
    notifyListeners();
    return order;
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    final order = getOrderById(orderId);
    if (order != null) {
      order.status = status;
      notifyListeners();
    }
  }
}
