import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/mock_seed_data.dart';
import '../models/app_user.dart';
import '../models/order.dart';
import '../models/product.dart';

class AppState extends ChangeNotifier {
  AppState();

  static const String _productsBoxName = 'products_box';
  static const String _profileBoxName = 'profile_box';
  static const String _ordersBoxName = 'orders_box';
  static const String _sessionBoxName = 'session_box';

  bool _isReady = false;
  bool _isLoggedIn = false;
  bool _isOnboardingCompleted = false;
  bool _simulateApiErrors = false;

  List<Product> _products = <Product>[];
  List<MockOrder> _orders = <MockOrder>[];
  Set<String> _favoriteIds = <String>{};
  Set<String> _cartIds = <String>{};
  AppUser? _currentUser;

  bool get isReady => _isReady;
  bool get isLoggedIn => _isLoggedIn;
  bool get isOnboardingCompleted => _isOnboardingCompleted;
  bool get simulateApiErrors => _simulateApiErrors;
  List<Product> get products => _products;
  List<MockOrder> get orders => _orders;
  AppUser? get currentUser => _currentUser;
  List<Product> get favoriteProducts =>
      _products.where((Product item) => _favoriteIds.contains(item.id)).toList();
  List<Product> get cartProducts =>
      _products.where((Product item) => _cartIds.contains(item.id)).toList();
  double get cartTotal =>
      cartProducts.fold<double>(0, (double total, Product item) => total + item.price);

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<dynamic>(_productsBoxName);
    await Hive.openBox<dynamic>(_profileBoxName);
    await Hive.openBox<dynamic>(_ordersBoxName);
    await Hive.openBox<dynamic>(_sessionBoxName);
    await _seedIfNeeded();
    await _loadState();
    _isReady = true;
    notifyListeners();
  }

  Future<void> _seedIfNeeded() async {
    final Box<dynamic> productsBox = Hive.box<dynamic>(_productsBoxName);
    final Box<dynamic> profileBox = Hive.box<dynamic>(_profileBoxName);
    final Box<dynamic> ordersBox = Hive.box<dynamic>(_ordersBoxName);
    final Box<dynamic> sessionBox = Hive.box<dynamic>(_sessionBoxName);

    if (productsBox.isEmpty) {
      final List<Map<String, dynamic>> encoded =
          seedProducts.map((Product item) => item.toJson()).toList();
      await productsBox.put('items', encoded);
    }

    if (!profileBox.containsKey('user')) {
      await profileBox.put('user', seedUser.toJson());
    }

    if (!ordersBox.containsKey('items')) {
      final List<Map<String, dynamic>> encoded =
          seedOrders.map((MockOrder item) => item.toJson()).toList();
      await ordersBox.put('items', encoded);
    }

    if (!sessionBox.containsKey('favorites')) {
      await sessionBox.put('favorites', <String>[]);
    }
    if (!sessionBox.containsKey('loggedIn')) {
      await sessionBox.put('loggedIn', false);
    }
    if (!sessionBox.containsKey('onboardingCompleted')) {
      await sessionBox.put('onboardingCompleted', false);
    }
    if (!sessionBox.containsKey('simulateApiErrors')) {
      await sessionBox.put('simulateApiErrors', false);
    }
    if (!sessionBox.containsKey('cart')) {
      await sessionBox.put('cart', <String>[]);
    }
  }

  Future<void> _loadState() async {
    final Box<dynamic> productsBox = Hive.box<dynamic>(_productsBoxName);
    final Box<dynamic> profileBox = Hive.box<dynamic>(_profileBoxName);
    final Box<dynamic> ordersBox = Hive.box<dynamic>(_ordersBoxName);
    final Box<dynamic> sessionBox = Hive.box<dynamic>(_sessionBoxName);

    final List<dynamic> productRows = (productsBox.get('items') as List<dynamic>? ?? <dynamic>[]);
    _products = productRows
        .cast<Map<dynamic, dynamic>>()
        .map(Product.fromJson)
        .toList(growable: false);

    final Map<dynamic, dynamic> profileRow =
        (profileBox.get('user') as Map<dynamic, dynamic>?) ?? seedUser.toJson();
    _currentUser = AppUser.fromJson(profileRow);

    final List<dynamic> orderRows = (ordersBox.get('items') as List<dynamic>? ?? <dynamic>[]);
    _orders = orderRows
        .cast<Map<dynamic, dynamic>>()
        .map(MockOrder.fromJson)
        .toList(growable: false);

    final List<dynamic> favoriteRows =
        (sessionBox.get('favorites') as List<dynamic>? ?? <dynamic>[]);
    _favoriteIds = favoriteRows.cast<String>().toSet();
    final List<dynamic> cartRows = (sessionBox.get('cart') as List<dynamic>? ?? <dynamic>[]);
    _cartIds = cartRows.cast<String>().toSet();
    _isLoggedIn = sessionBox.get('loggedIn') as bool? ?? false;
    _isOnboardingCompleted = sessionBox.get('onboardingCompleted') as bool? ?? false;
    _simulateApiErrors = sessionBox.get('simulateApiErrors') as bool? ?? false;
  }

  Future<void> login({required String email, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    _throwIfApiErrorEnabled();
    _isLoggedIn = true;
    await Hive.box<dynamic>(_sessionBoxName).put('loggedIn', true);
    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    _throwIfApiErrorEnabled();
    _currentUser = AppUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      bio: 'New demo user account.',
      avatarUrl: seedUser.avatarUrl,
    );
    await Hive.box<dynamic>(_profileBoxName).put('user', _currentUser!.toJson());
    _isLoggedIn = true;
    await Hive.box<dynamic>(_sessionBoxName).put('loggedIn', true);
    notifyListeners();
  }

  Future<void> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _throwIfApiErrorEnabled();
    _isLoggedIn = false;
    await Hive.box<dynamic>(_sessionBoxName).put('loggedIn', false);
    notifyListeners();
  }

  Future<void> updateProfile({
    required String name,
    required String bio,
  }) async {
    if (_currentUser == null) {
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 700));
    _throwIfApiErrorEnabled();
    _currentUser = _currentUser!.copyWith(name: name, bio: bio);
    await Hive.box<dynamic>(_profileBoxName).put('user', _currentUser!.toJson());
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    await Future<void>.delayed(const Duration(milliseconds: 750));
    _throwIfApiErrorEnabled();
    _products = <Product>[product, ..._products];
    await _persistProducts();
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    await Future<void>.delayed(const Duration(milliseconds: 750));
    _throwIfApiErrorEnabled();
    _products = _products.map((Product item) {
      if (item.id == product.id) {
        return product;
      }
      return item;
    }).toList(growable: false);
    await _persistProducts();
    notifyListeners();
  }

  Future<void> deleteProduct(String productId) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    _throwIfApiErrorEnabled();
    _products = _products.where((Product item) => item.id != productId).toList(growable: false);
    _favoriteIds.remove(productId);
    await _persistProducts();
    await Hive.box<dynamic>(_sessionBoxName).put('favorites', _favoriteIds.toList());
    notifyListeners();
  }

  Future<void> toggleFavorite(String productId) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _throwIfApiErrorEnabled();
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    await Hive.box<dynamic>(_sessionBoxName).put('favorites', _favoriteIds.toList());
    notifyListeners();
  }

  Future<void> toggleCart(String productId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _throwIfApiErrorEnabled();
    if (_cartIds.contains(productId)) {
      _cartIds.remove(productId);
    } else {
      _cartIds.add(productId);
    }
    await Hive.box<dynamic>(_sessionBoxName).put('cart', _cartIds.toList());
    notifyListeners();
  }

  Future<void> checkoutCart() async {
    if (_cartIds.isEmpty) {
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    _throwIfApiErrorEnabled();
    final DateTime now = DateTime.now();
    final List<MockOrder> newOrders = <MockOrder>[];
    for (final Product product in cartProducts) {
      newOrders.add(
        MockOrder(
          id: 'order-${now.millisecondsSinceEpoch}-${product.id}',
          productId: product.id,
          productName: product.name,
          status: 'Processing',
          total: product.price,
          createdAtIso: now.toIso8601String(),
        ),
      );
    }
    _orders = <MockOrder>[...newOrders, ..._orders];
    _cartIds.clear();
    await Hive.box<dynamic>(_ordersBoxName)
        .put('items', _orders.map((MockOrder item) => item.toJson()).toList());
    await Hive.box<dynamic>(_sessionBoxName).put('cart', <String>[]);
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _isOnboardingCompleted = true;
    await Hive.box<dynamic>(_sessionBoxName).put('onboardingCompleted', true);
    notifyListeners();
  }

  Future<void> setSimulateApiErrors(bool enabled) async {
    _simulateApiErrors = enabled;
    await Hive.box<dynamic>(_sessionBoxName).put('simulateApiErrors', enabled);
    notifyListeners();
  }

  void _throwIfApiErrorEnabled() {
    if (_simulateApiErrors) {
      throw Exception('Mock API error mode is enabled.');
    }
  }

  Product? getProductById(String id) {
    for (final Product product in _products) {
      if (product.id == id) {
        return product;
      }
    }
    return null;
  }

  Future<void> _persistProducts() async {
    final List<Map<String, dynamic>> encoded =
        _products.map((Product item) => item.toJson()).toList();
    await Hive.box<dynamic>(_productsBoxName).put('items', encoded);
  }
}
