import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veli/model/profiledata.dart';

class AllOrders extends StatefulWidget {
  @override
  _AllOrdersState createState() => _AllOrdersState();
}

String uid;

class _AllOrdersState extends State<AllOrders> {
  // void setTheUserId(String uid) {
  //   setState(() {
  //     uid = uid;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileData>(context);
    return FutureBuilder<List<String>>(
      future: profile.getProfileInfo(),
      builder: (context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          try {
            return Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.black),
                backgroundColor: Colors.white10,
                elevation: 0,
                title: Text(
                  "Orders",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              body: _buildAllOrderBody(context, snapshot),
            );
          } catch (e) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
        } else {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}

Widget _buildAllOrderBody(
    BuildContext context, AsyncSnapshot<List<String>> profile) {
  if (profile.hasData) {
    try {
      return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection("users")
              .document(profile.data.elementAt(1))
              .collection("orders")
              .snapshots(),
          builder: (context, snapshot) {
            try {
              return _buildListAllOrderItems(context, snapshot.data.documents);
            } catch (e) {
              return CircularProgressIndicator();
            }
          });
    } catch (e) {
      return CircularProgressIndicator();
    }
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
            "No Orders",
            style: TextStyle(
                fontFamily: 'QuickSand', fontSize: 26, letterSpacing: 3),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    ));
  }
}

Widget _buildListAllOrderItems(
    BuildContext context, List<DocumentSnapshot> snapshot) {
  if (snapshot.toList().isNotEmpty) {
    print(snapshot.length);
    try {
      return Container(
        child: ListView(
          padding: const EdgeInsets.only(top: 10.0),
          children: snapshot
              .map((data) => _buildAllOrderItem(context, data))
              .toList(),
        ),
      );
    } catch (e) {
      return Text("");
    }
  } else
    return Text("");
}

Widget _buildAllOrderItem(BuildContext context, DocumentSnapshot data) {
  final record = RecordForAllOrderDetails.fromSnapshot(data);
  print(record);
  return Card(
    margin: EdgeInsets.all(15),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          ExpansionTile(
            title: Text(
              record.orderId != null ? record.orderId : "Error",
              style: TextStyle(color: Colors.black),
            ),
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
                  title: Text("Order Id"),
                  trailing: Text(
                    record.orderId != null ? record.orderId : "Error",
                    style: TextStyle(color: Colors.black),
                  )),
              ListTile(
                  title: Text("Total Amount"),
                  trailing: Text(
                    '₹ ' + record.totalAmount,
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          ),
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
        ],
      ),
    ),
  );
}

class RecordForAllOrderDetails {
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
  RecordForAllOrderDetails.fromMap(Map<String, dynamic> map, {this.reference})
      : txnId = map['txnId'],
        resCode = map['resCodee'],
        txnRef = map['txnRef'],
        shift = map['shift'],
        time = map['time'],
        date = map['date'],
        orderId = map['orderId'],
        totalAmount = map['price'],
        status = map['status'];

  RecordForAllOrderDetails.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
  @override
  String toString() =>
      "Record<$date$orderId$resCode$shift$status$time$totalAmount$txnId$txnRef>";
}
