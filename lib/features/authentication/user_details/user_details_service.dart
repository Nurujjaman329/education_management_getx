import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/authentication/user_details/model/user_details_response_model.dart';


class UserDetailsService {
  final Dio client;

  UserDetailsService(this.client);

  Future<List<UserDetailsResponseModel>> getUserDetails(String userId) async {
    final String url = "/api/auth/s/User/$userId";

    try {
      log("Fetching user details for userId: $userId");
      final response = await client.get(url);

      log("Response Status Code: ${response.statusCode}");
      log("Response Data: ${response.data}");
      log("Request URI: ${response.realUri}");

      if (response.statusCode == 200) {
        final List<dynamic> body = response.data;
        return body.map((e) => UserDetailsResponseModel.fromJson(e)).toList();
      } else if (response.statusCode == 404) {
        throw AuthException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      log("Error fetching user details: $e");
      rethrow;
    }
  }
}
