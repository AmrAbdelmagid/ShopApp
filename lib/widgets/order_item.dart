import 'package:flutter/material.dart';
import 'package:untitled1/providers/orders_provider.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatelessWidget {
  final ord.OrderItem order;

  OrderItem({@required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${order.amount}'),
            subtitle:
                Text(DateFormat('dd/MM/yyyy hh:mm').format(order.dateTime)),
            trailing: IconButton(
              icon: Icon(
                Icons.expand_more,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
