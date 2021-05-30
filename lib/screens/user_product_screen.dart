import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/providers/products_provider.dart';
import 'package:untitled1/screens/edit_product_screen.dart';
import 'package:untitled1/widgets/app_drawer.dart';
import 'package:untitled1/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).pushNamed(EditProductScreen.routeName);
          }, icon: Icon(Icons.add)),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Consumer<ProductsProvider>(
          builder: (_, productData, ch) => ListView.builder(
            itemBuilder: (_, i) => UserProductItem(
              id: productData.items[i].id,
              title: productData.items[i].title,
              url: productData.items[i].imageUrl,
            ),
            itemCount: productData.items.length,
          ),
        ),
      ),
    );
  }
}
