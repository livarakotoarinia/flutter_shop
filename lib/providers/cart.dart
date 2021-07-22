import 'package:flutter/widgets.dart';

class CartItem {
  final String id;
  final String title;
  final int qty;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.qty,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem>? _items = {};

  Map<String, CartItem> get items {
    return {..._items!};
  }

  int get itemCount {
    return _items!.length;
  }

  double get totalAmount {
    double total = 0;
    _items!.forEach((key, cartItem) {
      total += cartItem.price * cartItem.qty;
    });
    return total;
  }

  void addItem(String id, String title, double price) {
    if (_items!.containsKey(id)) {
      _items!.update(
        id,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          qty: existingCartItem.qty + 1,
        ),
      );
    } else {
      _items!.putIfAbsent(
        id,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          qty: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items!.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items!.containsKey(id)) {
      return;
    }
    if (_items![id]!.qty > 1)
      _items!.update(
        id,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          qty: existingCartItem.qty - 1,
          price: existingCartItem.price,
        ),
      );
    else
      _items!.remove(id);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
