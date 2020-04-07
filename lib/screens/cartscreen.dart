import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/cart.dart';
import '../widgets/cartitemwidget.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cartScreen';

  @override
  Widget build(BuildContext context) {
    final cartItem = Provider.of<Cart>(context, listen: true);
    // cartItem.items.forEach((f, c) => print(c.id +
    //     ' ' +
    //     c.price.toString() +
    //     ' ' +
    //     c.quantity.toString() +
    //     ' ' +
    //     c.title));

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Chip(
                      backgroundColor: Theme.of(context).primaryColor,
                      label: Text(
                        '\$ ' + cartItem.totalAmount.toString(),
                        style: TextStyle(color: Colors.white),
                      )),
                  FlatButton(onPressed: () {}, child: Text("Order Now"))
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, index) => CartItemWidget(
                id: cartItem.items.values.toList()[index].id,
                price: cartItem.items.values.toList()[index].price,
                quantity: cartItem.items.values.toList()[index].quantity,
                title: cartItem.items.values.toList()[index].title,
                productId: cartItem.items.keys.toList()[index]),
            itemCount: cartItem.itemCount,
          ))
        ],
      ),
    );
  }
}
