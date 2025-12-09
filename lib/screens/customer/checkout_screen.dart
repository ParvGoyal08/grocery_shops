import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  double? _userLatitude;
  double? _userLongitude;
  bool _isLoadingLocation = false;
  String? _locationError;
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  bool _useManualLocation = false;

  @override
  void initState() {
    super.initState();
    _loadSavedLocation();
  }

  void _loadSavedLocation() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;
    if (user != null && user.latitude != null && user.longitude != null) {
      setState(() {
        _userLatitude = user.latitude;
        _userLongitude = user.longitude;
        _latController.text = user.latitude.toString();
        _lngController.text = user.longitude.toString();
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _locationError = null;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError = 'Location services are disabled. Please use manual input.';
          _useManualLocation = true;
          _isLoadingLocation = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationError = 'Location permission denied. Please use manual input.';
            _useManualLocation = true;
            _isLoadingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError = 'Location permissions permanently denied. Please use manual input.';
          _useManualLocation = true;
          _isLoadingLocation = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      setState(() {
        _userLatitude = position.latitude;
        _userLongitude = position.longitude;
        _latController.text = position.latitude.toString();
        _lngController.text = position.longitude.toString();
        _isLoadingLocation = false;
      });

      // Save location to user profile
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.updateUserLocation(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _locationError = 'Failed to get location: $e. Please use manual input.';
        _useManualLocation = true;
        _isLoadingLocation = false;
      });
    }
  }

  void _applyManualLocation() {
    final lat = double.tryParse(_latController.text);
    final lng = double.tryParse(_lngController.text);

    if (lat != null && lng != null) {
      if (lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180) {
        setState(() {
          _userLatitude = lat;
          _userLongitude = lng;
          _locationError = null;
        });

        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.updateUserLocation(lat, lng);
      } else {
        setState(() {
          _locationError = 'Invalid coordinates. Lat: -90 to 90, Lng: -180 to 180';
        });
      }
    } else {
      setState(() {
        _locationError = 'Please enter valid numbers';
      });
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // Haversine formula
    const R = 6371.0; // Earth's radius in km
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  int _calculateDeliveryTime(double distanceKm) {
    // Base time: 10 min preparation + 3 min per km
    return (10 + distanceKm * 3).round();
  }

  @override
  void dispose() {
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final shopProvider = Provider.of<ShopProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    if (cartProvider.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Checkout'),
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: Text('Your cart is empty')),
      );
    }

    final shop = shopProvider.getShopById(cartProvider.selectedShopId!);
    final user = authProvider.currentUser!;

    // Check stock availability
    final stockAvailable = shopProvider.checkStockAvailability(cartProvider.cartItems);
    final unavailableItems = shopProvider.getUnavailableItems(cartProvider.cartItems);

    // Calculate distance and delivery time if location is set
    double? distance;
    int? deliveryTime;
    if (_userLatitude != null && _userLongitude != null && shop != null) {
      distance = _calculateDistance(
        _userLatitude!,
        _userLongitude!,
        shop.latitude,
        shop.longitude,
      );
      deliveryTime = _calculateDeliveryTime(distance);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ...cartProvider.cartItems.map((cartItem) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text('${cartItem.item.name} x${cartItem.quantity}'),
                              ),
                              Text('\$${cartItem.totalPrice.toStringAsFixed(2)}'),
                            ],
                          ),
                        )),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Stock Warning
            if (!stockAvailable) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'Stock Issue',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('Some items are no longer available in requested quantity:'),
                    const SizedBox(height: 4),
                    ...unavailableItems.map((item) => Text(
                          '• $item',
                          style: const TextStyle(color: Colors.red),
                        )),
                  ],
                ),
              ),
            ],

            // Location Section
            const SizedBox(height: 24),
            const Text(
              'Delivery Location',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                            icon: _isLoadingLocation
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.my_location),
                            label: Text(_isLoadingLocation ? 'Getting...' : 'Use GPS'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() => _useManualLocation = !_useManualLocation);
                            },
                            icon: const Icon(Icons.edit_location),
                            label: const Text('Manual'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_useManualLocation) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _latController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                              decoration: InputDecoration(
                                labelText: 'Latitude',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _lngController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                              decoration: InputDecoration(
                                labelText: 'Longitude',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _applyManualLocation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Apply Location'),
                        ),
                      ),
                    ],
                    if (_locationError != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _locationError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ],
                    if (_userLatitude != null && _userLongitude != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Location set: ${_userLatitude!.toStringAsFixed(4)}, ${_userLongitude!.toStringAsFixed(4)}',
                              style: TextStyle(color: Colors.green.shade700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Delivery Info
            if (distance != null && deliveryTime != null) ...[
              const SizedBox(height: 24),
              const Text(
                'Delivery Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.store, color: Colors.green.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('From', style: TextStyle(fontSize: 12)),
                                Text(
                                  shop?.name ?? 'Unknown Shop',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              Icons.straighten,
                              'Distance',
                              '${distance.toStringAsFixed(2)} km',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInfoCard(
                              Icons.timer,
                              'Est. Delivery',
                              '$deliveryTime min',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Place Order Button
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: (stockAvailable && _userLatitude != null && _userLongitude != null)
                    ? () => _placeOrder(
                          context,
                          cartProvider,
                          shopProvider,
                          orderProvider,
                          shop!,
                          user,
                          distance!,
                          deliveryTime!,
                        )
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _userLatitude == null
                      ? 'Set Location to Continue'
                      : (!stockAvailable ? 'Fix Stock Issues' : 'Place Order'),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.green.shade700),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }

  void _placeOrder(
    BuildContext context,
    CartProvider cartProvider,
    ShopProvider shopProvider,
    OrderProvider orderProvider,
    Shop shop,
    User user,
    double distance,
    int deliveryTime,
  ) {
    // Final stock check
    if (!shopProvider.checkStockAvailability(cartProvider.cartItems)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Stock has changed. Please review your cart.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Reduce stock for all items
    for (final cartItem in cartProvider.cartItems) {
      shopProvider.reduceStock(cartItem.item.id, cartItem.quantity);
    }

    // Create order
    final order = orderProvider.createOrder(
      customerId: user.id,
      customerName: user.name,
      shopId: shop.id,
      shopName: shop.name,
      cartItems: cartProvider.cartItems,
      distance: distance,
      estimatedDeliveryMinutes: deliveryTime,
    );

    // Clear cart
    cartProvider.clearCart();

    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade700, size: 32),
            const SizedBox(width: 8),
            const Text('Order Placed!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order.id.substring(0, 8)}'),
            const SizedBox(height: 8),
            Text('Total: \$${order.totalAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text('Distance: ${distance.toStringAsFixed(2)} km'),
            const SizedBox(height: 8),
            Text(
              'Estimated Delivery: $deliveryTime minutes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to home
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
