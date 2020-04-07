import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veli/authentication/auth.dart';
import 'package:veli/login_page.dart';
import 'screens/find_restro.dart';

class RootPage extends StatefulWidget {
  static final routeName = '/rootpage';

  final BaseAuth auth;
  RootPage(this.auth);
  @override
  _RootPageState createState() => _RootPageState();
}

enum AuthStatus { notSignedIn, signedIn }

class _RootPageState extends State<RootPage> {
  AuthStatus signStatus = AuthStatus.notSignedIn;

  @override
  void initState() {
    widget.auth.currentUser().then((userId) {
      setState(() {
        signStatus =
            userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
    super.initState();
  }

  void _signedIn() {
    setState(() {
      signStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      signStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (signStatus) {
      case AuthStatus.notSignedIn:
        return LoginPage(auth: widget.auth, onSignedIn: _signedIn);
        break;
      case AuthStatus.signedIn:
        return FindRestroScreen(auth: widget.auth, onSignedOut: _signedOut);
        break;
      default:
        return FindRestroScreen(auth: widget.auth, onSignedOut: _signedOut);
    }
  }
}
