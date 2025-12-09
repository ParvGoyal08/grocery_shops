import '../models/models.dart';

class SampleData {
  // Product names for each shop category
  static const List<String> candyNames = [
    'Gummy Bears', 'Lollipop', 'Chocolate Bar', 'Jelly Beans', 'Caramel Candy',
    'Mint Candy', 'Sour Strips', 'Cotton Candy', 'Toffee', 'Licorice',
    'Hard Candy', 'Fruit Chews', 'Marshmallow', 'Butterscotch', 'Candy Cane',
    'Rock Candy', 'Taffy', 'Fudge', 'Nougat', 'Praline',
    'Truffle', 'Bonbon', 'Jawbreaker', 'Bubble Gum', 'Candy Corn',
    'Peppermint', 'Candy Bar', 'Choco Drops', 'Sugar Candy', 'Honey Candy',
    'Rainbow Candy',
  ];

  static const List<String> coffeeNames = [
    'Arabica Beans', 'Robusta Beans', 'Espresso Blend', 'Dark Roast', 'Medium Roast',
    'Light Roast', 'Colombian Coffee', 'Ethiopian Coffee', 'Brazilian Coffee', 'Mocha Blend',
    'Decaf Coffee', 'French Roast', 'Italian Roast', 'Breakfast Blend', 'House Blend',
    'Single Origin', 'Organic Coffee', 'Fair Trade Coffee', 'Instant Coffee', 'Cold Brew Pack',
    'Cappuccino Mix', 'Latte Mix', 'Macchiato Blend', 'Americano Blend', 'Vienna Roast',
    'Turkish Coffee', 'Greek Coffee', 'Irish Coffee Mix', 'Hazelnut Coffee', 'Vanilla Coffee',
    'Caramel Coffee',
  ];

  static const List<String> cornNames = [
    'Sweet Corn', 'Popcorn Kernels', 'Corn Flour', 'Corn Starch', 'Corn Meal',
    'Corn Chips', 'Corn Oil', 'Corn Flakes', 'Baby Corn', 'Corn on Cob',
    'Frozen Corn', 'Canned Corn', 'Corn Tortillas', 'Corn Bread Mix', 'Corn Syrup',
    'Corn Puffs', 'Corn Pasta', 'Corn Grits', 'Hominy Corn', 'Corn Husks',
    'Blue Corn', 'White Corn', 'Yellow Corn', 'Organic Corn', 'Corn Nuts',
    'Corn Cakes', 'Corn Cereal', 'Corn Snacks', 'Corn Polenta', 'Corn Muffin Mix',
    'Corn Salsa',
  ];

  static const List<String> fishNames = [
    'Salmon Fillet', 'Tuna Steak', 'Cod Fish', 'Tilapia', 'Mackerel',
    'Sardines', 'Herring', 'Anchovies', 'Trout', 'Halibut',
    'Sea Bass', 'Red Snapper', 'Grouper', 'Mahi Mahi', 'Swordfish',
    'Catfish', 'Carp', 'Pike', 'Perch', 'Flounder',
    'Sole Fish', 'Haddock', 'Pollock', 'Whiting', 'Mullet',
    'Barramundi', 'Kingfish', 'Pomfret', 'Hilsa', 'Rohu',
    'Prawns',
  ];

  static const List<String> riceNames = [
    'Basmati Rice', 'Jasmine Rice', 'Brown Rice', 'White Rice', 'Wild Rice',
    'Arborio Rice', 'Sushi Rice', 'Long Grain Rice', 'Short Grain Rice', 'Sticky Rice',
    'Black Rice', 'Red Rice', 'Parboiled Rice', 'Instant Rice', 'Organic Rice',
    'Calrose Rice', 'Bomba Rice', 'Carnaroli Rice', 'Thai Rice', 'Indian Rice',
    'Vietnamese Rice', 'Japanese Rice', 'Carolina Rice', 'Valencia Rice', 'Glutinous Rice',
    'Forbidden Rice', 'Bhutanese Rice', 'Bamboo Rice', 'Cargo Rice', 'Broken Rice',
    'Rice Flour',
  ];

  static List<User> getUsers() {
    return [
      // Shop Owners
      User(
        id: 'owner_candy',
        username: 'candy_owner',
        password: 'password123',
        role: UserRole.shopOwner,
        shopId: 'shop_candy',
        name: 'Candy Shop Owner',
      ),
      User(
        id: 'owner_coffee',
        username: 'coffee_owner',
        password: 'password123',
        role: UserRole.shopOwner,
        shopId: 'shop_coffee',
        name: 'Coffee Shop Owner',
      ),
      User(
        id: 'owner_corn',
        username: 'corn_owner',
        password: 'password123',
        role: UserRole.shopOwner,
        shopId: 'shop_corn',
        name: 'Corn Shop Owner',
      ),
      User(
        id: 'owner_fish',
        username: 'fish_owner',
        password: 'password123',
        role: UserRole.shopOwner,
        shopId: 'shop_fish',
        name: 'Fish Shop Owner',
      ),
      User(
        id: 'owner_rice',
        username: 'rice_owner',
        password: 'password123',
        role: UserRole.shopOwner,
        shopId: 'shop_rice',
        name: 'Rice Shop Owner',
      ),
      // Customers
      User(
        id: 'customer_1',
        username: 'customer1',
        password: 'password123',
        role: UserRole.customer,
        name: 'John Doe',
        latitude: 28.6139,
        longitude: 77.2090,
      ),
      User(
        id: 'customer_2',
        username: 'customer2',
        password: 'password123',
        role: UserRole.customer,
        name: 'Jane Smith',
        latitude: 28.6500,
        longitude: 77.2300,
      ),
      User(
        id: 'customer_3',
        username: 'customer3',
        password: 'password123',
        role: UserRole.customer,
        name: 'Bob Wilson',
        latitude: 28.5800,
        longitude: 77.1900,
      ),
    ];
  }

