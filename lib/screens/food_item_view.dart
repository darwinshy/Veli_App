import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:veli/model/cart.dart';
import 'package:veli/model/profiledata.dart';
import 'package:veli/widgets/badge.dart';
import '../drawercontent/drawer.dart';
// import 'package:veli/payment.dart';
import 'cartscreen.dart';
import 'find_restro.dart';
import 'package:getflutter/getflutter.dart';

class FoodItems extends StatefulWidget {
  final Data str3;

  FoodItems({this.str3});

  @override
  _FoodItemsState createState() => _FoodItemsState();
}

class _FoodItemsState extends State<FoodItems> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    refresh();
    return Scaffold(
      drawer: Drawer(child: DrawerScreen()),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Items',
          style: TextStyle(
              color: Colors.black, fontFamily: 'rob', letterSpacing: 1),
        ),
        actions: <Widget>[
          Badge(
              child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  }),
              value: cart.itemCount().toString())
        ],
        primary: true,
        backgroundColor: Colors.white10,
        elevation: 0,
      ),
      body: _buildBody(context, widget.str3, refresh),
    );
  }
}

Widget _buildBody(BuildContext context, Data z, void Function() refresh) {
  String finalPath = 'restro/' + z.nameofres + '/' + z.menutype;
  print(finalPath);
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection(finalPath).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      return _buildList(context, snapshot.data.documents, z, refresh);
    },
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot, Data z,
    void Function() refresh) {
  try {
    return ListView(
      padding: const EdgeInsets.only(top: 10.0),
      children: snapshot
          .map((data) => _buildListItem(context, data, z, refresh))
          .toList(),
    );
  } catch (e) {
    print(e);
    return Center(
        child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Snap !",
            style: TextStyle(
                fontFamily: 'QuickSand',
                fontSize: 46,
                fontWeight: FontWeight.w700),
          ),
          Text(
            "Technical Error",
            style: TextStyle(
                fontFamily: 'QuickSand', fontSize: 26, letterSpacing: 3),
          ),
          Text(
            "Please contact administator",
            style: TextStyle(fontFamily: 'QuickSand', fontSize: 16),
          ),
        ],
      ),
    ));
  }
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data, Data item,
    void Function() refresh) {
  final cart = Provider.of<Cart>(context, listen: true);
  final record = Record.fromSnapshot(data);
  String itemName = record.name.toString();
  String price = "  ₹" + record.cost.toString();
  final profile = Provider.of<ProfileData>(context);
  String type = record.vgvng.toString();

  return GFCard(
    color: Colors.white24,
    elevation: 0,
    boxFit: BoxFit.cover,
    title: GFListTile(
      avatar: CircleAvatar(
        radius: 5,
        child: Image.asset(
            type == true.toString() ? 'asset/true.png' : 'asset/false.png'),
      ),
      icon: IconButton(
          icon: Icon(
            Icons.add,
          ),
          onPressed: () {
            profile.getProfileInfo().then((onValue) => {
                  Firestore.instance
                      .collection("users")
                      .document(onValue.elementAt(1))
                      .get()
                      .then((onValue) => {
                            if (onValue.data['lastOrder'] == false)
                              {
                                refresh(),
                                cart.addItem(
                                  record.id,
                                  record.cost.toDouble(),
                                  record.name,
                                  item.nameofres,
                                  item.menutype,
                                ),
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text("Item was added"),
                                  duration: Duration(milliseconds: 400),
                                ))
                              }
                            else
                              {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Failed"),
                                        content: Text(
                                            "This happened because you are trying to add an item after placing an order. Please wait for the next shift."),
                                      );
                                    })
                              }
                          })
                });
          }),
      title: Text(
        itemName,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'rob',
        ),
      ),
      subTitle: Text(
        "Price : " + price,
        style: TextStyle(
          fontSize: 12,
          fontFamily: 'rob',
        ),
      ),
    ),
  );
}

class Record {
  final String name;
  final int cost;
  final bool available;
  final bool vgvng;
  final String id;
  final String brand;
  final DocumentReference reference;

//Add variables/field
  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['item'],
        cost = map['cost'],
        available = map['available'],
        vgvng = map['type'],
        id = map['id'],
        brand = map['brand'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
