import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';

class ForgotPasswordService {
  final Dio client;
  ForgotPasswordService(this.client);

  Future<String> forgotPasswordSendOtp(String mobileNo) async {
    try {
      log('Sending OTP to mobile number: $mobileNo');
      final response = await client.put(
        '/api/Auth/s/ForgotPasswordSendOTP',
        data: {"mobileNo": mobileNo},
      );
      final responseData = response.data;
      if (responseData is Map && responseData['message'] == "Success") {
        return responseData['message'];
      } else {
        throw InputException("Unexpected response: $responseData");
      }
    } catch (error) {
      throw InputException("Failed to send OTP: ${error.toString()}");
    }
  }

  Future<String> forgotPasswordVerifyOtp(String mobileNo, String otp) async {
    try {
      final response = await client.put(
        '/api/Auth/s/ForgotPasswordVerifyOTP',
        data: {"mobileNo": mobileNo, "otp": otp},
      );
      final responseData = response.data;
      if (responseData is Map && responseData['message'] == "Success") {
        return responseData['message'];
      } else {
        throw InputException("Unexpected response: $responseData");
      }
    } catch (error) {
      throw InputException("Failed to verify OTP: ${error.toString()}");
    }
  }

  Future<String> forgotPasswordConfirm(String mobileNo, String password) async {
    try {
      final response = await client.put(
        '/api/Auth/s/ForgotPasswordConfirm',
        data: {"mobileNo": mobileNo, "password": password},
      );
      final responseData = response.data;
      if (responseData is Map && responseData['message'] == "Success") {
        return responseData['message'];
      } else {
        throw InputException("Unexpected response: $responseData");
      }
    } catch (error) {
      throw InputException("Failed to confirm password: ${error.toString()}");
    }
  }
}
