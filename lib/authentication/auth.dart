import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> signInWithGoogle();
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

  Future<String> signInWithGoogle() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    final snapShot =
        await Firestore.instance.collection('users').document(user.uid).get();
    if (!snapShot.exists) {
      Firestore.instance.collection("users").document(user.uid).setData({
        "uid": user.uid,
        "name": user.displayName,
        "email": user.email,
        "phone": user.phoneNumber,
        "address": null,
        "orders": null
      });
    } else {
      print("User Exists");
    }

    notifyListeners();

    return user.uid;
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    AuthResult authResult = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = authResult.user;
    final snapShot =
        await Firestore.instance.collection('users').document(user.uid).get();
    if (!snapShot.exists) {
      Firestore.instance.collection("users").document(user.uid).setData({
        "uid": user.uid,
        "name": user.displayName,
        "email": user.email,
        "phone": user.phoneNumber,
        "address": null,
        "orders": null
      });
    } else {
      print("User Exists");
    }
    notifyListeners();

    return user.uid;
  }

  Future<String> currentUser() async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      notifyListeners();

      return user.uid;
    } catch (e) {
      return null;
    }
  }

  Future<String> getEmail() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    notifyListeners();

    return user.email;
  }

  Future<String> getName() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    notifyListeners();

    return user.displayName;
  }

  Future<String> getPhoto() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    notifyListeners();

    return user.photoUrl;
  }

  Future<void> signOut() {
    notifyListeners();
    try {
      return FirebaseAuth.instance.signOut();
    } catch (e) {
      return null;
    }
  }
}
