import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:veli/payment.dart';
import 'find_restro.dart';
import 'package:getflutter/getflutter.dart';

final databaseReference = Firestore.instance;

class FoodItems extends StatelessWidget {
  final Data str3;
  FoodItems({this.str3});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Select Food Items',
          style: TextStyle(
              color: Colors.black, fontFamily: 'rob', letterSpacing: 1),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
            onPressed: () {},
          )
        ],
        primary: true,
        backgroundColor: Colors.white10,
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
  return ListView(
    padding: const EdgeInsets.only(top: 10.0),
    children: snapshot.map((data) => _buildListItem(context, data, z)).toList(),
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data, Data z) {
  final record = Record.fromSnapshot(data);
  String one = record.name.toString();
  String two = "  ₹" + record.cost.toString();
  // final str2 = Data(menutype: one);
  String available = record.available.toString();
  String type = record.vgvng.toString();
  String vgpath = "asset/" + type + ".png";

  return Column(
    children: <Widget>[
      // GFListTile(
      //     avatar: Image.asset(vgpath, width: 20, height: 20),
      //     titleText: one,
      //     subtitleText: "Price : " + two,
      //     icon: Icon(Icons.favorite)),
      // GFCard(
      //   boxFit: BoxFit.cover,
      //   image: Image.asset('asset/121407.jpg'),
      //   title: GFListTile(
      //       avatar: GFAvatar(),
      //       title: Text(one),
      //       icon: GFIconButton(
      //         onPressed: null,
      //         icon: Icon(Icons.favorite_border),
      //         type: GFButtonType.transparent,
      //       )),
      //   content: Text("Price : " + two),
      //   buttonBar: GFButtonBar(
      //     alignment: WrapAlignment.start,
      //     children: <Widget>[
      //       GFButton(
      //         onPressed: () {},
      //         text: 'Read More',
      //       ),
      //     ],
      //   ),
      // ),
      GFCard(
        boxFit: BoxFit.cover,
        imageOverlay: AssetImage('asset/bgoftype.png'),
        title: GFListTile(
          avatar: GFAvatar(),
          title: Text(
            one,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontFamily: 'rob',
            ),
          ),
          subTitle: Text("Price : " + two),
        ),
        // content: Text(
        //     "GFCards has three types of cards i.e, basic, with avataras and with overlay image"),
        // buttonBar: GFButtonBar(
        //   alignment: WrapAlignment.center,
        //   children: <Widget>[
        //     GFButton(
        //       onPressed: () {},
        //       text: 'View',
        //     )
        //   ],
        // ),
      ),
      // GFCard(
      //   boxFit: BoxFit.cover,
      //   image: Image.asset('asset/121407.jpg'),
      //   title: GFListTile(
      //       avatar: GFAvatar(),
      //       title: Text('Card Title'),
      //       icon: GFIconButton(
      //         onPressed: null,
      //         icon: Icon(Icons.favorite_border),
      //         type: GFButtonType.transparent,
      //       )),
      //   content: Text("Some quick example text to build on the card"),
      //   buttonBar: GFButtonBar(
      //     alignment: WrapAlignment.start,
      //     children: <Widget>[
      //       GFButton(
      //         onPressed: () {},
      //         text: 'Read More',
      //       ),
      //     ],
      //   ),
      // ),
      // GFListTile(
      //     titleText: one,
      //     subtitleText: two,
      //     icon: Icon(Icons.favorite)),
      // Padding(
      //     padding: const EdgeInsets.fromLTRB(2, 4, 2, 2),
      //     child: Container(
      //       decoration: BoxDecoration(
      //         borderRadius: BorderRadius.circular(10.0),
      //         color: Colors.white70,

      //       ),
      //       child: ListTile(
      //           contentPadding:
      //               EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      //           leading: Container(
      //               padding: EdgeInsets.only(right: 12.0),
      //               decoration: new BoxDecoration(
      //                   border: new Border(
      //                       right: new BorderSide(
      //                           width: 1.0, color: Colors.white24))),
      //               child: IconButton(
      //                 icon: Icon(Icons.arrow_forward_ios, color: Colors.black),
      //                 onPressed: () {
      //                   Navigator.of(context).push(
      //                     MaterialPageRoute(
      //                       builder: (context) => PaymentPage(),
      //                     ),
      //                   );
      //                 },
      //               )),
      //           title: Text(
      //             one,
      //             style: TextStyle(
      //                 fontSize: 20,
      //                 color: Colors.black87,
      //                 fontWeight: FontWeight.bold,
      //                 fontFamily: 'rob',
      //                 letterSpacing: 1),
      //           ),
      //           subtitle: Padding(
      //             padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      //             child: Row(
      //               children: <Widget>[
      //                 Image.asset(vgpath, width: 20, height: 20),
      //               ],
      //             ),
      //           ),
      //           trailing: Text(two,
      //               style: TextStyle(
      //                   fontSize: 20,
      //                   fontFamily: 'rob',
      //                   letterSpacing: 1,
      //                   color: Color.fromRGBO(0, 14, 104, 1)))),
      //     ))
    ],
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
