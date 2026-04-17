import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/state/app_scope.dart';
import '../../shared/widgets/product_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final items = appState.favoriteProducts;
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: items.isEmpty
          ? const Center(child: Text('No favorites yet. Save some products from details page.'))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (BuildContext context, int index) {
                final item = items[index];
                return ProductCard(
                  product: item,
                  onTap: () => context.pushNamed(
                    'product-details',
                    pathParameters: <String, String>{'productId': item.id},
                  ),
                );
              },
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (int index) {
          if (index == 0) {
            context.goNamed('catalog');
          } else if (index == 2) {
            context.goNamed('cart');
          } else if (index == 3) {
            context.goNamed('profile');
          }
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Shop',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
