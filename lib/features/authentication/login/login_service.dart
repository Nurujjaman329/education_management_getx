import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/features/authentication/auth_storage_service.dart';
import 'package:edex_365_getx/features/authentication/login/model/login_response.dart';


class LoginService {
  final Dio _dio;
  final AuthStorageService _storageService = AuthStorageService();

  LoginService(this._dio);

  Future<LoginResponse> login({
    required String mobileNo,
    required String password,
    required String deviceToken,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        'mobileNo': mobileNo,
        'password': '[PROTECTED]',
        'deviceToken': deviceToken,
      };

      log('Sending Login Request', name: 'LoginService');
      log('Request Body: $requestBody', name: 'LoginService');

      final response = await _dio.post(
        '/api/Auth/Login',
        data: {
          'mobileNo': mobileNo,
          'password': password,
          'deviceToken': deviceToken,
        },
      );

      log('Login response status: ${response.statusCode}', name: 'LoginService');
      log('Login response data: ${response.data}', name: 'LoginService');

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);

        // ✅ Use _storageService instead of _secureStorage
        await _storageService.saveToken(loginResponse.token);
        await _storageService.saveUserType(loginResponse.type);

        log('Token and user_type saved securely', name: 'LoginService');

        return loginResponse;
      } else {
        log('Login failed: ${response.statusMessage}', name: 'LoginService');
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } catch (e, stackTrace) {
      log('Login exception: $e', name: 'LoginService', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
