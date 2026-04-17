import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/state/app_scope.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Text('BookNest Demo', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          const Text('This onboarding is fully local and simulates first-run setup.'),
          const SizedBox(height: 24),
          const ListTile(
            leading: Icon(Icons.storage_outlined),
            title: Text('Local storage with Hive'),
            subtitle: Text('Products, profile, favorites, cart, and session are persisted.'),
          ),
          const ListTile(
            leading: Icon(Icons.bolt_outlined),
            title: Text('Mock API delays'),
            subtitle: Text('All CRUD and auth actions mimic network latency.'),
          ),
          const ListTile(
            leading: Icon(Icons.warning_amber_outlined),
            title: Text('Error simulation mode'),
            subtitle: Text('Toggle API failure mode from profile settings.'),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () async {
              await appState.completeOnboarding();
              if (context.mounted) {
                context.goNamed('login');
              }
            },
            child: const Text('Get started'),
          ),
        ],
      ),
    );
  }
}
