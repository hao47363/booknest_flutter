import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/product.dart';
import '../../core/state/app_scope.dart';
import '../../shared/widgets/product_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _query = '';
  String _selectedCategory = 'All';
  String _sortKey = 'name';

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final Set<String> categories = <String>{'All', ...appState.products.map((e) => e.category)};
    final List<Product> products = appState.products.where((product) {
      final bool matchesQuery = product.name.toLowerCase().contains(_query.toLowerCase()) ||
          product.category.toLowerCase().contains(_query.toLowerCase());
      final bool matchesCategory = _selectedCategory == 'All' || product.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();
    products.sort((a, b) {
      switch (_sortKey) {
        case 'price':
          return a.price.compareTo(b.price);
        case 'rating':
          return b.rating.compareTo(a.rating);
        default:
          return a.name.compareTo(b.name);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('BookNest'),
        actions: <Widget>[
          IconButton(
            onPressed: () => context.pushNamed('orders'),
            icon: const Icon(Icons.receipt_long),
            tooltip: 'Orders',
          ),
          IconButton(
            onPressed: () => context.pushNamed('product-manage'),
            icon: const Icon(Icons.edit_note),
            tooltip: 'Manage products',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(
            'Featured products',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'A static catalog flow for UI and navigation demos.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search products',
            ),
            onChanged: (String value) => setState(() => _query = value),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories
                .map(
                  (String category) => ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (_) => setState(() => _selectedCategory = category),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: ValueKey<String>(_sortKey),
            initialValue: _sortKey,
            decoration: const InputDecoration(labelText: 'Sort by'),
            items: const <DropdownMenuItem<String>>[
              DropdownMenuItem<String>(value: 'name', child: Text('Name (A-Z)')),
              DropdownMenuItem<String>(value: 'price', child: Text('Price (Low to High)')),
              DropdownMenuItem<String>(value: 'rating', child: Text('Rating (High to Low)')),
            ],
            onChanged: (String? value) {
              if (value != null) {
                setState(() => _sortKey = value);
              }
            },
          ),
          const SizedBox(height: 16),
          GridView.builder(
            itemCount: products.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (BuildContext context, int index) {
              final product = products[index];
              return ProductCard(
                product: product,
                isFavorite: appState.isFavorite(product.id),
                isInCart: appState.isInCart(product.id),
                onTap: () => context.pushNamed(
                  'product-details',
                  pathParameters: <String, String>{'productId': product.id},
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (int index) {
          if (index == 1) {
            context.goNamed('favorites');
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
