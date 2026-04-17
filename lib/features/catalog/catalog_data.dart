class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.priceLabel,
    required this.description,
    required this.rating,
  });

  final String id;
  final String name;
  final String category;
  final String priceLabel;
  final String description;
  final double rating;
}

const List<Product> mockProducts = <Product>[
  Product(
    id: 'wireless-headphones',
    name: 'Aero Wireless Headphones',
    category: 'Audio',
    priceLabel: '\$129',
    description: 'Noise-canceling headset with lightweight comfort.',
    rating: 4.8,
  ),
  Product(
    id: 'travel-backpack',
    name: 'Urban Travel Backpack',
    category: 'Accessories',
    priceLabel: '\$89',
    description: 'Spacious daily backpack with padded laptop sleeve.',
    rating: 4.6,
  ),
  Product(
    id: 'smart-watch',
    name: 'Pulse Smart Watch',
    category: 'Wearables',
    priceLabel: '\$199',
    description: 'Fitness tracking with week-long battery life.',
    rating: 4.7,
  ),
];
