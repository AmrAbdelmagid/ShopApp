import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/providers/products_provider.dart';
import 'package:untitled1/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String url;

  UserProductItem({
    @required this.id,
    @required this.title,
    @required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(url),
      ),
      trailing: Container(
        width: MediaQuery.of(context).size.width * 0.27,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, EditProductScreen.routeName,
                    arguments: id);
              },
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<ProductsProvider>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  //print(error);
                  scaffoldMessenger.showSnackBar(SnackBar(
                    content: Text(
                      'Could not delete Product!',
                      style: TextStyle(color: Colors.red),
                    ),
                    duration: Duration(seconds: 2),
                  ));
                }
              },
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
