import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/state/app_scope.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isCheckingOut = false;
  String? _error;

  Future<void> _checkout() async {
    final appState = AppScope.of(context);
    setState(() {
      _isCheckingOut = true;
      _error = null;
    });
    try {
      await appState.checkoutCart();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Checkout complete. Orders updated.')),
      );
      context.goNamed('orders');
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) {
        setState(() => _isCheckingOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final items = appState.cartProducts;
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          if (_error != null)
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: ListTile(
                leading: const Icon(Icons.error_outline),
                title: const Text('Checkout failed'),
                subtitle: Text(_error!),
              ),
            ),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 32),
              child: Center(child: Text('Your cart is empty. Add items from product details.')),
            )
          else
            ...items.map(
              (item) => Card(
                child: ListTile(
                  leading: CircleAvatar(backgroundImage: AssetImage(item.imageUrl)),
                  title: Text(item.name),
                  subtitle: Text(item.category),
                  trailing: Text(item.priceLabel),
                ),
              ),
            ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              title: const Text('Total'),
              trailing: Text('\$${appState.cartTotal.toStringAsFixed(0)}'),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: items.isEmpty || _isCheckingOut ? null : _checkout,
            icon: const Icon(Icons.payments_outlined),
            label: Text(_isCheckingOut ? 'Processing...' : 'Checkout'),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 2,
        onDestinationSelected: (int index) {
          if (index == 0) {
            context.goNamed('catalog');
          } else if (index == 1) {
            context.goNamed('favorites');
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
