import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';

import '../Screens/orders_screen.dart';

class DrawerBuilder extends StatefulWidget {
  static bool interO = false;

  static void interOrder() {
    interO = !interO;
  }

  bool interD = true;

  void interDrawer() {
    interD = !interD;
  }

  @override
  State<DrawerBuilder> createState() => _DrawerBuilderState();
}

class _DrawerBuilderState extends State<DrawerBuilder> {
  @override
  Widget build(BuildContext context) {
    Widget optionBuilder(IconData icon, String title, Function() goTo) {
      return TextButton(
        onPressed: goTo,
        child: ListTile(
            leading: Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
            trailing: Consumer<Orders>(
              builder: (_, order, _2) => SizedBox(
                height: 30,
                child: order.items.length != 0 &&
                        widget.interD &&
                        DrawerBuilder.interO
                    ? FittedBox(
                        child: Chip(
                          label: Text(
                            order.items.length.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w200,
                              fontSize: 18,
                            ),
                          ),
                          backgroundColor: Theme.of(context).errorColor,
                        ),
                      )
                    : null,
              ),
            ),
            title: Text(title)),
      );
    }

    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          ListTile(
            leading: CircleAvatar(
              child: Text(
                'F',
                style: TextStyle(fontSize: 25),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Fake User',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          optionBuilder(Icons.shopping_cart_checkout, 'My Orders', () {
            setState(() {
              if (widget.interD == false && DrawerBuilder.interO == true) {
              } else {
                widget.interDrawer();
              }
            });
            Navigator.of(context).pushNamed(OrdersScreen.routeName);
          })
        ],
      ),
    );
  }
}
