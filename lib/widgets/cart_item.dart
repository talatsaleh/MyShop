import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItems extends StatelessWidget {
  final String id;
  final CartItem cart;

  const CartItems(this.cart, this.id);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        padding: const EdgeInsets.all(8),
        color: Theme
            .of(context)
            .errorColor,
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(context: context, builder: (ctx) =>
            AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Do you want to remove this item?'),
              actions: [
                TextButton(onPressed: () {
                  Navigator.of(context).pop(false);
                }, child: const Text('No')),
                TextButton(onPressed: () {
                  Navigator.of(context).pop(true);
                }, child: const Text('Yes'))
              ],
            ),);
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeProduct(id);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text('\$${cart.price}'),
            ),
            title: Text(cart.title),
            subtitle: Text('Total: \$${cart.price * cart.quantity}'),
            trailing: Chip(label: Text(cart.quantity.toString())),
          ),
        ),
      ),
    );
  }
}
