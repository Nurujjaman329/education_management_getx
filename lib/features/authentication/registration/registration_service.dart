import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:edex_365_getx/features/authentication/registration/model/registration_response_model.dart';
import 'package:edex_365_getx/features/authentication/registration/model/signup_details_body.dart';

class RegistrationService {
  final Dio client = Dio();

  Future<RegistrationResponseModel> postRegister(SignUpDetailsBody body) async {
    try {
      final formDataMap = {
        'name': body.name,
        'mobileNo': body.mobileNo,
        'email': body.email,
        'password': body.password,
        if (body.dob != null) 'dob': body.dob!.toIso8601String(),
        if (body.role.isNotEmpty) 'role': body.role,
        if (body.subject.isNotEmpty) 'subject': body.subject,
        if (body.image != null)
          'image': await MultipartFile.fromFile(body.image!.path, filename: body.image!.path.split('/').last),
        if (body.cv != null)
          'cv': await MultipartFile.fromFile(body.cv!.path, filename: body.cv!.path.split('/').last),
        if (body.academicImage != null)
          'academicImage': await MultipartFile.fromFile(body.academicImage!.path, filename: body.academicImage!.path.split('/').last),
      };

      // Log each field
      formDataMap.forEach((key, value) {
        if (value is MultipartFile) {
          log('$key: ${value.filename}');
        } else {
          log('$key: $value');
        }
      });

      final response = await client.post(
        'https://api.edex365.com/api/Auth/s/Signup',
        data: FormData.fromMap(formDataMap),
      );

      log('Response: ${response.data}');
      log('StatusCode: ${response.statusCode}');

      switch (response.statusCode) {
        case 200:
          return RegistrationResponseModel.fromJson(response.data);
        case 400:
          throw Exception("Input Error");
        case 404:
          throw Exception("User not found");
        default:
          throw Exception("Unknown Error");
      }
    } catch (e) {
      log('Registration error: $e');
      rethrow;
    }
  }
}
