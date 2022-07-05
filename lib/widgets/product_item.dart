import 'package:flutter/material.dart';
import 'package:shop_app/Screens/products_detail_Screen.dart';
import 'package:shop_app/models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem(this.product);

  Widget iconBuilder(IconData icon, Function() pressed, BuildContext ctx) {
    return IconButton(
      color: Theme.of(ctx).accentColor,
      icon: Icon(icon),
      onPressed: pressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black87,
          leading: iconBuilder(Icons.favorite, () => null, context),
          trailing: iconBuilder(Icons.shopping_cart, () => null, context),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product);
          },
          child: Image.network(product.imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
