import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_study_1/data/user_model.dart';
import 'package:flutter_study_1/repository/user_service.dart';
import 'package:flutter_study_1/utils/logger.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
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
  UserModel? _userModel;

  UserProvider() {
    initState();
  }

  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((user) async{
      _user = user;
      await _setNewUser(_user);
      notifyListeners();
    });
  }

  Future _setNewUser(User? user) async {
   
    if(user != null && user.phoneNumber != null) {
      final prefs = await SharedPreferences.getInstance();
      final String address = prefs.getString(SHARED_ADDRESS) ?? "";
      double lat = prefs.getDouble(SHARED_LAT) ?? 0;
      double lon = prefs.getDouble(SHARED_LON) ?? 0;
      String phoneNum = user.phoneNumber!;
      String userKey = user.uid;
      
      UserModel userModel = UserModel(userKey: user.uid, phoneNum: phoneNum, address: address, createTime: DateTime.now().toUtc(),
                                      geoFirePoint: GeoFirePoint(lat,lon));

      // 기존 유저가 존재하지 않을 경우 새로 생성
      await UserService().createNewUser(userModel.toJson(), user.uid);

      _userModel = await  UserService().getUserModel(user.uid);

      logger.d(_userModel!.toJson().toString());

    }
  }

  User? get user => this._user;

}