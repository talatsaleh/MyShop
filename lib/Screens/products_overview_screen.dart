import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screens/cart_screen.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/widgets/appdrawer.dart';
import 'package:shop_app/widgets/badge.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  showFavorites,
  showAll,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavoritesData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selected) {
              if (selected == FilterOptions.showFavorites) {
                setState(() {
                  _showOnlyFavoritesData = true;
                });
              }
              if (selected == FilterOptions.showAll) {
                setState(() {
                  _showOnlyFavoritesData = false;
                });
              }
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.showFavorites,
                child: Text('Show Favorites'),
              ),
              const PopupMenuItem(
                value: FilterOptions.showAll,
                child: Text('Show All'),
              )
            ],
          ),
          Consumer<Cart>(
              builder: (_, cart, _2) => Badge(
                  value: cart.itemsCount.toString(),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(CartScreen.routeName);
                      },
                      icon: Icon(Icons.shopping_cart))))
        ],
        title: const Text('MyShop'),
      ),
      body: ProductsGrid(_showOnlyFavoritesData),
    );
  }
}
