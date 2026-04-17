class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.rating,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final String category;
  final double price;
  final String description;
  final double rating;
  final String imageUrl;

  String get priceLabel => '\$${price.toStringAsFixed(0)}';

  Product copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
    String? description,
    double? rating,
    String? imageUrl,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'description': description,
      'rating': rating,
      'imageUrl': imageUrl,
    };
  }

  factory Product.fromJson(Map<dynamic, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      rating: (json['rating'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
    );
  }
}
