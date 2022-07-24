import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screens/cart_screen.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/widgets/appDrawer.dart';
import 'package:shop_app/widgets/badge.dart';
import '../providers/products.dart';
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
  var _isInit = true;
  var _isLoading = false;

  @override
  initState() {
    // Future.delayed(Duration.zero)
    //     .then((_) => Provider.of<Products>(context).fetchAndSetData());
    super.initState();
  }

  @override
  didChangeDependencies() {
    if (_isInit) {
      _isLoading = true;
      Provider.of<Products>(context).fetchAndSetData().then((_) {
        _isLoading = false;
      });
      _isInit = false;
    }

    super.didChangeDependencies();
  }

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
                      icon: const Icon(Icons.shopping_cart))))
        ],
        title: const Text('MyShop'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavoritesData),
    );
  }
}
