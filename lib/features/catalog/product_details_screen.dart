import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/product.dart';
import '../../core/state/app_scope.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final bool isInCart = appState.cartProducts.any((Product item) => item.id == product.id);
    return Scaffold(
      appBar: AppBar(
        leading: context.canPop()
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.goNamed('catalog'),
                tooltip: 'Back to catalog',
              ),
        title: const Text('Product details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Hero(
            tag: product.id,
            child: Container(
              height: 200,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.asset(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            product.category.toUpperCase(),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(
            product.priceLabel,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Text(product.description, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => appState.toggleCart(product.id),
            icon: Icon(isInCart ? Icons.remove_shopping_cart_outlined : Icons.add_shopping_cart),
            label: Text(isInCart ? 'Remove from cart' : 'Add to cart'),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () => appState.toggleFavorite(product.id),
            icon: const Icon(Icons.favorite_outline),
            label: const Text('Save to favorites'),
          ),
        ],
      ),
    );
  }
}
