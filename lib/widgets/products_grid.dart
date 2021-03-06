import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/providers/products_provider.dart';
import 'package:untitled1/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final favoritesFlag;
  ProductsGrid(this.favoritesFlag);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = favoritesFlag ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(
          // id: products[i].id,
          // title: products[i].title,
          // imageUrl: products[i].imageUrl,
        ),
      ),
      itemCount: products.length,
    );
  }
}
