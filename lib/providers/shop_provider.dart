import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../data/sample_data.dart';

class ShopProvider extends ChangeNotifier {
  final List<Shop> _shops = [];
  final List<Item> _items = [];
  final Uuid _uuid = const Uuid();

  ShopProvider() {
    _initializeData();
  }

  void _initializeData() {
    _shops.addAll(SampleData.getShops());
    _items.addAll(SampleData.getItems());
  }

  List<Shop> get shops => List.unmodifiable(_shops);
  List<Item> get allItems => List.unmodifiable(_items);

  int get totalItemCount => _items.length;

  Shop? getShopById(String id) {
    try {
      return _shops.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  Shop? getShopByOwnerId(String ownerId) {
    try {
      return _shops.firstWhere((s) => s.ownerId == ownerId);
    } catch (e) {
      return null;
    }
  }

  List<Item> getItemsByShopId(String shopId) {
    return _items.where((i) => i.shopId == shopId).toList();
  }

  Item? getItemById(String id) {
    try {
      return _items.firstWhere((i) => i.id == id);
    } catch (e) {
      return null;
    }
  }

  // Shop owner functions
  void addItem(Item item) {
    final newItem = Item(
      id: _uuid.v4(),
      shopId: item.shopId,
      name: item.name,
      description: item.description,
      imagePath: item.imagePath,
      price: item.price,
      stockQuantity: item.stockQuantity,
    );
    _items.add(newItem);
    notifyListeners();
  }

  void updateItem(Item updatedItem) {
    final index = _items.indexWhere((i) => i.id == updatedItem.id);
    if (index != -1) {
      _items[index] = updatedItem;
      notifyListeners();
    }
  }

  void removeItem(String itemId) {
    _items.removeWhere((i) => i.id == itemId);
    notifyListeners();
  }

  void updateItemPrice(String itemId, double newPrice) {
    final item = getItemById(itemId);
    if (item != null) {
      item.price = newPrice;
      notifyListeners();
    }
  }

  void updateItemStock(String itemId, int newQuantity) {
    final item = getItemById(itemId);
    if (item != null) {
      item.stockQuantity = newQuantity;
      notifyListeners();
    }
  }

  bool reduceStock(String itemId, int quantity) {
    final item = getItemById(itemId);
    if (item != null && item.stockQuantity >= quantity) {
      item.stockQuantity -= quantity;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Check if all items in cart are available
  bool checkStockAvailability(List<CartItem> cartItems) {
    for (final cartItem in cartItems) {
      final item = getItemById(cartItem.item.id);
      if (item == null || item.stockQuantity < cartItem.quantity) {
        return false;
      }
    }
    return true;
  }

  // Get unavailable items (insufficient stock)
  List<String> getUnavailableItems(List<CartItem> cartItems) {
    final unavailable = <String>[];
    for (final cartItem in cartItems) {
      final item = getItemById(cartItem.item.id);
      if (item == null || item.stockQuantity < cartItem.quantity) {
        unavailable.add('${cartItem.item.name} (requested: ${cartItem.quantity}, available: ${item?.stockQuantity ?? 0})');
      }
    }
    return unavailable;
  }
}
