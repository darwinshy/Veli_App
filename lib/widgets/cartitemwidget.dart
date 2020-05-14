import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veli/model/cart.dart';

class CartItemWidget extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;
  final String productId;
  final String url;
  final Function settate;
  CartItemWidget(
      {this.id,
      this.price,
      this.quantity,
      this.title,
      this.productId,
      this.url,
      this.settate});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      onDismissed: (direction) {
        settate();
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
          contentPadding: EdgeInsets.all(10),
          leading: CircleAvatar(
            child: Text(
              'x' + quantity.toString(),
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
          ),
          title: Text(title),
          subtitle: Text(price.toString()),
          trailing: Column(
            children: <Widget>[
              Text(url.toString()),
              SizedBox(
                height: 10,
              ),
              Text('₹ ' + (price * quantity).toString(),
                  style: TextStyle(fontSize: 12))
            ],
          ),
        ),
      ),
    );
  }
}
