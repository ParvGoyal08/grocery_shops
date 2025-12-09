import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';
import 'shop_items_screen.dart';

class ShopListScreen extends StatelessWidget {
  const ShopListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final shops = shopProvider.shops;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: shops.length,
      itemBuilder: (context, index) {
        final shop = shops[index];
        final items = shopProvider.getItemsByShopId(shop.id);
        return _buildShopCard(context, shop, items);
      },
    );
  }

  Widget _buildShopCard(BuildContext context, Shop shop, List<Item> items) {
    final totalStock = items.fold(0, (sum, item) => sum + item.stockQuantity);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShopItemsScreen(shop: shop),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getShopColor(shop.id),
                    _getShopColor(shop.id).withOpacity(0.7),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Icon(
                  _getShopIcon(shop.id),
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shop.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    shop.description ?? '',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          shop.address ?? '',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.inventory_2, size: 16, color: Colors.green.shade700),
                          const SizedBox(width: 4),
                          Text(
                            '${items.length} items',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.storage, size: 16, color: Colors.blue.shade700),
                          const SizedBox(width: 4),
                          Text(
                            '$totalStock in stock',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getShopColor(String shopId) {
    switch (shopId) {
      case 'shop_candy':
        return Colors.pink;
      case 'shop_coffee':
        return Colors.brown;
      case 'shop_corn':
        return Colors.amber;
      case 'shop_fish':
        return Colors.blue;
      case 'shop_rice':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getShopIcon(String shopId) {
    switch (shopId) {
      case 'shop_candy':
        return Icons.cake;
      case 'shop_coffee':
        return Icons.coffee;
      case 'shop_corn':
        return Icons.grass;
      case 'shop_fish':
        return Icons.set_meal;
      case 'shop_rice':
        return Icons.rice_bowl;
      default:
        return Icons.store;
    }
  }
}
