import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:veli/model/cart.dart';
import 'package:veli/widgets/badge.dart';
import '../drawercontent/drawer.dart';
import './find_restro.dart';
import './food_item_view.dart';
import 'cartscreen.dart';

final databaseReference = Firestore.instance;

class FoodItemMenuType extends StatelessWidget {
  static const routename = '/FoodItemMenuType';
  final Data str2;

  FoodItemMenuType({
    this.str2,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: DrawerScreen()),
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text(
          'Select Food Type',
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
        backgroundColor: Colors.black87,
        elevation: 0,
      ),
      body: _buildBody(context, str2),
    );
  }
}

Widget _buildBody(BuildContext context, Data z) {
  String finalPath = z.nameofres + '_menutype';
  print(finalPath);
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection(finalPath).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
      return _buildList(context, snapshot.data.documents, z);
    },
  );
}

Widget _buildList(
    BuildContext context, List<DocumentSnapshot> snapshot, Data z) {
  // if (snapshot == null) {
  if (snapshot.toList().isNotEmpty) {
    return ListView(
      padding: const EdgeInsets.only(top: 10.0),
      children:
          snapshot.map((data) => _buildListItem(context, data, z)).toList(),
    );
  } else
    return Center(
        child: Text("Sorry , the item is not available at the moment"));
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data, Data z) {
  final record = Record.fromSnapshot(data);

  String typeName = record.type.toString();
  String correspondingRestaurantName = record.resName.toString();

  final str2 = Data(menutype: typeName, nameofres: correspondingRestaurantName);

  return InkWell(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FoodItems(
            str3: str2,
          ),
        ),
      );
    },
    child: Column(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(241, 241, 241, 1),
                borderRadius: BorderRadius.circular(10.0),
                // border: Border.all(color: Colors.black)
              ),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                leading: Container(
                  padding: EdgeInsets.only(right: 12.0),
                  decoration: new BoxDecoration(
                      border: new Border(
                          right: new BorderSide(
                              width: 1.0, color: Colors.white24))),
                  child: Icon(Icons.fastfood, color: Colors.black),
                ),
                title: Text(
                  typeName,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'QuickSand',
                  ),
                ),
                subtitle: Text(
                  "This should be edited at later moment, rather about Foodtype must be provided in the database",
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ))
      ],
    ),
  );
}

class Record {
  final String type;
  final String resName;
  final DocumentReference reference;

//Add variables/field
  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : type = map['name'],
        resName = map['resname'];
  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
