import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veli/model/profiledata.dart';
import '../model/cart.dart';
import '../payment.dart';
import '../widgets/cartitemwidget.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cartScreen';

  @override
  Widget build(BuildContext context) {
    final cartItem = Provider.of<Cart>(context, listen: true);
    final profile = Provider.of<ProfileData>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: <Widget>[
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
                productId: cartItem.items.keys.toList()[index],
                url: cartItem.items.values.toList()[index].brand),
            itemCount: cartItem.itemCount,
          )),
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                      onPressed: () {
                        DateTime now = DateTime.now();

                        profile.getProfileInfo().then((profileData) => {
                              print("users/" +
                                  profileData.elementAt(1) +
                                  "/" +
                                  now.toIso8601String()),
                              cartItem.items.values.forEach((f) => {
                                    Firestore.instance
                                        .collection("users")
                                        .document(profileData.elementAt(1))
                                        .collection("orders")
                                        .document(now.toIso8601String())
                                        .collection(f.id)
                                        .document(f.id)
                                        .setData({
                                      "title": f.title,
                                      "quantity": f.quantity,
                                      "price": f.price
                                    })
                                  }),
                            });
                      },
                      child: Text("Place Order")),
                  Chip(
                      backgroundColor: Theme.of(context).primaryColor,
                      label: Text(
                        '₹ ' + cartItem.totalAmount.toString(),
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
