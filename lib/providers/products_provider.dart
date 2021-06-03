import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:untitled1/models/http_exeption.dart';
import 'package:untitled1/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductsProvider with ChangeNotifier {
  final _url = Uri.parse(
      'https://max-shop-app-c690c-default-rtdb.firebaseio.com/products.json');

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var _showFavoritesOnly = false;

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prod) => prod.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  // void showFavorites() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }
  //
  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProduct() async {
    try {
      final response = await http.get(_url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProduct = [];
      extractedData.forEach((prodId, prodData) {
        loadedProduct.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: prodData['isFavourite'],
        ));
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(_url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'isFavourite': product.isFavorite,
          }));
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final editedProductIndex = _items.indexWhere((element) => element.id == id);
    try {
      final url = Uri.parse(
          'https://max-shop-app-c690c-default-rtdb.firebaseio.com/products/$id.json');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[editedProductIndex] = newProduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProductFavoriteStatus(
      String id, Product editedProductFavStatus) async {
    final editedProductIndex = _items.indexWhere((element) => element.id == id);
    try {
      final url = Uri.parse(
          'https://max-shop-app-c690c-default-rtdb.firebaseio.com/products/$id.json');
      await http.patch(url,
          body: json.encode({
            'isFavourite': editedProductFavStatus.isFavorite,
          }));
      _items[editedProductIndex] = editedProductFavStatus;
      notifyListeners();
    } catch (error) {
      editedProductFavStatus.toggleFavoriteStatue();
      throw HttpException('Could not change favourite status!');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://max-shop-app-c690c-default-rtdb.firebaseio.com/products/$id.json');
    final deletedProdIndex = _items.indexWhere((element) => element.id == id);
    Product referenceProd = _items[deletedProdIndex];
    _items.removeAt(deletedProdIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(deletedProdIndex, referenceProd);
      notifyListeners();
      throw HttpException('Could not delete the Product');
    }
    referenceProd = null;
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
