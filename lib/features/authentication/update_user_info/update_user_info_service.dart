import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/authentication/update_user_info/model/update_user_info_response_model.dart';


class UpdateUserInfoService {
  final Dio client;

  UpdateUserInfoService(this.client);

  Future<UpdateUserInfoResponseModel> updateUser(UpdateDetailsResponseBody body) async {
    try {
      final formData = await body.toFormData();

      log('Sending form data: ${formData.fields}');
      final response = await client.put('/api/Auth/s/Update', data: formData);
      log('Response data: ${response.data}');
      log('Response URI: ${response.realUri}');

      switch (response.statusCode) {
        case 200:
          return UpdateUserInfoResponseModel.fromJson(response.data);
        case 400:
          final errorMsg = response.data['errors'];
          throw InputException("Validation Error: ${errorMsg ?? 'Input Error'}");
        case 404:
          throw AuthException();
        default:
          throw ServerException();
      }
    } catch (error) {
      if (error is DioException && error.response?.data['errors'] != null) {
        throw InputException("Validation Error: ${error.response?.data['errors']}");
      }
      throw ServerException();
    }
  }
}
