import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({this.id, this.title, this.quantity, this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    // _items.forEach((f, c) => print(c.id +
    //     ' ' +
    //     c.price.toString() +
    //     ' ' +
    //     c.quantity.toString() +
    //     ' ' +
    //     c.title));
    print("Items was Accessed");
    return {..._items};
  }

  int get itemCount {
    return _items == null ? 0 : _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach(
        (f, cartItem) => total = total + cartItem.price * cartItem.quantity);
    return total;
  }

  void addItem(String pId, double price, String title) {
    if (_items.containsKey(pId)) {
      _items.update(
          pId,
          (existing) => CartItem(
              id: existing.id,
              price: existing.price * existing.quantity,
              quantity: existing.quantity + 1,
              title: existing.title));
    } else {
      _items.putIfAbsent(
          pId,
          () => CartItem(
              id: UniqueKey().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }
}
