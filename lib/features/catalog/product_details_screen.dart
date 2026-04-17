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
    final bool isInCart = appState.isInCart(product.id);
    final bool isFavorite = appState.isFavorite(product.id);

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
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              if (isFavorite)
                Chip(
                  avatar: Icon(
                    Icons.favorite,
                    size: 18,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  label: const Text('In your favorites'),
                ),
              if (isInCart)
                Chip(
                  avatar: Icon(
                    Icons.shopping_cart,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: const Text('In your cart'),
                ),
              if (!isFavorite && !isInCart)
                Text(
                  'Not in cart or favorites yet',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
            ],
          ),
          const SizedBox(height: 8),
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
            onPressed: () async {
              await appState.toggleCart(product.id);
              if (!context.mounted) {
                return;
              }
              final bool nowInCart = appState.isInCart(product.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(nowInCart ? 'Added to cart' : 'Removed from cart'),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            icon: Icon(isInCart ? Icons.remove_shopping_cart_outlined : Icons.add_shopping_cart),
            label: Text(isInCart ? 'Remove from cart' : 'Add to cart'),
          ),
          const SizedBox(height: 8),
          FilledButton.tonalIcon(
            onPressed: () async {
              await appState.toggleFavorite(product.id);
              if (!context.mounted) {
                return;
              }
              final bool nowFavorite = appState.isFavorite(product.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(nowFavorite ? 'Saved to favorites' : 'Removed from favorites'),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Theme.of(context).colorScheme.error : null,
            ),
            label: Text(isFavorite ? 'Remove from favorites' : 'Save to favorites'),
          ),
        ],
      ),
    );
  }
}
