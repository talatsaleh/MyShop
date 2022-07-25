import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.price,
      this.isFavorite = false});

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}

class Products with ChangeNotifier {
  final url = Uri.parse(
      'https://flutter-tutorial-be86e-default-rtdb.europe-west1.firebasedatabase.app/products.json');
  List<Product> _items = [];

  //   Product(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 29.99,
  //     imageUrl:
  //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Trousers',
  //     description: 'A nice pair of trousers.',
  //     price: 59.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'Yellow Scarf',
  //     description: 'Warm and cozy - exactly what you need for the winter.',
  //     price: 19.99,
  //     imageUrl:
  //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'A Pan',
  //     description: 'Prepare any meal you want.',
  //     price: 49.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  //   ),
  // ]; //dummy data
  Future<void> fetchAndSetData() async {
    ;
    try {
      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      List<Product> loadedData = [];
      extractData.forEach((prodId, prodData) {
        loadedData.add(
          Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              imageUrl: prodData['imageUrl'],
              price: prodData['price'],
              isFavorite: prodData['isFavorite']),
        );
      });
      _items = loadedData;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoritesItems {
    return _items.where((product) => product.isFavorite == true).toList();
  }

  Product findProduct(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(Product addedProduct) async {
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': addedProduct.title,
            'description': addedProduct.description,
            'imageUrl': addedProduct.imageUrl,
            'price': addedProduct.price,
            'isFavorite': addedProduct.isFavorite
          }));
      final product = Product(
          id: jsonDecode(response.body)['name'],
          title: addedProduct.title,
          description: addedProduct.description,
          imageUrl: addedProduct.imageUrl,
          price: addedProduct.price);
      _items.insert(0, product);
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> updateProduct(Product newProduct) async {
    final updateUrl = Uri.parse(
        'https://flutter-tutorial-be86e-default-rtdb.europe-west1.firebasedatabase.app/products/${newProduct.id}.json');
    try {
      await http.patch(updateUrl,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      int ind = _items.indexWhere((prod) => prod.id == newProduct.id);
      _items[ind] = newProduct;
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final updateUrl = Uri.parse(
        'https://flutter-tutorial-be86e-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');
    final excitingProdIndex = _items.indexWhere((product) => product.id == id);
    Product? excitingProd = _items[excitingProdIndex];
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
    print('deleted');
    final response = await http.delete(updateUrl);
    if (response.statusCode >= 400) {
        _items.insert(excitingProdIndex, excitingProd);
        print('un deleting');
        notifyListeners();
        throw const HttpException('deleting has failed..');
    }
    excitingProd = null;
  }
}
