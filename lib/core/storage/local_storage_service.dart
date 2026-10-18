import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  static Future<LocalStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  // Generic String get / set
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  // Generic JSON Object get / set
  Future<bool> setJsonObject(String key, Map<String, dynamic> jsonMap) async {
    return await setString(key, jsonEncode(jsonMap));
  }

  Map<String, dynamic>? getJsonObject(String key) {
    final str = getString(key);
    if (str == null) return null;
    try {
      return jsonDecode(str) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  // Generic JSON List get / set
  Future<bool> setJsonList(String key, List<dynamic> list) async {
    return await setString(key, jsonEncode(list));
  }

  List<dynamic>? getJsonList(String key) {
    final str = getString(key);
    if (str == null) return null;
    try {
      return jsonDecode(str) as List<dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}
