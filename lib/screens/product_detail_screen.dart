import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget{
  static const routeName = '/product-detail-screen';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute
        .of(context)
        .settings
        .arguments as String;
    final loadedProduct = Provider.of<ProductsProvider>(context, listen: false)
        .findById(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: Center(
        child: CustomScrollView(slivers: [
          SliverAppBar(
            //TODO handle your custom sliver appbar
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10),
                Text(
                  '\$${loadedProduct.price}', textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 20.0),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  '${loadedProduct.description}',
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 800,)
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }
}
