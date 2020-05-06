import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/getflutter.dart';
import 'package:provider/provider.dart';
import 'package:veli/model/profiledata.dart';
import '../model/cart.dart';
import '../widgets/cartitemwidget.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cartScreen';

  @override
  Widget build(BuildContext context) {
    final cartItem = Provider.of<Cart>(context, listen: true);
    final profile = Provider.of<ProfileData>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white10,
        title: Text(
          "Your Cart",
          style: TextStyle(color: Colors.black),
        ),
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
                        void saveToDb() {
                          DateTime now = DateTime.now();
                          profile.getProfileInfo().then((profileData) => {
                                Firestore.instance
                                    .collection("users")
                                    .document(profileData.elementAt(1))
                                    .get()
                                    .then((onValue) => {
                                          ((onValue.data['orders']) ==
                                                  now
                                                      .toIso8601String()
                                                      .substring(0, 10))
                                              ? showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          content: Text(
                                                            "You cannot reorder !",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        );
                                                      })
                                                  .then((_) =>
                                                      {Navigator.pop(context)})
                                              : cartItem.items.values
                                                  .forEach((f) => {
                                                        if (Firestore.instance
                                                                .collection(
                                                                    "users")
                                                                .document(
                                                                    profileData
                                                                        .elementAt(
                                                                            1))
                                                                .collection(
                                                                    "orders")
                                                                .document(now
                                                                    .toIso8601String())
                                                                .collection(
                                                                    f.id)
                                                                .document(
                                                                    f.id) !=
                                                            null)
                                                          {
                                                            Firestore.instance
                                                                .collection(
                                                                    "users")
                                                                .document(
                                                                    profileData
                                                                        .elementAt(
                                                                            1))
                                                                .collection(
                                                                    "orders")
                                                                .document(now
                                                                    .toIso8601String())
                                                                .collection(
                                                                    f.id)
                                                                .document(f.id)
                                                                .setData({
                                                              "title": f.title,
                                                              "quantity":
                                                                  f.quantity,
                                                              "price": f.price,
                                                            }),
                                                            Firestore.instance
                                                                .collection(
                                                                    "users")
                                                                .document(
                                                                    profileData
                                                                        .elementAt(
                                                                            1))
                                                                .updateData({
                                                              "orders": now
                                                                  .toIso8601String()
                                                                  .substring(
                                                                      0, 10)
                                                            })
                                                          }
                                                        else
                                                          {
                                                            Firestore.instance
                                                                .collection(
                                                                    "users")
                                                                .document(
                                                                    profileData
                                                                        .elementAt(
                                                                            1))
                                                                .collection(
                                                                    "orders")
                                                                .document(now
                                                                    .toIso8601String())
                                                                .collection(
                                                                    f.id)
                                                                .document(f.id)
                                                                .updateData({
                                                              "title": f.title,
                                                              "quantity":
                                                                  f.quantity,
                                                              "price": f.price
                                                            })
                                                          }
                                                      }),
                                        }),

                                // Navigator.of(context).pushReplacement(
                                //     MaterialPageRoute(
                                //         builder: (BuildContext context) =>
                                //             PaymentPage()))
                              });
                        }

                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                elevation: 1,
                                title: Text(
                                  "Do you want to place the order ?",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                content: Text(
                                  "Note : You can order only once a day !",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300),
                                ),
                                actions: <Widget>[
                                  GFButton(
                                      position: GFPosition.start,
                                      size: GFSize.LARGE,
                                      color: Colors.red,
                                      onPressed: () => Navigator.pop(context),
                                      text: "Cancel"),
                                  GFButton(
                                      position: GFPosition.start,
                                      size: GFSize.LARGE,
                                      color: Colors.green,
                                      onPressed: saveToDb,
                                      text: "Confirm")
                                ],
                              );
                            });
                      },
                      child: Text("Place Order")),
                  Chip(
                      backgroundColor: Colors.black,
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
