import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/providers/orders_provider.dart' show OrdersProvider ;
import 'package:untitled1/widgets/app_drawer.dart';
import 'package:untitled1/widgets/order_item.dart' ;

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrdersProvider>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (_, i) => OrderItem(order: orderData.orders[i],),
      ),
    );
  }
}
