import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getflutter/getflutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:veli/authentication/auth.dart';
import 'package:veli/drawercontent/drawer.dart';
import 'package:veli/screens/currentOrdersSummary.dart';
import 'type.dart';

class Data {
  String nameofres;
  String menutype;
  String docID;
  Data({this.nameofres, this.docID, this.menutype});
}

class FindRestroScreen extends StatelessWidget {
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  FindRestroScreen({this.auth, this.onSignedOut});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        drawer: Drawer(child: DrawerScreen()),
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
          title: Text(
            'Restaurants',
            style: TextStyle(
                color: Colors.black, fontFamily: 'rob', letterSpacing: 2),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          primary: true,
          backgroundColor: Colors.white10,
          elevation: 0,
        ),
        body: _buildBody(context));
  }
}

Stream<QuerySnapshot> snapshot(String y) {
  final String x = y;
  return Firestore.instance.collection(x).snapshots();
}

Widget _buildBody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: snapshot('restaurants'),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Center(child: CircularProgressIndicator());
      }

      return _buildList(context, snapshot.data.documents);
    },
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    padding: const EdgeInsets.only(top: 10.0),
    children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  final record = Record.fromSnapshot(data);
  var str1 = Data(
    nameofres: record.name,
    docID: data.documentID,
  );

  return InkWell(
    onTap: () {
      if (record.available == true) {
        Navigator.of(context).push(
          PageTransition(
            type: PageTransitionType.fade,
            child: FoodItemMenuType(
              str2: str1,
            ),
          ),
        );
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                contentPadding: EdgeInsets.all(20),
                title: Text("Failed"),
                content:
                    Text("The selected restaurant isn't accepting orders."),
                actions: <Widget>[
                  GFButton(
                      position: GFPosition.start,
                      size: GFSize.LARGE,
                      color: Colors.red,
                      onPressed: () => Navigator.pop(context),
                      text: "OK"),
                ],
              );
            });
      }
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
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: new BoxDecoration(
                          border: new Border(
                              right: new BorderSide(
                                  width: 1.0, color: Colors.white24))),
                      child: Image.network(
                        record.iconlogo,
                        width: 40,
                      ),
                    ),
                    title: Text(
                      record.name,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'rob',
                          letterSpacing: 1),
                    ),
                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                    subtitle: Row(
                      children: <Widget>[
                        Text(record.details,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                fontFamily: 'QuickSand',
                                letterSpacing: 1,
                                color: Colors.black87))
                      ],
                    ),
                    trailing: AnimatedCrossFade(
                        firstChild: Text(
                          "Not accepting orders",
                          style: TextStyle(color: Colors.red, fontSize: 8),
                        ),
                        secondChild: Text(
                          "Accepting orders",
                          style: TextStyle(color: Colors.green, fontSize: 8),
                        ),
                        crossFadeState: record.available
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: Duration(milliseconds: 100)))))
      ],
    ),
  );
}

class Record {
  final String name;
  final String details;
  final String iconlogo;
  final bool available;
  final DocumentReference reference;

//Add variables/field
  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'],
        details = map['details'],
        iconlogo = map['icon'],
        available = map['available'];
  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
  @override
  String toString() => "Record<$name:$details:$iconlogo:$available>";
}
