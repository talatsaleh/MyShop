import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/Screens/edit_product_screen.dart';

import '../providers/products.dart';

import '../widgets/appDrawer.dart';
import '../widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product-screen';
  const UserProductScreen({Key? key}) : super(key: key);

  Future<void> _refresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetData();
  }
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('My Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productData.items.length,
            itemBuilder: (_, index) =>
                Column(
                  children: [
                    UserProductItem(product: productData.items[index]),
                    const Divider(),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
