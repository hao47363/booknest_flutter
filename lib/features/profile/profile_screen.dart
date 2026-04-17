import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/state/app_scope.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final user = appState.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Demo profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: user == null ? null : AssetImage(user.avatarUrl),
                child: user == null ? const Icon(Icons.person) : null,
              ),
              title: Text(user?.name ?? 'Unknown user'),
              subtitle: Text(user?.bio ?? ''),
              trailing: FilledButton.tonal(
                onPressed: () => context.pushNamed('edit-profile'),
                child: const Text('Edit'),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.notifications_none),
                  title: const Text('Notifications'),
                  subtitle: const Text('Enabled for demo'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.palette_outlined),
                  title: const Text('Theme'),
                  subtitle: const Text('Follows system'),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.warning_amber_outlined),
                  title: const Text('Mock API error mode'),
                  subtitle: const Text('For demoing failure states in async operations.'),
                  value: appState.simulateApiErrors,
                  onChanged: (bool enabled) => appState.setSimulateApiErrors(enabled),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Build'),
                  subtitle: Text('BookNest v2.1 (local DB + onboarding + cart)'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () async {
              await appState.logout();
              if (context.mounted) {
                context.goNamed('login');
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 3,
        onDestinationSelected: (int index) {
          if (index == 0) {
            context.goNamed('catalog');
          } else if (index == 1) {
            context.goNamed('favorites');
          } else if (index == 2) {
            context.goNamed('cart');
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
