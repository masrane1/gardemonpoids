import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<void> saveUserSession(String userId, String userName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('userName', userName);
  }

  Future<Map<String, String?>> getUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final userName = prefs.getString('userName');
    return {'userId': userId, 'userName': userName};
  }

  Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userName');
  }
}
