//import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:veli/payment.dart';

///import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'package:splashscreen/splashscreen.dart';

void main() => runApp(new MediaQuery(
    data: new MediaQueryData(),
    child: new MaterialApp(
      home: new MyApp(),
      debugShowCheckedModeBanner: false,
    )));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 4,
      navigateAfterSeconds: new LoginPage(),
      title: new Text(
        'Veli',
        style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40.0,
            fontFamily: "sam",
            color: Colors.black87),
      ),
      backgroundColor: Colors.white,
      loadingText: Text(
        "made with love for",
        style: TextStyle(fontFamily: "QuickSand", color: Colors.black38),
      ),
      subtitle: Text(
        "NIT Silchar",
        style: TextStyle(fontFamily: "QuickSand", color: Colors.black38),
      ),
      photoSize: 100.0,
    );
  }
}
