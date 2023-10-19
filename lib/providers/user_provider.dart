import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  User? get user => _user;

  String? _loginId;
  String? get loginId => _loginId;

  String? _password;
  String? get password => _password;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void setLoggedInUserInfo(String userId, String password) {
    _loginId = userId;
    _password = password;
    notifyListeners();
  }
}
