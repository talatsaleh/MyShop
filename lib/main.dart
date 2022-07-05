import 'package:flutter/material.dart';
import 'package:shop_app/Screens/products_detail_Screen.dart';
import 'package:shop_app/Screens/products_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Shop',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.deepOrange,
        fontFamily: 'Lato'
      ),
      home: ProductsOverviewScreen(),
      routes: {
        ProductDetailScreen.routeName: (ctx) => ProductDetailScreen()
      },
    );
  }
}

