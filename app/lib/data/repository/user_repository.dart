import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  static const String _keyName = 'user_name';

  Future<bool> saveName(String name) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_keyName, name);
    } catch (e) {
      debugPrint("Error saving name: $e");
      return false;
    }
  }

  Future<String?> getName() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyName);
    } catch (e) {
      debugPrint("Error getting name: $e");
      return null;
    }
  }

  Future<bool> deleteName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(_keyName);
  }
}