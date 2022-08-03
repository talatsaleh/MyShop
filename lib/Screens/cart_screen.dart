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
        title: const Text('My Cart'),
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
                    backgroundColor: Theme
                        .of(context)
                        .primaryColor,
                    label: Text(
                      '\$${cart.totalPrice}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  OrderButton(cart),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (ctx, index) =>
                  CartItems(
                      cartItems.values.toList()[index],
                      cartItems.keys.toList()[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final Cart cart;

  const OrderButton(this.cart, {Key? key}) : super(key: key);

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isDisable = false;
  bool _isLoading = false;

  @override
  void initState() {
    if (widget.cart.items.isEmpty) {
      _isDisable = true;
    }
    super.initState();
  }

  void _isLoadingButton() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? const CircularProgressIndicator() : TextButton(
      onPressed: _isDisable
          ? null
          : () async {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Orders>(context, listen: false).addOrder(
            widget.cart.items.values.toList(), widget.cart.totalPrice);
        widget.cart.clearCart();
        setState(() {
          _isLoading = false;
          _isDisable == true;
        });
      },
      child: const Text(
        'Order Now!',
      ),
    );
  }
}
