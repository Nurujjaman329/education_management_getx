import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';

class UpdatePasswordService {
  final Dio client;

  UpdatePasswordService(this.client);

  Future<String> updatePassword(String userId, String oldPassword, String newPassword) async {
    try {
      log('userId: $userId');
      log('oldPassword: $oldPassword');
      log('newPassword: $newPassword');

      final response = await client.put(
        '/api/Auth/s/UpdatePassword/?userId=$userId&oldPassWord=$oldPassword&newPassWord=$newPassword',
      );

      log("Uri --<> ${response.realUri}");
      final responseData = response.data as String;
      log('Response Data: $responseData');

      if (responseData == "PassWord is Update....") {
        return responseData;
      } else {
        throw InputException("Unexpected response: $responseData");
      }
    } catch (error) {
      log('Error -> ${error.toString()}');
      throw InputException("Failed to update password: ${error.toString()}");
    }
  }
}
