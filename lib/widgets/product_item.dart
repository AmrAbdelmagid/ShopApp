import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/providers/cart.dart';
import 'package:untitled1/providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String imageUrl;
  // final String id;
  // final String title;
  // ProductItem({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<CartProvider>(context,listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product.id,
          );
        },
        child: GridTile(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            title: Text(product.title, textAlign: TextAlign.center),
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              builder: (ctx, product,_) => IconButton( // _ refers to the child which I do not need it here!
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  product.toggleFavoriteStatue();
                },
                color: Theme.of(context).accentColor,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(productId: product.id,title: product.title,price: product.price);
              },
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
