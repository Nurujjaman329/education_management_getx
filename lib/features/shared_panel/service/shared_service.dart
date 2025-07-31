import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/core/network/dio_client.dart';
import 'package:edex_365_getx/features/shared_panel/model/all_version_class_list_response_model.dart';
import 'package:edex_365_getx/features/shared_panel/model/subject_response_model.dart';
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
}

