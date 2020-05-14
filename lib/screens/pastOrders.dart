import 'package:flutter/material.dart';

class OrderResult extends StatelessWidget {
  static const routeName = '/orderresult';
  final String message;
  final bool result;
  

  OrderResult({this.result, this.message});
  @override
  Widget build(BuildContext context) {
    print(result);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white10,
        title: Text(
          "Order Summary",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: result
            ? Text(
                "Order Placed",
                style: TextStyle(
                  fontFamily: 'QuickSand',
                  fontSize: 26,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Order was not placed",
                    style: TextStyle(
                      fontFamily: 'QuickSand',
                      fontSize: 26,
                    ),
                  ),
                  Text(
                    message.toString(),
                    style: TextStyle(
                      fontFamily: 'QuickSand',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
