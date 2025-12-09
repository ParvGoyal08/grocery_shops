# Grocery Shop Application - Design Document

## Overview
This is a Flutter-based Android application for grocery shop owners and customers. The app supports multiple shop owners, each with their own inventory, and customers who can browse, add items to cart, and place orders with location-based delivery estimates.

## How to Build and Run

### Prerequisites
- Flutter SDK (3.10.3 or later)
- Android Studio or VS Code with Flutter extension
- Android Emulator or physical Android device

### Build Instructions
1. Open terminal and navigate to the project directory:
   ```
   cd "c:\Users\Parv\OneDrive\Desktop\CN mu\Assignment\assignment"
   ```
2. Install dependencies:
   ```
   flutter pub get
   ```
3. Run the app on connected device/emulator:
   ```
   flutter run
   ```
4. Build production APK:
   ```
   flutter build apk --release
   ```
   - Output: `build/app/outputs/flutter-apk/app-release.apk`

### Dependencies
- **provider**: State management
- **geolocator**: GPS location services
- **uuid**: Unique ID generation
- **intl**: Date formatting
- **image_picker**: Image selection for product uploads
- **path_provider**: File path management
- **path**: Path manipulation utilities

---

## Requirements Fulfillment

### ✅ Minimum Requirements

| Requirement | Implementation |
|-------------|----------------|
| Separate roles for shop owner and customer | Login screen with role-based authentication. Users are pre-configured as either shop owners or customers. |
| At least five shop owner accounts | 5 shop owners: candy_owner, coffee_owner, corn_owner, fish_owner, rice_owner |
| Each shop owner has >= 30 items | Each shop has exactly 31 items (155 total items) |
| Each item includes: name, description, image, unit price, available quantity, unique ID | ✅ All fields implemented in Item model |
| App displays >= 150 items during demo | 155 items total (31 items × 5 shops) |

---

### ✅ Shop Owner Functionality

| Feature | Implementation |
|---------|----------------|
| Add items with images | AddEditItemScreen allows creating new items with image selection from shop's image folder |
| Edit items | Same screen allows editing existing items |
| Remove items | Delete button with confirmation dialog on inventory screen |
| Update price | Can be changed in edit screen or directly in inventory |
| Update stock quantity | Can be changed in edit screen |
| Dashboard with inventory and orders | ShopOwnerHome shows: total items, total stock, pending orders, total revenue, low stock alerts, recent orders |

---

### ✅ Customer Functionality

| Feature | Implementation |
|---------|----------------|
| Browse by shop | ShopListScreen shows all 5 shops with item counts |
| Browse across shops | AllItemsScreen shows all 155 items with filter by shop |
| Add items to cart with quantities | ItemDetailScreen and item cards allow adding with quantity selection |
| Checkout/place order | CheckoutScreen with order summary |
| Atomic stock check | Orders only succeed if ALL items are in stock (checkStockAvailability) |
| Partial orders not allowed | ✅ Error shown if any item has insufficient stock |
| Stock reduction on order | reduceStock() called for each item after successful order |
| Customer location (manual + GPS) | Both GPS location and manual lat/lng input supported |
| Distance calculation | Haversine formula calculates km between customer and shop |
| Estimated delivery time | Formula: 10 min base + 3 min per km |
| Time shown before placing order | DeliveryInformation section displays distance and estimated time |

---

## Demo Accounts

### Shop Owners (Password: `password123` for all)

| Username | Shop Name | Items |
|----------|-----------|-------|
| candy_owner | Sweet Treats Candy Shop | 31 candy items |
| coffee_owner | Coffee Paradise | 31 coffee items |
| corn_owner | Corn Corner | 31 corn items |
| fish_owner | Ocean Fresh Fish Market | 31 fish items |
| rice_owner | Rice Kingdom | 31 rice items |

### Customers (Password: `password123` for all)

| Username | Name | Pre-set Location |
|----------|------|------------------|
| customer1 | John Doe | Delhi (28.6139, 77.2090) |
| customer2 | Jane Smith | Delhi (28.6500, 77.2300) |
| customer3 | Bob Wilson | Delhi (28.5800, 77.1900) |

---

## Application Structure

