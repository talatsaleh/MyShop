import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';

import '../Screens/products_detail_Screen.dart';
import '../providers/products.dart';
import '../providers/cart.dart';

class ProductItem extends StatefulWidget {
  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  Widget iconBuilder(IconData icon, Function()? pressed, BuildContext ctx) {
    return IconButton(
      color: Theme.of(ctx).accentColor,
      icon: Icon(icon),
      onPressed: pressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context,listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => iconBuilder(
                product.isFavorite == false
                    ? Icons.favorite_border_outlined
                    : Icons.favorite,
                () => product.toggleFavorite(auth.token!,auth.userId!),
                context),
          ),
          trailing: iconBuilder(Icons.shopping_cart, () {
            cart.addItem(product);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('you add item to cart!'),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cart.removeSingleProduct(product.id);
                  },
                ),
              ),
            );
          }, context),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(product.imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
