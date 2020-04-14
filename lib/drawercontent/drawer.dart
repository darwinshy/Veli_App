import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veli/authentication/auth.dart';
import 'package:veli/root.dart';
import 'package:veli/screens/profile.dart';

class DrawerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authenticationItems = Provider.of<Auth>(context);

    return Column(
      children: <Widget>[
        Container(
          height: 120,
          width: double.infinity,
          padding: EdgeInsets.only(top: 25, left: 15),
          alignment: Alignment.centerLeft,
          child: Text("Veli",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.black87)),
        ),
        SizedBox(height: 20),
        ListTile(
          leading: Icon(Icons.account_circle),
          title: Text("Profile"),
          onTap: () {
            Navigator.pushNamed(context, Profile.routeName);
          },
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text("Log Out"),
          onTap: () {
            authenticationItems.signOut().whenComplete(() {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) {
                    return RootPage(Auth());
                  },
                ),
              );
            });
          },
        )
      ],
    );
  }
}