```
lib/
├── main.dart                    # App entry point with providers
├── models/
│   ├── user.dart               # User model with roles
│   ├── shop.dart               # Shop model with location
│   ├── item.dart               # Item model with stock
│   ├── cart_item.dart          # Cart item with quantity
│   ├── order.dart              # Order with delivery info
│   └── models.dart             # Export file
├── providers/
│   ├── auth_provider.dart      # Authentication state
│   ├── shop_provider.dart      # Shop & inventory management
│   ├── cart_provider.dart      # Shopping cart state
│   ├── order_provider.dart     # Order management
│   └── providers.dart          # Export file
├── data/
│   └── sample_data.dart        # 5 shops × 31 items = 155 items
└── screens/
    ├── login_screen.dart       # Login with demo accounts
    ├── shop_owner/
    │   ├── shop_owner_home.dart    # Dashboard + navigation
    │   ├── inventory_screen.dart   # Item list with search/sort
    │   ├── add_edit_item_screen.dart # Add/edit items
    │   └── orders_screen.dart      # View and update orders
    └── customer/
        ├── customer_home.dart      # Home with navigation
        ├── shop_list_screen.dart   # Browse shops
        ├── shop_items_screen.dart  # Items in a shop
        ├── all_items_screen.dart   # All items across shops
        ├── item_detail_screen.dart # Item details + add to cart
        ├── cart_screen.dart        # Shopping cart
        ├── checkout_screen.dart    # Checkout with location
        └── customer_orders_screen.dart # Order history
```

---

## Key Features

### 1. Stock Management
- Real-time stock tracking
- Low stock alerts (< 10 items)
- Atomic stock check at checkout
- Stock automatically reduces on order placement

### 2. Location & Delivery
- GPS location detection with permission handling
- Manual latitude/longitude input
- Haversine distance calculation
- Delivery time estimation formula:
  - `Time = 10 minutes (base) + 3 minutes × distance (km)`

### 3. Cart System
- Single-shop cart (items from one shop only)
- Quantity adjustment in cart
- Clear cart option
- Real-time stock validation

### 4. Order System
- Order tracking for customers
- Order management for shop owners
- Status updates (Pending → Processing → Delivered/Cancelled)
- Complete order history

---

## Demo Flow

### Shop Owner Demo
1. Login as `candy_owner` / `password123`
2. View dashboard with stats
3. Navigate to Inventory
4. Edit an item's price or stock
5. Add a new item
6. Delete an item
7. View orders received

### Customer Demo
1. Login as `customer1` / `password123`
2. Browse shops (5 shops visible)
3. Select a shop and browse items
4. Add items to cart
5. Go to cart, adjust quantities
6. Proceed to checkout
7. Set location (GPS or manual)
8. View distance and estimated delivery time
9. Place order
10. Verify stock reduction by checking shop inventory

### Stock Verification Demo
1. As shop owner: Note stock quantity of an item
2. As customer: Order that item
3. As shop owner: Verify stock reduced

---

## Total Items Count

| Shop | Items |
|------|-------|
| Sweet Treats Candy Shop | 31 |
| Coffee Paradise | 31 |
| Corn Corner | 31 |
| Ocean Fresh Fish Market | 31 |
| Rice Kingdom | 31 |
| **Total** | **155** |

✅ **Exceeds requirement of 150 items**

---

## Technologies Used
- **Flutter 3.10.3+**: Cross-platform UI framework
- **Dart**: Programming language
- **Provider**: State management pattern
- **Geolocator**: Location services
- **Material Design 3**: UI components

---

## Screenshots (App Screens)

1. **Login Screen**: Role-based login with demo account reference
2. **Shop Owner Dashboard**: Stats, alerts, recent orders
3. **Inventory Management**: Search, sort, edit, delete items
4. **Customer Home**: Shop count, product count, cart badge
5. **Shop Browse**: 5 shops with details
6. **Item Grid**: Product images, prices, stock, add to cart
7. **Cart**: Quantity adjustment, total calculation
8. **Checkout**: Location input, distance, delivery estimate
9. **Order Confirmation**: Order ID, delivery time

---

## Conclusion

This application fulfills all the specified requirements:
- ✅ 5 distinct shop owners
- ✅ 31 items per shop (155 total, exceeding 150 requirement)
- ✅ All item fields (name, description, image, price, stock, ID)
- ✅ Shop owner CRUD operations
- ✅ Customer browsing and ordering
- ✅ Atomic stock checking
- ✅ Location-based delivery estimation
- ✅ Stock reduction on order placement


github repo link - https://github.com/ParvGoyal08/grocery_shops