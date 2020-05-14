import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veli/model/cart.dart';
import 'package:veli/model/profiledata.dart';

class CurrentOrdersSummary extends StatefulWidget {
  static const routeName = "/currentOrder";

  final String reOrdered;
  final String lastOrderDbRef;

  const CurrentOrdersSummary({this.reOrdered, this.lastOrderDbRef});

  @override
  _ActiveOrdersState createState() => _ActiveOrdersState();
}

String time;
String userId;
String amount;

class _ActiveOrdersState extends State<CurrentOrdersSummary> {
  @override
  Widget build(BuildContext context) {
    final cartItem = Provider.of<Cart>(context, listen: true);

    cartItem.removeAll();

    void refreshAction() {
      setState(() {
        time = time;
      });
    }

    void setTheTime(String tr) {
      time = tr;
    }

    final profile = Provider.of<ProfileData>(context);
    profile.getProfileInfo().then((value) => {
          Firestore.instance
              .collection("users")
              .document(value.elementAt(1))
              .get()
              .then((value) => setTheTime(value['latestOrder']))
        });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white10,
        title: Text(
          "Last Ordera",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: refreshAction)
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: profile.getProfileInfo(),
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.hasData) {
            return Container(
                child: _buildBody(context, snapshot, widget.lastOrderDbRef));
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

Stream<QuerySnapshot> snapshotOfOrdersItem(String userID) {
  // print(Firestore.instance
  //     .collection("users")
  //     .document(userID)
  //     .collection("orders")
  //     .document(time)
  //     .collection(time != null ? time.substring(11, 13) : time)
  //     .path);
  if (time == null) {
    return null;
  } else {
    return Firestore.instance
        .collection("users")
        .document(userID)
        .collection("orders")
        .document(time)
        .collection(time.substring(11, 13))
        .snapshots();
  }
}

Stream<QuerySnapshot> snapshotOfOrders(String userID) {
  return Firestore.instance
      .collection("users")
      .document(userID)
      .collection("orders")
      .where("date", isEqualTo: time)
      .snapshots();
}

Widget _buildBody(BuildContext context, AsyncSnapshot<List<String>> profile,
    String lastOrderDbRef) {
  userId = profile.data.elementAt(1);
  return StreamBuilder<QuerySnapshot>(
    stream: snapshotOfOrdersItem(userId),
    builder: (context, snapshot) {
      if (snapshot.data == null) {
        return Center(
            child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Ummm !",
                style: TextStyle(
                    fontFamily: 'QuickSand',
                    fontSize: 46,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "No Active Orders",
                style: TextStyle(
                    fontFamily: 'QuickSand', fontSize: 26, letterSpacing: 3),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "If already ordered, try refreshing the page.",
                style: TextStyle(
                    fontFamily: 'QuickSand', fontSize: 10, letterSpacing: 3),
              ),
            ],
          ),
        ));
      } else if (!snapshot.hasData) {
        return Center(child: CircularProgressIndicator());
      }

      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: _buildListOrderItems(context, snapshot.data.documents)),
            StreamBuilder<QuerySnapshot>(
                stream: snapshotOfOrders(userId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.data.documents.isEmpty) {
                    return SizedBox(
                      height: 1,
                    );
                  } else {
                    return Column(children: <Widget>[
                      Container(
                          height: 280,
                          child: _buildListOrderDetails(
                              context, snapshot.data.documents))
                    ]);
                  }
                })
          ]);
    },
  );
}

Widget _buildListOrderItems(
    BuildContext context, List<DocumentSnapshot> snapshot) {
  if (snapshot.toList().isNotEmpty) {
    return Container(
      child: Scrollbar(
        child: ListView(
          padding: const EdgeInsets.only(top: 10.0),
          children:
              snapshot.map((data) => _buildOrderItem(context, data)).toList(),
        ),
      ),
    );
  } else {
    return Center(
        child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Ummm !",
            style: TextStyle(
                fontFamily: 'QuickSand',
                fontSize: 46,
                fontWeight: FontWeight.w700),
          ),
          Text(
            "No Active Orders",
            style: TextStyle(
                fontFamily: 'QuickSand', fontSize: 26, letterSpacing: 3),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "If already ordered, try refreshing the page.",
            style: TextStyle(
                fontFamily: 'QuickSand', fontSize: 10, letterSpacing: 3),
          ),
        ],
      ),
    ));
  }
}

