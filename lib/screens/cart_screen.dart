import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/providers/orders_provider.dart';
import 'package:untitled1/widgets/cart_item.dart';
import '../providers/cart.dart' show CartProvider;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartProvider.totalAmount().toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: OrderButton(cartProvider: cartProvider),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, i) => CartItem(
                id: cartProvider.items.values.toList()[i].id,
                mapKey: cartProvider.items.keys.toList()[i],
                title: cartProvider.items.values.toList()[i].title,
                price: cartProvider.items.values.toList()[i].price,
                quantity: cartProvider.items.values.toList()[i].quantity),
            itemCount: cartProvider.itemCount,
          ))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  //TODO refactor OrderButton
  const OrderButton({
    @required this.cartProvider,
  });

  final CartProvider cartProvider;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cartProvider.totalAmount() <= 0 || _isLoading)
          ? null
          : () async {
              try {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<OrdersProvider>(context, listen: false)
                    .addOrder(widget.cartProvider.items.values.toList(),
                        widget.cartProvider.totalAmount());
                setState(() {
                  _isLoading = false;
                });
                widget.cartProvider.clear();
              } catch (error) {
                print(error);
              }
            },
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'ORDER NOW',
              style: TextStyle(
                  color: (widget.cartProvider.totalAmount() <= 0)
                      ? Colors.grey
                      : Theme.of(context).primaryColor),
            ),
    );
  }
}
