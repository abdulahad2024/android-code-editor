import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: AppConstants.keyAuthToken, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: AppConstants.keyAuthToken);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: AppConstants.keyAuthToken);
  }

  Future<void> saveApiKey(String keyName, String apiKeyValue) async {
    await _storage.write(key: keyName, value: apiKeyValue);
  }

  Future<String?> getApiKey(String keyName) async {
    return await _storage.read(key: keyName);
  }
}
