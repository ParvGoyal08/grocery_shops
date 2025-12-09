import 'package:flutter/foundation.dart';
import '../models/models.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];
  String? _selectedShopId;

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  String? get selectedShopId => _selectedShopId;
  
  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalAmount => _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  bool get isEmpty => _cartItems.isEmpty;

  void addToCart(Item item, {int quantity = 1}) {
    // If cart is empty or item is from the same shop
    if (_cartItems.isEmpty) {
      _selectedShopId = item.shopId;
    } else if (_selectedShopId != item.shopId) {
      // Can't add items from different shops
      return;
    }

    // Check if item already exists in cart
    final existingIndex = _cartItems.indexWhere((ci) => ci.item.id == item.id);
    if (existingIndex != -1) {
      _cartItems[existingIndex].quantity += quantity;
    } else {
      _cartItems.add(CartItem(item: item, quantity: quantity));
    }
    notifyListeners();
  }

  void updateQuantity(String itemId, int quantity) {
    final index = _cartItems.indexWhere((ci) => ci.item.id == itemId);
    if (index != -1) {
      if (quantity <= 0) {
        _cartItems.removeAt(index);
        if (_cartItems.isEmpty) {
          _selectedShopId = null;
        }
      } else {
        _cartItems[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void removeFromCart(String itemId) {
    _cartItems.removeWhere((ci) => ci.item.id == itemId);
    if (_cartItems.isEmpty) {
      _selectedShopId = null;
    }
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _selectedShopId = null;
    notifyListeners();
  }

  CartItem? getCartItem(String itemId) {
    try {
      return _cartItems.firstWhere((ci) => ci.item.id == itemId);
    } catch (e) {
      return null;
    }
  }

  int getItemQuantityInCart(String itemId) {
    final cartItem = getCartItem(itemId);
    return cartItem?.quantity ?? 0;
  }
}
