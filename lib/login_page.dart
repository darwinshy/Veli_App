import 'find_restro.dart';
import 'sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:getflutter/getflutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Login.',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 80.0,
                    fontFamily: "QuickSand",
                    color: Colors.black87),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Username",
                      style: TextStyle(fontFamily: "QuickSand"),
                    ),
                    TextField(
                        // onChanged: (val) {
                        //   titleInput = val;
                        // },
                        // controller: _titleController,
                        // decoration: InputDecoration(labelText: "Enter Username"),

                        // autofocus: true,
                        ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Password",
                      style: TextStyle(fontFamily: "QuickSand"),
                    ),
                    TextField(
                      // onChanged: (val) {
                      //   amountInput = double.parse(val);
                      // },
                      keyboardType: TextInputType.visiblePassword,
                      // controller: _amountController,
                      // decoration: InputDecoration(labelText: "Enter Password"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GFButton(
                      fullWidthButton: true,
                      size: GFSize.LARGE,
                      color: Colors.black,
                      onPressed: () {},
                      text: "Login",
                      shape: GFButtonShape.square,
                    ),
                    GFButton(
                      fullWidthButton: true,
                      size: GFSize.LARGE,
                      color: Colors.black,
                      onPressed: () {},
                      text: "Register Now",
                      shape: GFButtonShape.square,
                    ),
                  ],
                ),
              )
              // Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: <Widget>[
              //       SignInButton(
              //         Buttons.Google,
              //         onPressed: () async {
              //           signInWithGoogle().whenComplete(() {
              //             Navigator.of(context).pushReplacement(
              //               MaterialPageRoute(
              //                 builder: (context) {
              //                   return FindRestroScreen(); //DemoScreen can be user profile also
              //                 },
              //               ),
              //             );
              //           });
              //         },
              //       ),
              //       SizedBox(
              //         height: 5,
              //       ),
              //       SignInButton(
              //         Buttons.Facebook,
              //         onPressed: () async {
              //           signInWithGoogle().whenComplete(() {
              //             Navigator.of(context).pushReplacement(
              //               MaterialPageRoute(
              //                 builder: (context) {
              //                   return FindRestroScreen(); //DemoScreen can be user profile also
              //                 },
              //               ),
              //             );
              //           });
              //         },
              //       ),
              //     ])
            ],
          ),
        ),
      ),
    );
  }
}
