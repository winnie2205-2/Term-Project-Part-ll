import 'package:flutter/material.dart';
import '../models/product.dart';

class ShoppingCartModel with ChangeNotifier {
  List<ProductElement> _cartItems = [];

  List<ProductElement> get cartItems => _cartItems;

  void addProductToCart(ProductElement product) {
    if (!_cartItems.any((item) => item.id == product.id)) {
      _cartItems.add(product);
      notifyListeners();
    }
  }

  void removeProductFromCart(ProductElement product) {
    _cartItems.removeWhere((item) => item.id == product.id);
    notifyListeners();
  }
}
