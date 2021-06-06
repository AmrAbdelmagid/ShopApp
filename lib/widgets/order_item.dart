import 'dart:math';

import 'package:flutter/material.dart';
import 'package:untitled1/providers/orders_provider.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem({@required this.order});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(
                Icons.expand_more,
              ),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
            AnimatedContainer(
              curve: Curves.easeIn,
              duration: Duration(milliseconds: 300),
              height: _expanded ? min(widget.order.products.length * 20.0 + 10, 100) : 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                //height: min(widget.order.products.length * 20.0 + 10, 100),
                child: ListView(
                  children: widget.order.products
                      .map(
                        (prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${prod.title}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('\$${prod.price} x  ${prod.quantity}')
                          ],
                        ),
                      ) // map function
                      .toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
