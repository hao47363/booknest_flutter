import '../models/app_user.dart';
import '../models/order.dart';
import '../models/product.dart';

const List<Product> seedProducts = <Product>[
  Product(
    id: 'wireless-headphones',
    name: 'Aero Wireless Headphones',
    category: 'Audio',
    price: 129,
    description: 'Noise-canceling headset with lightweight comfort.',
    rating: 4.8,
    imageUrl: 'assets/images/headphones.jpg',
  ),
  Product(
    id: 'travel-backpack',
    name: 'Urban Travel Backpack',
    category: 'Accessories',
    price: 89,
    description: 'Spacious daily backpack with padded laptop sleeve.',
    rating: 4.6,
    imageUrl: 'assets/images/backpack.jpg',
  ),
  Product(
    id: 'smart-watch',
    name: 'Pulse Smart Watch',
    category: 'Wearables',
    price: 199,
    description: 'Fitness tracking with week-long battery life.',
    rating: 4.7,
    imageUrl: 'assets/images/watch.jpg',
  ),
  Product(
    id: 'desk-lamp',
    name: 'Neo Desk Lamp',
    category: 'Home',
    price: 59,
    description: 'Warm and cool light tones with touch dimmer.',
    rating: 4.4,
    imageUrl: 'assets/images/lamp.jpg',
  ),
  Product(
    id: 'mechanical-keyboard',
    name: 'TypeFlow Mechanical Keyboard',
    category: 'Office',
    price: 149,
    description: 'Compact keyboard with tactile switches and RGB lighting.',
    rating: 4.9,
    imageUrl: 'assets/images/keyboard.jpg',
  ),
  Product(
    id: 'running-shoes',
    name: 'Stride Running Shoes',
    category: 'Sports',
    price: 119,
    description: 'Breathable knit upper and responsive foam cushion.',
    rating: 4.5,
    imageUrl: 'assets/images/shoes.jpg',
  ),
];

const AppUser seedUser = AppUser(
  id: 'user-1',
  name: 'Alex Johnson',
  email: 'alex@demo.app',
  bio: 'Prototype user exploring local-first experiences.',
  avatarUrl: 'assets/images/avatar.jpg',
);

final List<MockOrder> seedOrders = <MockOrder>[
  MockOrder(
    id: 'order-1001',
    productId: 'smart-watch',
    productName: 'Pulse Smart Watch',
    status: 'Delivered',
    total: 199,
    createdAtIso: DateTime.now().subtract(const Duration(days: 4)).toIso8601String(),
  ),
  MockOrder(
    id: 'order-1002',
    productId: 'travel-backpack',
    productName: 'Urban Travel Backpack',
    status: 'In transit',
    total: 89,
    createdAtIso: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
  ),
];
