import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/authentication/otp_verify/model/otp_verify_response_model.dart';

class OtpVerifyService {
  final Dio client;

  OtpVerifyService(this.client);

  Future<OtpVerifyResponseModel> verifyOtp(String id, String otp) async {
    try {
      log('ID: $id');
      log('OTP: $otp');

      final response = await client.post(
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
