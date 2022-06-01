import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constraints/shared_pref_keys.dart'; // cupertino 하위 widgets에 구현되어 있음 => 사이즈가 cupertino가 더 크니까 widgets로 import하자

class UserProvider extends ChangeNotifier {
  // bool _userLoggedIn = false; // _가 붙으면 private임
  //
  // void setUserAuth(bool authState) {
  //   this._userLoggedIn = authState;
  //   notifyListeners(); // 변경사항을 알림
  // }
  //
  // bool get userState => this._userLoggedIn;

  User? _user;

  UserProvider() {
    initState();
  }

  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  void _setNewUser(User? user) async {
    _user = user;
    if(user != null) {
      final prefs = await SharedPreferences.getInstance();
      final String address = prefs.getString(SHARED_ADDRESS) ?? "";
      double lat = prefs.getDouble(SHARED_LAT) ?? 0;
      double lon = prefs.getDouble(SHARED_LON) ?? 0;
      String phoneNum = user.phoneNumber!;
      String userKey = user.uid;
    }
  }

  User? get user => this._user;

}