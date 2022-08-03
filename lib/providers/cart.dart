
import 'package:flutter/material.dart';
import '../providers/products.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
          product.id,
              (existingCartItem) =>
              CartItem(
                  id: existingCartItem.id,
                  title: existingCartItem.title,
                  price: existingCartItem.price,
                  quantity: existingCartItem.quantity + 1));
    } else {
      _items.putIfAbsent(
          product.id,
              () =>
              CartItem(
                  id: DateTime.now().toString(),
                  title: product.title,
                  price: product.price,
                  quantity: 1));
    }
    notifyListeners();
  }

  double get totalPrice {
    double total = 0;
    _items.forEach((_, cart) {
      total += (cart.quantity * cart.price);
    });
    total.toStringAsFixed(2);
    return total.toDouble();
  }

  int get itemsCount {
    int count = 0;
    _items.forEach((_, cart) {
      count += cart.quantity;
    });
    return count;
  }

  void removeSingleProduct(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
            (oldProduct) =>
            CartItem(
                id: oldProduct.id,
                title: oldProduct.title,
                price: oldProduct.price,
                quantity: oldProduct.quantity - 1),
      );
    } else {
      (_items).remove(productId);
    }
    notifyListeners();
  }

  void removeProduct(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
