import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/core/network/dio_client.dart';
import 'package:edex_365_getx/features/shared_panel/model/all_version_class_list_response_model.dart';
import 'package:edex_365_getx/features/shared_panel/model/subject_response_model.dart';
import 'package:edex_365_getx/features/shared_panel/model/user_details_response_model.dart';
import 'package:edex_365_getx/features/shared_panel/model/user_role_response_model.dart';
import '../model/academy_version_list_response_model.dart';

class SharedService {
  final Dio client = DioClient.getInstance();

  Future<List<AcademyVersionListResponseModel>> fetchVersion() async {
    try {
      final response = await client.get("/api/PostType/s/GetAllPostType");

     // log('Version API response: ${response.data}');
      switch (response.statusCode) {
        case 200:
          List<dynamic> data = response.data;
          return data.map((e) => AcademyVersionListResponseModel.fromJson(e)).toList();
        case 404:
          throw AuthException();
        default:
          throw ServerException();
      }
    } catch (e) {
    //  log("Version fetch error: $e");
      rethrow;
    }
  }

  Future<List<AllVersionClassListResponseModel>> fetchBanglaVersionClassList() async {
    try {
      final response = await client.get("/api/class/s/AllClass");

    //  log('Bangla Class API response: ${response.data}');
      switch (response.statusCode) {
        case 200:
          List<dynamic> data = response.data;
          return data.map((e) => AllVersionClassListResponseModel.fromJson(e)).toList();
        case 404:
          throw AuthException();
        default:
          throw ServerException();
      }
    } catch (e) {
    //  log("Bangla class fetch error: $e");
      rethrow;
    }
  }

    Future<List<AllVersionClassListResponseModel>> fetchEnglishVersionClassList() async {
    try {
      final response = await client.get("/api/EnglishClass/s/GetAllEnglishClass");

    //  log('English Class API response: ${response.data}');
      switch (response.statusCode) {
        case 200:
          List<dynamic> data = response.data;
          return data.map((e) => AllVersionClassListResponseModel.fromJson(e)).toList();
        case 404:
          throw AuthException();
        default:
          throw ServerException();
      }
    } catch (e) {
     // log("English class fetch error: $e");
      rethrow;
    }
  }


      Future<List<UserRolesResponseModel>> fetchUserRoleList() async {
    try {
      final response = await client.get("/api/Role/s/AllRoles");

     // log('User Roles API response: ${response.data}');
      switch (response.statusCode) {
        case 200:
          List<dynamic> data = response.data;
          return data.map((e) => UserRolesResponseModel.fromJson(e)).toList();
        case 404:
          throw AuthException();
        default:
          throw ServerException();
      }
    } catch (e) {
     // log("User roles fetch error: $e");
      rethrow;
    }
  }


        Future<List<SubjectResponseModel>> fetchSubjectList() async {
    try {
      final response = await client.get("/api/subject/s/AllSubject");

      //log('Subject API response: ${response.data}');
      switch (response.statusCode) {
        case 200:
          List<dynamic> data = response.data;
          return data.map((e) => SubjectResponseModel.fromJson(e)).toList();
        case 404:
          throw AuthException();
        default:
          throw ServerException();
      }
    } catch (e) {
      //log("Subject fetch error: $e");
      rethrow;
    }
  }


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

