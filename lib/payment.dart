import 'package:flutter/material.dart';
import 'package:upi_india/upi_india.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Future _transaction;

  Future<String> initiateTransaction(String app) async {
    UpiIndia upi = new UpiIndia(
      app: app,
      receiverUpiId: '9182782657@upi',
      receiverName: 'M MEGHNA',
      transactionRefId: '123456789',
      transactionNote: 'Take a note of this',
      amount: 1.00,
    );

    String response = await upi.startTransaction();

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UPI'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                RaisedButton(
                  child: Text('PhonePe'),
                  onPressed: () {
                    _transaction = initiateTransaction(UpiIndiaApps.PhonePe);
                    setState(() {});
                  },),
                RaisedButton(
                  child: Text('GPay'),
                  onPressed: () {
                    _transaction = initiateTransaction(UpiIndiaApps.GooglePay);
                    setState(() {});
                  }),
                  RaisedButton(
                  child: Text('PayTM'),
                  onPressed: () {
                    _transaction = initiateTransaction(UpiIndiaApps.PayTM);
                    setState(() {});
                  }),
                ]),
            ),
          ),
          Expanded(
            flex: 2,
            child: FutureBuilder(
              future: _transaction,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.data == null)
                  return Text(' ');
                else {
                  switch (snapshot.data.toString()) {
                    case UpiIndiaResponseError.APP_NOT_INSTALLED:
                      return Text(
                        'App not installed.',
                      );
                      break;
                    case UpiIndiaResponseError.INVALID_PARAMETERS:
                      return Text(
                        'Requested payment is invalid.',
                      );
                      break;
                    case UpiIndiaResponseError.USER_CANCELLED:
                      return Text(
                        'It seems like you cancelled the transaction.',
                      );
                      break;
                    case UpiIndiaResponseError.NULL_RESPONSE:
                      return Text(
                        'No data received',
                      );
                      break;
                    default:
                      UpiIndiaResponse _upiResponse;
                      _upiResponse = UpiIndiaResponse(snapshot.data);
                      String txnId = _upiResponse.transactionId;
                      String resCode = _upiResponse.responseCode;
                      String txnRef = _upiResponse.transactionRefId;
                      String status = _upiResponse.status;
                      String approvalRef = _upiResponse.approvalRefNo;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('Transaction Id: $txnId'),
                          Text('Response Code: $resCode'),
                          Text('Reference Id: $txnRef'),
                          Text('Status: $status'),
                          Text('Approval No: $approvalRef'),
                        ],
                      );
                  }
                }
              },
            ),
          )
        ],
      ),
    );
  }
}