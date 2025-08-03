import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/authentication/model/otp_verify_response_model.dart';
import 'package:edex_365_getx/features/authentication/model/parameter_body/signup_request_body.dart';
import '../../../core/network/dio_client.dart';
import '../model/login_response.dart';
import '../model/registration_response.dart';
import 'dart:developer';

class AuthService {
  final Dio _dio = DioClient.getInstance();

  Future<LoginResponse> login({
    required String mobileNo,
    required String password,
    required String deviceToken,
  }) async {
    try {
      final response = await _dio.post('/api/Auth/Login', data: {
        'mobileNo': mobileNo,
        'password': password,
        'deviceToken': deviceToken,
      });

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception("Login API error: $e");
    }
  }

  Future<RegistrationResponseModel> register(SignUpRequestBody body) async {
    try {
      final formData = FormData.fromMap({
        'name': body.name,
        'mobileNo': body.mobileNo,
        'image': body.image != null
            ? await MultipartFile.fromFile(body.image!.path)
            : null,
        'email': body.email,
        'password': body.password,
        'dob': body.dob?.toIso8601String(),
        'cv': body.cv != null
            ? await MultipartFile.fromFile(body.cv!.path)
            : null,
        'academicImage': body.academicImage != null
            ? await MultipartFile.fromFile(body.academicImage!.path)
            : null,
        'subject': body.subject,
        'role': body.role,
      });

      final response = await _dio.post('/api/Auth/s/Signup', data: formData);

      if (response.statusCode == 200) {
        return RegistrationResponseModel.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception("Registration API error: $e");
    }
  }

    Future<OtpVerifyResponseModel> verifyOtp(String id, String otp) async {
    try {
      log('ID: $id');
      log('OTP: $otp');

      final response = await _dio.post(
        '/api/Otp/s/VerifyOtp',
        data: jsonEncode(<String, String>{'id': id, 'otp': otp}),
      );

      final responseData = response.data as String;
      log('Response Data: $responseData');

      if (responseData == "Verifyed Otp..") {
        return OtpVerifyResponseModel(message: responseData);
      } else {
        throw InputException("Unexpected response: $responseData");
      }
    } catch (e) {
      log('OTP Verify Error: $e');
      throw InputException("Failed to verify OTP: ${e.toString()}");
    }
  }
}

