import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/state/app_state.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/cart/cart_screen.dart';
import '../features/catalog/catalog_screen.dart';
import '../features/catalog/product_manage_screen.dart';
import '../features/catalog/product_details_screen.dart';
import '../features/favorites/favorites_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/orders/orders_screen.dart';
import '../features/profile/edit_profile_screen.dart';
import '../features/profile/profile_screen.dart';

GoRouter createRouter(AppState appState) => GoRouter(
  initialLocation: '/login',
  refreshListenable: appState,
  redirect: (BuildContext context, GoRouterState state) {
    final String location = state.matchedLocation;

    // First-run onboarding (must run before auth guard — otherwise /onboarding
    // is treated as "protected" and bounces with /login forever).
    if (!appState.isOnboardingCompleted && location != '/onboarding') {
      return '/onboarding';
    }
    if (appState.isOnboardingCompleted && location == '/onboarding') {
      return appState.isLoggedIn ? '/' : '/login';
    }

    final bool isAuthRoute = location == '/login' || location == '/register';
    final bool isPublicWhenLoggedOut =
        isAuthRoute || location == '/onboarding';

    if (!appState.isLoggedIn && !isPublicWhenLoggedOut) {
      return '/login';
    }
    if (appState.isLoggedIn && isAuthRoute) {
      return '/';
    }
    return null;
  },
  routes: <RouteBase>[
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (BuildContext context, GoRouterState state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (BuildContext context, GoRouterState state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (BuildContext context, GoRouterState state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/',
      name: 'catalog',
      builder: (BuildContext context, GoRouterState state) {
        return const CatalogScreen();
      },
    ),
    GoRoute(
      path: '/product/:productId',
      name: 'product-details',
      builder: (BuildContext context, GoRouterState state) {
        final String productId = state.pathParameters['productId'] ?? '';
        final product = appState.getProductById(productId);

        if (product == null) {
          return const _NotFoundScreen();
        }

        return ProductDetailsScreen(product: product);
      },
    ),
    GoRoute(
      path: '/favorites',
      name: 'favorites',
      builder: (BuildContext context, GoRouterState state) => const FavoritesScreen(),
    ),
    GoRoute(
      path: '/orders',
      name: 'orders',
      builder: (BuildContext context, GoRouterState state) => const OrdersScreen(),
    ),
    GoRoute(
      path: '/cart',
      name: 'cart',
      builder: (BuildContext context, GoRouterState state) => const CartScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (BuildContext context, GoRouterState state) {
        return const ProfileScreen();
      },
    ),
    GoRoute(
      path: '/profile/edit',
      name: 'edit-profile',
      builder: (BuildContext context, GoRouterState state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/products/manage',
      name: 'product-manage',
      builder: (BuildContext context, GoRouterState state) => const ProductManageScreen(),
    ),
  ],
);

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Not Found')),
      body: Center(
        child: FilledButton(
          onPressed: () => context.goNamed('catalog'),
          child: const Text('Back to Catalog'),
        ),
      ),
    );
  }
}
