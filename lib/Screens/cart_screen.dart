import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item.dart';

import '../providers/cart.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItems = cart.items;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total'),
                  const Spacer(),
                  Chip(
                      backgroundColor: Theme.of(context).primaryColor,
                      label: Text(
                        '\$${cart.totalPrice}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      )),
                  TextButton(
                    onPressed: () {
                      Provider.of<Orders>(context,listen: false).addOrder(cart.items.values.toList(), cart.totalPrice);
                      cart.clearCart();
                    },
                    child: const Text(
                      'Order Now!',
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (ctx, index) => CartItems(
                  cartItems.values.toList()[index],
                  cartItems.keys.toList()[index]),
            ),
          ),
        ],
      ),
    );
  }
}
