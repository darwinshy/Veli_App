import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> currentUser();
  Future<void> signOut();
}

class Auth extends BaseAuth with ChangeNotifier {
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    AuthResult authResult = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = authResult.user;
    notifyListeners();

    return user.uid;
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    AuthResult authResult = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = authResult.user;
    notifyListeners();

    return user.uid;
  }

  Future<String> currentUser() async {
    // getStringValuesSF();
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    notifyListeners();
    return user.uid;
  }

  // getStringValuesSF() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String stringValue = prefs.getString('userId');
  //   print(stringValue);
  //   // return stringValue;
  // }

  Future<void> signOut() {
    notifyListeners();
    return FirebaseAuth.instance.signOut();
  }
}
