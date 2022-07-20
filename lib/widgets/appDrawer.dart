import 'package:flutter/material.dart';

import '../Screens/orders_screen.dart';
import '../Screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  Widget listTileBuilder(
      {required String title,
      required IconData icons,
      required Function() onPressed,
      required BuildContext context}) {
    Color primColor = Theme.of(context).primaryColor;
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: primColor),
      ),
      leading: Icon(
        icons,
        color: primColor,
      ),
      onTap: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: const Text('Hello Fake User'),
          automaticallyImplyLeading: false,
        ),
        listTileBuilder(
            title: 'Shop',
            icons: Icons.shop,
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
            context: context),
        const Divider(),
        listTileBuilder(
            title: 'My Orders',
            icons: Icons.payment,
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
            context: context),
        const Divider(),
        listTileBuilder(
            title: 'Manage Products',
            icons: Icons.edit,
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
            },
            context: context)
      ]),
    );
  }
}
