import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

// import 'package:shared_preferences/shared_preferences.dart';
class UserProfileDetails {
  String name;
  String email;
  String uid;
  String photourl;
  UserProfileDetails({this.name, this.email, this.uid,this.photourl});
}

//Google Login
bool isLoggedIn = false;
String userID;
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;
  Future uidToken = user.getIdToken();

  assert(!user.isAnonymous);
  assert(uidToken != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  setState(() {
    if (user == null) {
      isLoggedIn = false;
    } else {
      isLoggedIn = true;
      userID = user.uid;
    }
  });

  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // prefs?.setBool("isLoggedIn", true);
  final prf = UserProfileDetails(
    email: user.email,
    name: user.displayName,
    uid: user.uid,
    photourl: user.photoUrl
  );
  // print(user.displayName);
  // print(user.email);
  // print(user.uid);
  return "Successful";
}

//Facebook Login

Map userProfile;
final facebookLogin = FacebookLogin();

loginWithFB() async {
  final result = await facebookLogin.logIn(['email']);

  switch (result.status) {
    case FacebookLoginStatus.loggedIn:
      final token = result.accessToken.token;
      final graphResponse = await http.get(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
      final profile = JSON.jsonDecode(graphResponse.body);

      setState(() {
        userProfile = profile;
        isLoggedIn = true;
      });
      break;

    case FacebookLoginStatus.cancelledByUser:
      setState(() => isLoggedIn = false);
      break;
    case FacebookLoginStatus.error:
      setState(() => isLoggedIn = false);
      break;
  }
}

void setState(Null Function() param0) {}
