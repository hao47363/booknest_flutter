import 'package:flutter/material.dart';

import '../../core/models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.isFavorite = false,
    this.isInCart = false,
  });

  final Product product;
  final VoidCallback onTap;
  final bool isFavorite;
  final bool isInCart;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Hero(
                tag: product.id,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Container(
                      height: 96,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: colors.secondaryContainer,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          return Icon(
                            Icons.shopping_bag_outlined,
                            size: 36,
                            color: colors.onSecondaryContainer,
                          );
                        },
                      ),
                    ),
                    if (isFavorite || isInCart)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            if (isFavorite)
                              Tooltip(
                                message: 'In favorites',
                                child: Material(
                                  color: colors.errorContainer.withValues(alpha: 0.92),
                                  shape: const CircleBorder(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.favorite,
                                      size: 16,
                                      color: colors.onErrorContainer,
                                    ),
                                  ),
                                ),
                              ),
                            if (isFavorite && isInCart) const SizedBox(width: 4),
                            if (isInCart)
                              Tooltip(
                                message: 'In cart',
                                child: Material(
                                  color: colors.primaryContainer.withValues(alpha: 0.92),
                                  shape: const CircleBorder(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.shopping_cart,
                                      size: 16,
                                      color: colors.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                product.category.toUpperCase(),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colors.primary,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                product.name,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Text(
                    product.priceLabel,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const Spacer(),
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(product.rating.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
