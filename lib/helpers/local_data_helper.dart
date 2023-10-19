import 'package:shared_preferences/shared_preferences.dart';

class LocalDataHelper {
  static late SharedPreferences preferences;

  static Future setInstance() async {
    preferences = await SharedPreferences.getInstance();
  }

  // キー
  static const String userTokenKey = 'user_token';
  static const String userLoginIdKey = 'user_login_id';

  // getter
  static String? get userToken => preferences.getString(userTokenKey);
  static String? get userId => preferences.getString(userLoginIdKey);

  // setter
  static set setUserToken(String token) =>
      preferences.setString(userTokenKey, token);
  static set setUserId(String userId) =>
      preferences.setString(userLoginIdKey, userId);
}
