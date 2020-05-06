import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:provider/provider.dart';
import 'package:veli/model/profiledata.dart';

class Profile extends StatefulWidget {
  static const routeName = "/profile";

  @override
  _ProfileState createState() => _ProfileState();
}

String name;
String address;
String phone;
String uid;

class _ProfileState extends State<Profile> {
  bool editingMode = false;
  final formKey = new GlobalKey<FormState>();

  void editingModeChange() {
    print("Call");
    setState(() {
      editingMode = true;
    });
  }

  void saveChangesToDatabase() {
    final form = formKey.currentState;

    if (form.validate() && uid != null) {
      form.save();
      if (name == null) {
        Firestore.instance
            .collection("users")
            .document(uid)
            .updateData({"phone": phone, "address": address});

        setState(() {
          editingMode = false;
        });
      } else {
        Firestore.instance
            .collection("users")
            .document(uid)
            .updateData({"name": name, "phone": phone, "address": address});

        setState(() {
          editingMode = false;
        });
      }
    }
  }

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
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Colors.white10,
              elevation: 0,
              title: Text("Profile"),
            ),
            body: _buildBody(context, snapshot, editingMode, editingModeChange,
                saveChangesToDatabase, formKey),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

Widget _buildBody(
  BuildContext context,
  AsyncSnapshot<List<String>> snapshotProfileData,
  bool editingMode,
  void Function() editingModeChange,
  void Function() saveChangesToDatabase,
  GlobalKey<FormState> formKey,
) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance
        .collection("users")
        .where("uid", isEqualTo: snapshotProfileData.data.elementAt(1))
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      return _buildList(
          context,
          snapshot.data.documents,
          snapshotProfileData,
          editingMode,
          editingModeChange,
          saveChangesToDatabase,
          formKey,
          name,
          address,
          phone,
          uid);
    },
  );
}

Widget _buildList(
    BuildContext context,
    List<DocumentSnapshot> snapshot,
    AsyncSnapshot<List<String>> snapshotProfileData,
    bool editingMode,
    void Function() editingModeChange,
    void Function() saveChangesToDatabase,
    GlobalKey<FormState> formKey,
    String name,
    String address,
    String phone,
    String uid) {
  try {
    return ListView(
      padding: const EdgeInsets.only(top: 40.0),
      children: snapshot
          .map((data) => _buildListItem(
                context,
                data,
                snapshotProfileData,
                editingMode,
                editingModeChange,
                saveChangesToDatabase,
                formKey,
              ))
          .toList(),
    );
  } catch (e) {
    print(e);
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Sorry, there must a technical error !"),
        Text("Contact Administator !"),
      ],
    ));
  }
}

Widget _buildListItem(
  BuildContext context,
  DocumentSnapshot data,
  AsyncSnapshot<List<String>> snapshotProfileData,
  bool editingMode,
  void Function() editingModeChange,
  void Function() saveChangesToDatabase,
  GlobalKey<FormState> formKey,
) {
  final record = Record.fromSnapshot(data);

  if (editingMode == false) {
    return Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(500),
          child: (snapshotProfileData.data.elementAt(3) != null)
              ? Image.network(
                  snapshotProfileData.data.elementAt(3),
                  scale: .6,
                )
              : Image.network(
                  "https://splattai.com/img/login-user-icon.png",
                  height: 200,
                ),
        ),
        GFListTile(
          title: Text(
            "Name",
            style: TextStyle(fontWeight: FontWeight.w200),
          ),
          subTitle: (record.name != null)
              ? Text(
                  record.name,
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
                )
              : Text(
                  "Not Set",
                ),
          icon:
              IconButton(icon: Icon(Icons.edit), onPressed: editingModeChange),
        ),
        GFListTile(
          title: Text(
            "Email",
            style: TextStyle(fontWeight: FontWeight.w200),
          ),
          subTitle: (record.email != null)
              ? Text(
                  record.email,
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
                )
              : Text("Not Set"),
        ),
        GFListTile(
          title: Text(
            "Address",
            style: TextStyle(fontWeight: FontWeight.w200),
          ),
          subTitle: (record.address != null)
              ? Text(
                  record.address,
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
                )
              : Text("Not Set"),
          icon:
              IconButton(icon: Icon(Icons.edit), onPressed: editingModeChange),
        ),
        GFListTile(
          title: Text(
            "Phone",
            style: TextStyle(fontWeight: FontWeight.w200),
          ),
          subTitle: (record.phone != null)
              ? Text(
                  record.phone,
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
                )
              : Text("Not Set"),
          icon:
              IconButton(icon: Icon(Icons.edit), onPressed: editingModeChange),
        ),
      ],
    );
  } else {
    uid = snapshotProfileData.data.elementAt(1);
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(500),
            child: (snapshotProfileData.data.elementAt(3) != null)
                ? Image.network(
                    snapshotProfileData.data.elementAt(3),
                    scale: .6,
                  )
                : Image.network(
                    "https://splattai.com/img/login-user-icon.png",
                    height: 200,
                  ),
          ),
          GFListTile(
            title: Text(
              "Name",
              style: TextStyle(fontWeight: FontWeight.w200),
            ),
            subTitle: (record.name != null)
                ? TextFormField(
                    initialValue: record.name,
                    validator: (value) =>
                        value.isEmpty ? "Name cannot be empty." : null,
                    onChanged: (value) => name = value,
                  )
                : TextFormField(
                    validator: (value) =>
                        value.isEmpty ? "Name cannot be empty." : null,
                    onChanged: (value) => name = value,
                  ),
          ),
          GFListTile(
            title: Text(
              "Email",
              style: TextStyle(fontWeight: FontWeight.w200),
            ),
            subTitle: (record.email != null)
                ? Text(
                    record.email,
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
                  )
                : Text("Not Set"),
          ),
          GFListTile(
              title: Text(
                "Address",
                style: TextStyle(fontWeight: FontWeight.w200),
              ),
              subTitle: (record.address != null)
                  ? TextFormField(
                      initialValue: record.address,
                      validator: (value) =>
                          value.isEmpty ? "Name cannot be empty." : null,
                      onChanged: (value) => name = value,
                    )
                  : TextFormField(
                      validator: (value) =>
                          value.isEmpty ? "Address cannot be empty." : null,
                      onChanged: (value) => address = value,
                    )),
          GFListTile(
              title: Text(
                "Phone",
                style: TextStyle(fontWeight: FontWeight.w200),
              ),
              subTitle: (record.phone != null)
                  ? TextFormField(
                      initialValue: record.phone,
                      validator: (value) =>
                          value.isEmpty ? "Name cannot be empty." : null,
                      onChanged: (value) => name = value,
                    )
                  : TextFormField(
                      validator: (value) =>
                          value.isEmpty ? "Phone cannot be empty." : null,
                      onChanged: (value) => phone = value)),
          GFButton(
            size: GFSize.LARGE,
            color: Colors.black,
            onPressed: saveChangesToDatabase,
            text: "Save",
            shape: GFButtonShape.square,
          )
        ],
      ),
    );
  }
}

class Record {
  final String address;
  final String email;
  final String name;
  final String phone;
  final String uid;

  final DocumentReference reference;

//Add variables/field
  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : address = map['address'],
        name = map['name'],
        email = map['email'],
        phone = map['phone'],
        uid = map['uid'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
