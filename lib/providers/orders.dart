import 'package:flutter/widgets.dart';
import 'package:shop/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.datetime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    var url = Uri.https(
        'flutter-shop-bc919-default-rtdb.europe-west1.firebasedatabase.app',
        '/orders.json');
    var dateTime = DateTime.now();

    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': dateTime.toIso8601String(),
        'products': cartProducts
            .map((e) => {
                  'id': e.id,
                  'title': e.title,
                  'qty': e.qty,
                  'price': e.price,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        datetime: dateTime,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    var url = Uri.parse(
        'https://flutter-shop-bc919-default-rtdb.europe-west1.firebasedatabase.app/orders.json');
    final response = await http.get(url);
    final List<OrderItem> loadedOrder = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>?;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrder.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  qty: item['qty'],
                  price: item['price'],
                ),
              )
              .toList(),
          datetime: DateTime.parse(orderData['dateTime']),
        ),
      );
    });
    _orders = loadedOrder.reversed.toList();
    notifyListeners();
  }
}
