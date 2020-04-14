import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veli/model/profiledata.dart';

class Profile extends StatelessWidget {
  static const routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileData>(context);
    return FutureBuilder<List<String>>(
      future: profile.getProfileInfo(),
      builder: (context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          return Scaffold(
            appBar: AppBar(
              title: Text("Profile"),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipRRect(borderRadius: BorderRadius.circular(500),
                  child: Image.network(snapshot.data[3]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Text("Email : "), Text(snapshot.data[0])],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Text("UID : "), Text(snapshot.data[1])],
                ),
              ],
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
