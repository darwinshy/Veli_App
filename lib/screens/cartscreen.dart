import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/getflutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:veli/model/profiledata.dart';
import 'package:veli/screens/currentOrdersSummary.dart';
import 'package:veli/screens/payment.dart';
import 'package:veli/screens/profile.dart';
import '../model/cart.dart';
import '../widgets/cartitemwidget.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cartScreen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cartItem = Provider.of<Cart>(context, listen: true);
    final profile = Provider.of<ProfileData>(context);
    refresh();
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
      body: (cartItem.items.isEmpty)
          ? Center(
              child: Text(
                "Your Cart is empty !",
                style: TextStyle(
                  fontFamily: 'QuickSand',
                  fontSize: 26,
                ),
              ),
            )
          : Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: ListView.builder(
                  itemBuilder: (ctx, index) => CartItemWidget(
                      settate: refresh,
                      id: cartItem.items.values.toList()[index].id,
                      price: cartItem.items.values.toList()[index].price,
                      quantity: cartItem.items.values.toList()[index].quantity,
                      title: cartItem.items.values.toList()[index].title,
                      productId: cartItem.items.keys.toList()[index],
                      url: cartItem.items.values.toList()[index].brand),
                  itemCount: cartItem.itemCount(),
                )),
                Card(
                  color: Colors.white10,
                  elevation: 0,
                  margin: EdgeInsets.all(1),
                  child: Text(
                    "Slide the item to remove from cart",
                    style:
                        TextStyle(wordSpacing: 1, fontWeight: FontWeight.w100),
                  ),
                ),
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
                              var dateAndTimeOfOrder = now.toIso8601String();
                              var dateOfOrder =
                                  now.toIso8601String().substring(0, 10);
                              var timeOfOrder =
                                  now.toIso8601String().substring(11, 13);
                              void saveToDb() {
                                profile.getProfileInfo().then((profileData) => {
                                      Firestore.instance
                                          .collection("recieversupiid")
                                          .document("upiid")
                                          .get()
                                          .then((recieversDetail) => {
                                                Firestore.instance
                                                    .collection("timings")
                                                    .document("shifts")
                                                    .get()
                                                    .then((timings) => {
                                                          Firestore.instance
                                                              .collection(
                                                                  "users")
                                                              .document(
                                                                  profileData
                                                                      .elementAt(
                                                                          1))
                                                              .get()
                                                              .then(
                                                                  (onValue) => {
                                                                        if (onValue['address'] == null &&
                                                                            onValue['phone'] ==
                                                                                null &&
                                                                            onValue['phone'].toString().length ==
                                                                                10)
                                                                          {
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return AlertDialog(
                                                                                    contentPadding: EdgeInsets.all(20),
                                                                                    title: Text("Failed"),
                                                                                    content: Text("You havn't set either your Phone Number or Address. Please change in the profile Section"),
                                                                                    actions: <Widget>[
                                                                                      GFButton(
                                                                                          position: GFPosition.start,
                                                                                          size: GFSize.LARGE,
                                                                                          color: Colors.black,
                                                                                          onPressed: () {
                                                                                            Navigator.of(context).pop();
                                                                                          },
                                                                                          text: "Cancel"),
                                                                                      GFButton(
                                                                                          position: GFPosition.start,
                                                                                          size: GFSize.LARGE,
                                                                                          color: Colors.black,
                                                                                          onPressed: () {
                                                                                            Navigator.push(context, PageTransition(child: Profile(), type: PageTransitionType.fade)).then((value) => {
                                                                                                  Navigator.pop(context)
                                                                                                });
                                                                                          },
                                                                                          text: "Profile"),
                                                                                    ],
                                                                                  );
                                                                                }).whenComplete(() => Navigator.of(context).pop())
                                                                          }
                                                                        else if (Firestore.instance.collection("users").document(profileData.elementAt(1)).collection("orders").document(dateOfOrder).get() !=
                                                                                null &&
                                                                            (((int.parse(timeOfOrder)) == timings.data['s1']) ||
                                                                                (((int.parse(timeOfOrder)) == timings.data['s2']))))
                                                                          {
                                                                            cartItem.items.values.forEach((f) =>
                                                                                {
                                                                                  Firestore.instance.collection("users").document(profileData.elementAt(1)).collection("orders").document(dateAndTimeOfOrder).collection(timeOfOrder).document(f.title).setData({
                                                                                    "quantity": f.quantity
                                                                                  }),
                                                                                  // Firestore.instance.collection("users").document(profileData.elementAt(1)).collection("orders").document(now.toIso8601String().substring(0, 10)).setData({}),
                                                                                }),
                                                                            Firestore.instance.collection("users").document(profileData.elementAt(1)).updateData({
                                                                              "latestOrder": dateAndTimeOfOrder,
                                                                              "latestOrderShift": (timeOfOrder == "17") ? "1" : "2"
                                                                            }),
                                                                            Firestore.instance.collection("users").document(profileData.elementAt(1)).collection("orders").document(dateAndTimeOfOrder).setData({
                                                                              "orderId": profileData.elementAt(1).substring(0, 6) + UniqueKey().toString(),
                                                                              "date": dateAndTimeOfOrder,
                                                                              "time": timeOfOrder,
                                                                              "price": cartItem.totalAmount.toString(),
                                                                              "shift": (time == "17") ? "1" : "2"
                                                                            }),
                                                                            Navigator.of(context).pushReplacement(PageTransition(
                                                                              type: PageTransitionType.fade,
                                                                              child: PaymentPage(
                                                                                upiId: recieversDetail['upiid'],
                                                                                ref: Firestore.instance.collection("users").document(profileData.elementAt(1)).collection("orders").document(dateAndTimeOfOrder).path,
                                                                                amount: cartItem.totalAmount.toString(),
                                                                                orderId: profileData.elementAt(1).substring(0, 6) + UniqueKey().toString(),
                                                                                uid: profileData.elementAt(1),
                                                                                timeOfOrder: dateAndTimeOfOrder,
                                                                              ),
                                                                            ))
                                                                          }
                                                                        else
                                                                          {
                                                                            // Error when user is trying to place an order and shift hasn't started
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return AlertDialog(
                                                                                    contentPadding: EdgeInsets.all(20),
                                                                                    title: Text("Failed"),
                                                                                    content: Text("The error might have occured due to the reason that the shift hasn't started and you are trying to place an order."),
                                                                                    actions: <Widget>[
                                                                                      Text("Shift 1 : 5:00pm-6:00pm"),
                                                                                      Text("Shift 2 : 7:00pm-8:00pm")
                                                                                    ],
                                                                                  );
                                                                                }).whenComplete(() => Navigator.of(context).pop())
                                                                          }
                                                                      }),
                                                        }),
                                              })
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
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            text: "Cancel"),
                                        GFButton(
                                          position: GFPosition.start,
                                          size: GFSize.LARGE,
                                          color: Colors.green,
                                          text: "Confirm",
                                          onPressed: saveToDb,
                                        )
                                      ],
                                    );
                                  });
                            },
                            child: Text("Place Order")),
                        Chip(
                            backgroundColor: Colors.black,
                            label: Text(
                              '₹ ' + cartItem.totalAmount().toString(),
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
