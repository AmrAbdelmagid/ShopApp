import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:untitled1/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class OrdersProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse(
        'https://max-shop-app-c690c-default-rtdb.firebaseio.com/orders.json');
    final response = await http.get(url);
    //print(json.decode(response.body));
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    List<OrderItem> loadedOrders = [];
    extractedData.forEach((ordId, ordData) {
      loadedOrders.add(
        OrderItem(
          id: ordId,
          amount: double.parse(ordData['amount'].toString()).toDouble(),
          dateTime: DateTime.parse(ordData['date-time']),
          products: (ordData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  price: double.parse(item['price'].toString()).toDouble(),
                  quantity: item['quantity'],
                ),
              )
              .toList(),
        ),
      );
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    });
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://max-shop-app-c690c-default-rtdb.firebaseio.com/orders.json');
    try {
      final timestamp = DateTime.now();
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'quantity': cp.quantity,
                      'title': cp.title,
                      'price': cp.price,
                    })
                .toList(),
            'date-time': timestamp.toIso8601String(),
          }));
      final newOrder = OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timestamp,
      );
      _orders.insert(0, newOrder);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
