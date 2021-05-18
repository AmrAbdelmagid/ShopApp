import 'package:flutter/material.dart';
import 'package:untitled1/widgets/products_grid.dart';
import '../widgets/product_item.dart';
import '../providers/product.dart';

class ProductOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Shop App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ProductsGrid(),
      ),
    );
  }
}