  static List<Shop> getShops() {
    return [
      Shop(
        id: 'shop_candy',
        ownerId: 'owner_candy',
        name: 'Sweet Treats Candy Shop',
        description: 'Your one-stop shop for all kinds of candies and sweets',
        address: '123 Candy Lane, Sweet City',
        latitude: 28.6129,
        longitude: 77.2295,
      ),
      Shop(
        id: 'shop_coffee',
        ownerId: 'owner_coffee',
        name: 'Coffee Paradise',
        description: 'Premium coffee beans from around the world',
        address: '456 Coffee Street, Bean Town',
        latitude: 28.6350,
        longitude: 77.2100,
      ),
      Shop(
        id: 'shop_corn',
        ownerId: 'owner_corn',
        name: 'Corn Corner',
        description: 'Fresh corn products and corn-based items',
        address: '789 Corn Avenue, Harvest City',
        latitude: 28.5900,
        longitude: 77.2400,
      ),
      Shop(
        id: 'shop_fish',
        ownerId: 'owner_fish',
        name: 'Ocean Fresh Fish Market',
        description: 'Freshest fish and seafood daily',
        address: '321 Harbor Road, Fish Port',
        latitude: 28.6200,
        longitude: 77.1800,
      ),
      Shop(
        id: 'shop_rice',
        ownerId: 'owner_rice',
        name: 'Rice Kingdom',
        description: 'Premium quality rice from all regions',
        address: '654 Rice Road, Grain Village',
        latitude: 28.6450,
        longitude: 77.2500,
      ),
    ];
  }

  static List<Item> getItems() {
    final items = <Item>[];
    
    // Candy Shop Items (31 items)
    for (int i = 0; i < 31; i++) {
      items.add(Item(
        id: 'candy_item_$i',
        shopId: 'shop_candy',
        name: candyNames[i],
        description: 'Delicious ${candyNames[i]} - perfect for any sweet craving',
        imagePath: 'images/candy/CANDY${i.toString().padLeft(4, '0')}.png',
        price: 2.99 + (i * 0.5),
        stockQuantity: 50 + (i * 2),
      ));
    }

    // Coffee Shop Items (31 items) - Note: coffee folder has CORN images
    for (int i = 0; i < 31; i++) {
      items.add(Item(
        id: 'coffee_item_$i',
        shopId: 'shop_coffee',
        name: coffeeNames[i],
        description: 'Premium ${coffeeNames[i]} - aromatic and rich flavor',
        imagePath: 'images/coffee/CORN${i.toString().padLeft(4, '0')}.png',
        price: 8.99 + (i * 1.0),
        stockQuantity: 30 + (i * 2),
      ));
    }

    // Corn Shop Items (31 items) - Note: corn folder has CHOCOLATE images
    for (int i = 0; i < 31; i++) {
      items.add(Item(
        id: 'corn_item_$i',
        shopId: 'shop_corn',
        name: cornNames[i],
        description: 'Fresh ${cornNames[i]} - farm to table quality',
        imagePath: 'images/corn/CHOCOLATE${i.toString().padLeft(4, '0')}.png',
        price: 3.49 + (i * 0.3),
        stockQuantity: 100 + (i * 3),
      ));
    }

    // Fish Shop Items (31 items)
    for (int i = 0; i < 31; i++) {
      items.add(Item(
        id: 'fish_item_$i',
        shopId: 'shop_fish',
        name: fishNames[i],
        description: 'Fresh ${fishNames[i]} - caught daily from the ocean',
        imagePath: 'images/fish/FISH${i.toString().padLeft(4, '0')}.png',
        price: 12.99 + (i * 1.5),
        stockQuantity: 20 + (i * 2),
      ));
    }

    // Rice Shop Items (31 items)
    for (int i = 0; i < 31; i++) {
      items.add(Item(
        id: 'rice_item_$i',
        shopId: 'shop_rice',
        name: riceNames[i],
        description: 'Premium ${riceNames[i]} - sourced from the best farms',
        imagePath: 'images/rice/RICE${i.toString().padLeft(4, '0')}.png',
        price: 5.99 + (i * 0.75),
        stockQuantity: 80 + (i * 2),
      ));
    }

    return items;
  }
}
