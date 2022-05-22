import 'package:flutter/widgets.dart'; // cupertino 하위 widgets에 구현되어 있음 => 사이즈가 cupertino가 더 크니까 widgets로 import하자

class UserProvider extends ChangeNotifier {
  bool _userLoggedIn = false; // _가 붙으면 private임

  void setUserAuth(bool authState) {
    this._userLoggedIn = authState;
    notifyListeners(); // 변경사항을 알림
  }

  bool get userState => this._userLoggedIn;
}