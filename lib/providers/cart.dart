import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity,
  });
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }
  int get itemCount {
    return _items.length;
}

  void addItem({String productId, String title, double price, int quantity}) {
    _items.update(
      productId,
      (existingCartItem) => CartItem(
        id: existingCartItem.id,
        title: existingCartItem.title,
        price: existingCartItem.price,
        quantity: existingCartItem.quantity + 1,
      ),
      ifAbsent: () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1),
    );
    notifyListeners();
  }
}
