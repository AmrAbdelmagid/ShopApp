import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/providers/orders_provider.dart' show OrdersProvider;
import 'package:untitled1/widgets/app_drawer.dart';
import 'package:untitled1/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/Orders-Screen';
  // this approach is used if the widget needs to be stateful due to other state management operations that will lead to rebuild the widget many times,
  // and as the future has to be called once to get the data, so I just call the result of the future.
  // Future _ordersFuture;
  //
  // Future _obtainOrdersFuture() {
  //   return Provider.of<OrdersProvider>(context, listen: false).fetchOrders();
  // }
  // @override
  // void initState() {
  //   _ordersFuture = _obtainOrdersFuture();
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
        future:
            // _ordersFuture, here is calling the result of the future.
            Provider.of<OrdersProvider>(context, listen: false).fetchOrders(),
        builder: (ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapShot.hasError) {
              // TODO add error handling logic here
            }
            return Consumer<OrdersProvider>(
              // should use consumer in future builders to not rebuild the widget and enter an infinite loop by the provider listener
              builder: (ctx, orderData, child) => ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (_, i) => OrderItem(order: orderData.orders[i]),
              ),
            );
          }
        },
      ),
    );
  }
}
