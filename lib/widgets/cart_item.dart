import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String mapKey;
  final String title;
  final double price;
  final int quantity;

  CartItem({this.id,this.mapKey, this.title, this.quantity, this.price});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete,color: Colors.white,size: 40,),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.all(12),
      ),
      onDismissed: (_){
        Provider.of<CartProvider>(context,listen: false).removeItem(mapKey);
      },
      direction: DismissDirection.endToStart,
      child: Card(
        margin: EdgeInsets.all(12),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: FittedBox(
                child: Text('$price'),
              ),
            ),
          ),
          title: Text('$title'),
          subtitle: Text('total: ${quantity * price}'),
          trailing: Text('x $quantity'),
        ),
      ),
    );
  }
}
