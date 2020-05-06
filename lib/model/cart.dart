import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String brand;
  final String menuType;
  CartItem(
      {this.id,
      this.title,
      this.quantity,
      this.price,
      this.brand,
      this.menuType});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    print("Items was Accessed");
    return {..._items};
  }

  int get itemCount {
    return _items == null ? 0 : _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((f, cartItem) => total = total + cartItem.price);
    return total;
  }

  void addItem(
      String pId, double price, String title, String brand, String menuType) {
    if (_items.containsKey(pId)) {
      _items.update(
          pId,
          (existing) => CartItem(
              id: existing.id,
              price: existing.price * existing.quantity,
              quantity: existing.quantity + 1,
              title: existing.title,
              brand: existing.brand,
              menuType: existing.menuType));
    } else {
      _items.putIfAbsent(
          pId,
          () => CartItem(
              id: UniqueKey().toString(),
              title: title,
              price: price,
              quantity: 1,
              brand: brand,
              menuType: menuType));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }
}
