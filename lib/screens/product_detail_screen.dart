import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;
  // ProductDetailScreen({this.title,this.price});
  static const routeName = '/product-screen';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<ProductsProvider>(context, listen: false)
        .findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            '\$${loadedProduct.price}',
            style: TextStyle(color: Colors.grey, fontSize: 20.0),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            '${loadedProduct.description}',
            softWrap: true,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
