import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<void> saveUserType(String type) async {
    await _storage.write(key: 'user_type', value: type);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<String?> getUserType() async {
    return await _storage.read(key: 'user_type');
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
