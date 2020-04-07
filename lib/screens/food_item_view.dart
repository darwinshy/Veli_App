import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:veli/model/cart.dart';
import 'package:veli/widgets/badge.dart';
import '../drawercontent/drawer.dart';
// import 'package:veli/payment.dart';
import 'cartscreen.dart';
import 'find_restro.dart';
import 'package:getflutter/getflutter.dart';

final databaseReference = Firestore.instance;

class FoodItems extends StatelessWidget {
  final Data str3;

  FoodItems({this.str3});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: DrawerScreen()),
      appBar: AppBar(
        title: Text(
          'Select Food Items',
          style: TextStyle(
              color: Colors.white, fontFamily: 'rob', letterSpacing: 1),
        ),
        actions: <Widget>[
          Badge(
              child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  }),
              value:
                  Provider.of<Cart>(context, listen: true).itemCount.toString())
        ],
        primary: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: _buildBody(context, str3),
    );
  }
}

Widget _buildBody(BuildContext context, Data z) {
  String finalPath = 'restro/' + z.nameofres + '/' + z.menutype;
  print(finalPath);
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection(finalPath).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      return _buildList(context, snapshot.data.documents, z);
    },
  );
}

Widget _buildList(
    BuildContext context, List<DocumentSnapshot> snapshot, Data z) {
  try {
    return ListView(
      padding: const EdgeInsets.only(top: 10.0),
      children:
          snapshot.map((data) => _buildListItem(context, data, z)).toList(),
    );
  } catch (e) {
    print(e);
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Sorry, there must a technical error !"),
        Text("Contact Administator !"),
      ],
    ));
  }
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data, Data z) {
  final cart = Provider.of<Cart>(context, listen: true);
  // cart.items.forEach((f, c) => print(c.id +
  //     ' ' +
  //     c.price.toString() +
  //     ' ' +
  //     c.quantity.toString() +
  //     ' ' +
  //     c.title));
  final record = Record.fromSnapshot(data);
  String one = record.name.toString();
  String two = "  ₹" + record.cost.toString();
  // String available = record.available.toString();
  String type = record.vgvng.toString();
  // String vgpath = "asset/" + type + ".png";

  return GFCard(
    boxFit: BoxFit.cover,
    // imageOverlay: AssetImage('asset/bgoftype.png'),
    title: GFListTile(
      avatar: CircleAvatar(
        radius: 10,
        child: Image.asset(
            type == true.toString() ? 'asset/true.png' : 'asset/false.png'),
      ),
      icon: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            print("Item Added");
            cart.addItem(record.id, record.cost.toDouble(), record.name);
          }),
      title: Text(
        one,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontFamily: 'rob',
        ),
      ),
      subTitle: Text(
        "Price : " + two,
        style: TextStyle(
          fontSize: 12,
          color: Colors.black54,
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
  final DocumentReference reference;

//Add variables/field
  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['item'],
        cost = map['cost'],
        available = map['available'],
        vgvng = map['type'],
        id = map['id'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
