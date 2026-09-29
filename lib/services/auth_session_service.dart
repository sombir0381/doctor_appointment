import 'package:shared_preferences/shared_preferences.dart';

class AuthSessionService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _roleKey = 'user_role';

  static Future<void> saveSession({
    required String role,
  }) async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.setBool(
      _isLoggedInKey,
      true,
    );

    await prefs.setString(
      _roleKey,
      role,
    );
  }

  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    return prefs.getBool(
      _isLoggedInKey,
    ) ??
        false;
  }

  static Future<String?> getRole() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    return prefs.getString(
      _roleKey,
    );
  }

  static Future<void> logout() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.remove(
      _isLoggedInKey,
    );

    await prefs.remove(
      _roleKey,
    );
  }
}