Widget _buildListOrderDetails(
    BuildContext context, List<DocumentSnapshot> snapshot) {
  if (snapshot.toList().isNotEmpty) {
    print(snapshot.length);
    return Container(
      child: ListView(
        padding: const EdgeInsets.only(top: 10.0),
        children:
            snapshot.map((data) => _buildDetailItem(context, data)).toList(),
      ),
    );
  } else
    return Center(
        child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text("")],
      ),
    ));
}

Widget _buildDetailItem(BuildContext context, DocumentSnapshot data) {
  final record = RecordForOrderDetails.fromSnapshot(data);
  print(record);
  return Card(
    margin: EdgeInsets.all(15),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          ExpansionTile(
            title: Text("Order Details"),
            children: <Widget>[
              ListTile(
                  title: Text("Payment ID"),
                  subtitle: SelectableText(
                    (record.txnId != null || record.txnId != "")
                        ? record.txnId
                        : "NULL",
                    style: TextStyle(color: Colors.black),
                  )),
              ListTile(
                  title: Text("Tax Reference"),
                  trailing: Text(
                    (record.txnRef != null) ? record.txnRef : "NULL",
                    style: TextStyle(color: Colors.black),
                  )),
              ListTile(
                  title: Text("Shift"),
                  trailing: Text(
                    (record.shift != null)
                        ? record.shift
                        : record.shift.toString(),
                    style: TextStyle(color: Colors.black),
                  )),
              ListTile(
                  title: Text("Date and Time"),
                  trailing: Text(
                    record.date != null
                        ? (record.date.substring(0, 10) +
                            "   " +
                            record.date.substring(11, 16))
                        : "Error",
                    style: TextStyle(color: Colors.black),
                  )),
              ListTile(
                  title: Text("Order Id"),
                  trailing: Text(
                    record.orderId != null ? record.orderId : "Error",
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          ),
          ListTile(
              title: Text("Payment Status"),
              trailing: (record.status == "success")
                  ? Icon(
                      Icons.beenhere,
                      color: Colors.green,
                    )
                  : Icon(
                      Icons.cancel,
                      color: Colors.red,
                    )),
          ListTile(
              title: Text("Total Amount"),
              trailing: Text(
                '₹ ' + record.totalAmount,
                style: TextStyle(color: Colors.black),
              )),
        ],
      ),
    ),
  );
}

Widget _buildOrderItem(BuildContext context, DocumentSnapshot data) {
  final record = Record.fromSnapshot(data);

  return Card(
    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    child: ListTile(
      contentPadding: EdgeInsets.all(10),
      leading: CircleAvatar(
        child: Text(
          'x' + record.quantity.toString(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      title: Text(record.itemCode),
      // subtitle: Text(price.toString()),
      trailing: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
        ],
      ),
    ),
  );
}

class Record {
  final String itemCode;
  final int quantity;
  final DocumentReference reference;

//Add variables/field
  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : itemCode = reference.documentID,
        quantity = map['quantity'];
  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
  @override
  String toString() => "Record<$quantity>";
}

class RecordForOrderDetails {
  final String date;
  final String orderId;
  final String totalAmount;
  final String status;
  final String time;
  final String shift;
  final String txnId;
  final String resCode;
  final String txnRef;

  final DocumentReference reference;

//Add variables/field
  RecordForOrderDetails.fromMap(Map<String, dynamic> map, {this.reference})
      : txnId = map['txnId'],
        resCode = map['resCodee'],
        txnRef = map['txnRef'],
        shift = map['shift'],
        time = map['time'],
        date = map['date'],
        orderId = map['orderId'],
        totalAmount = map['price'],
        status = map['status'];

  RecordForOrderDetails.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
  @override
  String toString() =>
      "Record<$date$orderId$resCode$shift$status$time$totalAmount$txnId$txnRef>";
}
