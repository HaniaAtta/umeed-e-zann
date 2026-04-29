import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for managing secure storage (encrypted data)
/// Use this for sensitive data like tokens, passwords, API keys
class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    // Android options
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    // iOS options - using default accessibility
    iOptions: IOSOptions(),
  );

  /// Save string value
  static Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Read string value
  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete specific key
  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Delete all secure storage
  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// Check if key exists
  static Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }

  /// Get all keys
  static Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }
}

