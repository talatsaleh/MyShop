import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screens/cart_screen.dart';
import 'package:shop_app/widgets/appDrawer.dart';

import '../providers/orders.dart' show Orders;

import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders-screen';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? _ordersFuture;

  Future _obtainFutures() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainFutures();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: const Text('My Orders'),
        ),
        body: FutureBuilder(
          future: _ordersFuture,
          builder: (ctx, dataSnabshot) {
            if (dataSnabshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (dataSnabshot.connectionState == ConnectionState.done) {
              return Consumer<Orders>(
                builder: (ctx, order, ch) {
                  return order.items.isEmpty
                      ? ch!
                      : ListView.builder(
                          itemCount: order.items.length,
                          itemBuilder: (ctx, index) =>
                              OrderItem(order.items[index]));
                },
                child: const Center(
                  child: Text('there is no order to see..'),
                ),
              );
            }
            if (dataSnabshot.hasError) {
              return const Center(
                child: Text('there is error'),
              );
            }
            return const Center(child: Text('problem'),);
          },
        ));
  }
}
