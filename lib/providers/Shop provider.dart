import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/model/Items.dart';


class ShopProvider extends ChangeNotifier {
  List<items> _products = [];
  List<CartItem> _cartItems = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<items> get products => _products;
  List<CartItem> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get cartCount =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _cartItems.fold(
      0.0, (sum, item) => sum + (item.product.price ?? 0) * item.quantity);

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://www.jsonkeeper.com/b/QXODW'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _products = data.map((json) => items.fromJson(json)).toList();
      } else {
        _errorMessage = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  void addToCart(items product) {
    final index =
    _cartItems.indexWhere((i) => i.product.id == product.id);
    if (index != -1) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeOneFromCart(items product) {
    final index =
    _cartItems.indexWhere((i) => i.product.id == product.id);
    if (index != -1) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _cartItems.removeAt(index);
      }
    }
    notifyListeners();
  }

  void deleteFromCart(items product) {
    _cartItems.removeWhere((i) => i.product.id == product.id);
    notifyListeners();
  }

  int getQuantityInCart(int? productId) {
    if (productId == null) return 0;
    try {
      return _cartItems
          .firstWhere((i) => i.product.id == productId)
          .quantity;
    } catch (_) {
      return 0;
    }
  }
}