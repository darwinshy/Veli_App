import 'find_restro.dart';
import 'sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('asset/vl4.png', width: 100, height: 100),
              SizedBox(height: 10),
              Text(
                'Veli',
                style: TextStyle(fontFamily: 'sam', fontSize: 25),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 350, 0, 00),
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SignInButton(
                      Buttons.Google,
                      onPressed: () async {
                        signInWithGoogle().whenComplete(() {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return FindRestroScreen(); //DemoScreen can be user profile also
                              },
                            ),
                          );
                        });
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SignInButton(
                      Buttons.Facebook,
                      onPressed: () async {
                        signInWithGoogle().whenComplete(() {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return FindRestroScreen(); //DemoScreen can be user profile also
                              },
                            ),
                          );
                        });
                      },
                    ),
                  ])
            ],
          ),
        ),
      ),
    );
  }
}
