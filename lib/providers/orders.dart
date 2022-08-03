import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/providers/products.dart';
import '../providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  final String authToken;
  final String userId;

  Orders(this.authToken,this.userId, this._items);

  List<OrderItem> _items = [];

  List<OrderItem> get items {
    return [..._items];
  }

  Future<void> fetchAndSetOrders() async {
    // String userOnlyData = userOnly ? '&orderBy="creatorId"&equalTo=$user'
    final url = Uri.parse(
        'https://flutter-tutorial-be86e-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    final response = await http.get(url);
    List<OrderItem> loadedOrders = [];
    final extractedOrders = json.decode(response.body) as Map<String, dynamic>;
    if (extractedOrders == null) {
      return;
    }
    extractedOrders.forEach(
      (orderKey, orderData) {
        loadedOrders.add(OrderItem(
            id: orderKey,
            amount: orderData['amount'],
            products: (orderData['products'] as List<dynamic>)
                .map((product) => CartItem(
                    title: product['title'],
                    id: product['id'],
                    price: product['price'],
                    quantity: product['quantity']))
                .toList(),
            dateTime: DateTime.parse(orderData['dateTime'])));
      },
    );
    _items = loadedOrders;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> products, double total) async {
    final time = DateTime.now();
    final url = Uri.parse(
        'https://flutter-tutorial-be86e-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    try {
      final response = await http.post(url,
          body: jsonEncode({
            'amount': total,
            'products': products
                .map((prod) => {
                      'id': prod.id,
                      'quantity': prod.quantity,
                      'price': prod.price,
                      'title': prod.title,
                    })
                .toList(),
            'dateTime': time.toIso8601String(),
          }));
      _items.insert(
          0,
          OrderItem(
              id: jsonDecode(response.body)['name'],
              amount: total,
              products: products,
              dateTime: time));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
//   List<CartItem> _getProducts(Map<String, Map<String, dynamic>> added){
//     List<CartItem> cart = [];
//     added.forEach((prodId, prodData) {
//       cart.add(CartItem(id: prodId, title: title, price: price, quantity: quantity))
//     });
//     return cart;
// }
//   Future<void> fetchAndSetData() async {
//     final url = Uri.parse('https://flutter-tutorial-be86e-default-rtdb.europe-west1.firebasedatabase.app/orders/.json');
//     try {
//       final response = await http.get(url);
//       final extractData = json.decode(response.body) as Map<String, dynamic>;
//       List<OrderItem> loadedData = [];
//       extractData.forEach((orderId, orderData) {
//         loadedData.add(
//           OrderItem(
//               id: orderId,
//               amount: orderData['amount'],
//               dateTime: DateTime.parse(orderData['dateTime'] as String),
//               products: () {
//                 return 'sd';
//               }
//           ),
//         );
//       });
//       _items = loadedData;
//       notifyListeners();
//     } catch (error) {
//       rethrow;
//     }
//   } // that was my attempt to add cart into server but not very effective
}
