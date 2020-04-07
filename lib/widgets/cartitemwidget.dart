import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veli/model/cart.dart';

class CartItemWidget extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;
  final String productId;
  CartItemWidget(
      {this.id, this.price, this.quantity, this.title, this.productId});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      background: Container(
        child: Icon(Icons.delete),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 10),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: ListTile(
          leading: CircleAvatar(
            child: Text(price.toString(), style: TextStyle(fontSize: 10)),
          ),
          title: Text(title),
          subtitle: Text(
            (price * quantity).toString(),
          ),
          trailing: Text('x' + quantity.toString()),
        ),
      ),
    );
  }
}
