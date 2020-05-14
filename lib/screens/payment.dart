import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/getflutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:upi_india/upi_india.dart';

import 'currentOrdersSummary.dart';

class PaymentPage extends StatefulWidget {
  final String uid;
  final String ref;
  final String orderId;
  final String amount;
  final String timeOfOrder;
  final String upiId;
  const PaymentPage(
      {this.amount,
      this.orderId,
      this.ref,
      this.uid,
      this.timeOfOrder,
      this.upiId});
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Future _transaction;

  Future<String> initiateTransaction(String app) async {
    UpiIndia upi = new UpiIndia(
      app: app,
      receiverUpiId: widget.upiId,
      receiverName: 'Veli',
      transactionRefId: widget.orderId,
      transactionNote: widget.orderId,
      amount: double.parse(widget.amount),
    );

    String response = await upi.startTransaction();

    return response;
  }

  void save(String tr) {
    UpiIndiaResponse _upiResponse;
    _upiResponse = UpiIndiaResponse(tr);
    String txnId = _upiResponse.transactionId;
    String resCode = _upiResponse.responseCode;
    String txnRef = _upiResponse.transactionRefId;
    String status = _upiResponse.status;

    print(widget.ref);
    Firestore.instance.document(widget.ref).updateData({
      "txnId": txnId,
      "resCode": resCode,
      "txnRef": txnRef,
      "status": status,
    });
    if (status == "failure") {
      Firestore.instance
          .collection("users")
          .document(widget.uid)
          .updateData({"lastOrder": false});
    } else {
      Firestore.instance
          .collection("users")
          .document(widget.uid)
          .updateData({"lastOrder": true});
    }

    Navigator.of(context).pushReplacement(PageTransition(
      type: PageTransitionType.fade,
      child: CurrentOrdersSummary(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white10,
          elevation: 0,
          title: Text(
            'Payment',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GFButton(
                  shape: GFButtonShape.pills,
                  type: GFButtonType.outline,
                  position: GFPosition.start,
                  size: 60,
                  color: Colors.black,
                  child: Text(
                    "      Phone Pe      ",
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () {
                    _transaction = initiateTransaction(UpiIndiaApps.PhonePe)
                        .then((value) => {save(value)})
                        .then((value) => Navigator.of(context).pop());
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                GFButton(
                    shape: GFButtonShape.pills,
                    type: GFButtonType.outline,
                    position: GFPosition.start,
                    size: 60,
                    color: Colors.black,
                    child: Text(
                      "        PayTM        ",
                      style: TextStyle(fontSize: 24),
                    ),
                    onPressed: () {
                      _transaction = initiateTransaction(UpiIndiaApps.PayTM)
                          .then((value) => {save(value)})
                          .then((value) => Navigator.of(context).pop());
                    }),
                SizedBox(
                  height: 20,
                ),
                GFButton(
                    shape: GFButtonShape.pills,
                    type: GFButtonType.outline,
                    position: GFPosition.start,
                    size: 60,
                    color: Colors.black,
                    child: Text(
                      "    Google Pay    ",
                      style: TextStyle(fontSize: 24),
                    ),
                    onPressed: () {
                      _transaction = initiateTransaction(UpiIndiaApps.GooglePay)
                          .then((value) => {save(value)})
                          .then(
                            (value) => Navigator.of(context)
                                .pushReplacement(PageTransition(
                              type: PageTransitionType.fade,
                              child: CurrentOrdersSummary(),
                            )),
                          );
                    }),
              ]),
        ));
  }
}
