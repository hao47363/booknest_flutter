import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/state/app_scope.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: appState.orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (BuildContext context, int index) {
          final order = appState.orders[index];
          final createdAt = DateTime.parse(order.createdAtIso);
          return Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.inventory_2_outlined)),
              title: Text(order.productName),
              subtitle: Text(
                '${order.status} • ${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}',
              ),
              trailing: Text('\$${order.total.toStringAsFixed(0)}'),
            ),
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 2,
        onDestinationSelected: (int index) {
          if (index == 0) {
            context.goNamed('catalog');
          } else if (index == 1) {
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
