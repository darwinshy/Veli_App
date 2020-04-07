import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

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
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    notifyListeners();
    return user.uid;
  }

  Future<void> signOut() {
    notifyListeners();
    return FirebaseAuth.instance.signOut();
  }
}
