import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({this.id, this.title, this.quantity, this.price});

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
