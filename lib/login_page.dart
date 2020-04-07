// import 'find_restro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './authentication/auth.dart';

class LoginPage extends StatefulWidget {
  final BaseAuth auth;
  LoginPage({this.auth, this.onSignedIn});
  final VoidCallback onSignedIn;

  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validatAndSubmit() async {
    if (validateAndSave()) {
      String userId;
      try {
        if (_formType == FormType.login) {
          userId =
              await widget.auth.signInWithEmailAndPassword(_email, _password);
        }
        if (_formType == FormType.register) {
          userId = await widget.auth
              .createUserWithEmailAndPassword(_email, _password);
        }
        // addStringToSF(userId);
        print(userId);
        widget.onSignedIn();
      } catch (e) {}
    }
  }

  // addStringToSF(String id) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('userId', id);
  //   print("Successfully Saved " + id);
  // }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

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
                _formType == FormType.login ? 'Login.' : 'Register',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 60.0,
                    fontFamily: "QuickSand",
                    color: Colors.black87),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ...buildInputs(),
                      SizedBox(
                        height: 10,
                      ),
                      ...buildSubmitButtons(),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      Text(
        "Email",
        style: TextStyle(fontFamily: "QuickSand"),
      ),
      TextFormField(
        validator: (value) => value.isEmpty ? "Email cannot be empty." : null,
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) => _email = value,
      ),
      SizedBox(
        height: 20,
      ),
      Text(
        "Password",
        style: TextStyle(fontFamily: "QuickSand"),
      ),
      TextFormField(
        validator: (value) =>
            value.isEmpty ? "Password cannot be empty." : null,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        onSaved: (value) => _password = value,
      )
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        GFButton(
          fullWidthButton: true,
          size: GFSize.LARGE,
          color: Colors.black,
          onPressed: validatAndSubmit,
          text: "Login",
          shape: GFButtonShape.square,
        ),
        SizedBox(
          height: 30,
        ),
        Center(child: Text("Don't have a account ?")),
        SizedBox(
          height: 10,
        ),
        GFButton(
          fullWidthButton: true,
          size: GFSize.LARGE,
          color: Colors.black,
          onPressed: moveToRegister,
          text: "Register Now",
          shape: GFButtonShape.square,
        ),
      ];
    } else {
      return [
        GFButton(
          fullWidthButton: true,
          size: GFSize.LARGE,
          color: Colors.black,
          onPressed: validatAndSubmit,
          text: "Register",
          shape: GFButtonShape.square,
        ),
        SizedBox(
          height: 30,
        ),
        Center(child: Text("Already have a account ?")),
        SizedBox(
          height: 10,
        ),
        GFButton(
          fullWidthButton: true,
          size: GFSize.LARGE,
          color: Colors.black,
          onPressed: moveToLogin,
          text: "Login Here ",
          shape: GFButtonShape.square,
        )
      ];
    }
  }
}

// Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: <Widget>[
//       SignInButton(
//         Buttons.Google,
//         onPressed: () async {
// signInWithGoogle().whenComplete(() {
//   Navigator.of(context).pushReplacement(
//     MaterialPageRoute(
//       builder: (context) {
//         return FindRestroScreen(); //DemoScreen can be user profile also
//       },
//     ),
//   );
//     // });
//   },
// ),
//       SizedBox(
//         height: 5,
//       ),
//       SignInButton(
//         Buttons.Facebook,
//         onPressed: () async {
//           signInWithGoogle().whenComplete(() {
//             Navigator.of(context).pushReplacement(
// MaterialPageRoute(
//   builder: (context) {
//     return FindRestroScreen(); //DemoScreen can be user profile also
//   },
// ),
//             );
//           });
//         },
//       ),
//     ])
