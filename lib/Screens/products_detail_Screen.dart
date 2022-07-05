import 'package:flutter/material.dart';
import 'package:shop_app/models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)?.settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),

    );
  }
}
