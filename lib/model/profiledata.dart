import 'package:flutter/cupertino.dart';
import 'package:veli/authentication/auth.dart';

class ProfileData with ChangeNotifier {
  final String name;
  final String userId;
  final String address;
  final String phone;

  Auth authentication = new Auth();
  ProfileData({this.name, this.userId, this.address, this.phone});

  Future<List<String>> getProfileInfo() async {
    notifyListeners();
    return [
      await authentication.getName(),
      await authentication.currentUser(),
      await authentication.getEmail(),
      await authentication.getPhoto()
    ];
  }
}
