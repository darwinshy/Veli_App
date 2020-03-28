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
        seconds: 2,
        image: Image.asset('asset/vl4.png'),
        photoSize: 60.0,
        navigateAfterSeconds: LoginPage());
  }
}

