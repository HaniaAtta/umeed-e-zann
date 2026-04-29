import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing shared preferences (local storage)
/// Use this for non-sensitive data like theme, language, settings
class SharedPreferencesService {
  static SharedPreferences? _prefs;

  /// Initialize shared preferences
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Get SharedPreferences instance
  static Future<SharedPreferences> get instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // String methods
  static Future<bool> setString(String key, String value) async {
    final prefs = await instance;
    return await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await instance;
    return prefs.getString(key);
  }

  // Int methods
  static Future<bool> setInt(String key, int value) async {
    final prefs = await instance;
    return await prefs.setInt(key, value);
  }

  static Future<int?> getInt(String key) async {
    final prefs = await instance;
    return prefs.getInt(key);
  }

  // Bool methods
  static Future<bool> setBool(String key, bool value) async {
    final prefs = await instance;
    return await prefs.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    final prefs = await instance;
    return prefs.getBool(key);
  }

  // Double methods
  static Future<bool> setDouble(String key, double value) async {
    final prefs = await instance;
    return await prefs.setDouble(key, value);
  }

  static Future<double?> getDouble(String key) async {
    final prefs = await instance;
    return prefs.getDouble(key);
  }

  // List<String> methods
  static Future<bool> setStringList(String key, List<String> value) async {
    final prefs = await instance;
    return await prefs.setStringList(key, value);
  }

  static Future<List<String>?> getStringList(String key) async {
    final prefs = await instance;
    return prefs.getStringList(key);
  }

  // Remove method
  static Future<bool> remove(String key) async {
    final prefs = await instance;
    return await prefs.remove(key);
  }

  // Clear all
  static Future<bool> clear() async {
    final prefs = await instance;
    return await prefs.clear();
  }

  // Check if key exists
  static Future<bool> containsKey(String key) async {
    final prefs = await instance;
    return prefs.containsKey(key);
  }

  // Get all keys
  static Future<Set<String>> getKeys() async {
    final prefs = await instance;
    return prefs.getKeys();
  }
}

