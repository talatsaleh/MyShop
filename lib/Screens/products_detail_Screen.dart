import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final product = Provider.of<Products>(context).findProduct(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Column(
        children: [
          Container(
            height: 290,
            width: double.infinity,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                        padding: EdgeInsets.all(5),
                        child: Text(product.description)),
                  ),
                  Expanded(
                    child: Container(
                      height: 90,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(5),
                      child: Text(
                        '\$${product.price}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 4),
            child: ElevatedButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.all(10))),
              onPressed: () {},
              child: Container(width: double.infinity,alignment: Alignment.center, child: Text('Add To cart!')),
            ),
          )
        ],
      ),
    );
  }
}
