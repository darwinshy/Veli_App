import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:veli/model/cart.dart';
import 'package:veli/widgets/badge.dart';
import '../drawercontent/drawer.dart';
import './find_restro.dart';
import './food_item_view.dart';
import 'cartscreen.dart';
import 'currentOrdersSummary.dart';

final databaseReference = Firestore.instance;

class FoodItemMenuType extends StatefulWidget {
  static const routename = '/FoodItemMenuType';
  final Data str2;

  FoodItemMenuType({
    this.str2,
  });

  @override
  _FoodItemMenuTypeState createState() => _FoodItemMenuTypeState();
}

class _FoodItemMenuTypeState extends State<FoodItemMenuType> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    refresh();
    return Scaffold(
      drawer: Drawer(child: DrawerScreen()),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        backgroundColor: Colors.black,
        icon: Icon(Icons.fastfood),
        isExtended: true,
        onPressed: () {
          Navigator.of(context).push(
            PageTransition(
                type: PageTransitionType.downToUp,
                child: CurrentOrdersSummary()),
          );
        },
        label: Text("      Last Order      "),
      ),
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text(
          'Menu',
          style: TextStyle(
              color: Colors.black, fontFamily: 'rob', letterSpacing: 1),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        actions: <Widget>[
          Badge(
              child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  }),
              value: Provider.of<Cart>(context, listen: false)
                  .itemCount()
                  .toString())
        ],
        primary: true,
        backgroundColor: Colors.white10,
        elevation: 0,
      ),
      body: _buildBody(context, widget.str2),
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

Widget _buildListItem(BuildContext context, DocumentSnapshot data, Data z) {
  final record = Record.fromSnapshot(data);

  String typeName = record.type.toString();
  String correspondingRestaurantName = record.resName.toString();

  final str2 = Data(menutype: typeName, nameofres: correspondingRestaurantName);

  return InkWell(
    onTap: () {
      Navigator.of(context).push(
        PageTransition(
          type: PageTransitionType.fade,
          child: FoodItems(
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
                color: Colors.white12,
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
