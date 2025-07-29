import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/shared_panel/roles/model/user_roles_response_model.dart';


class RoleService {
  final Dio client = Dio();

  Future<List<UserRolesResponseModel>> fetchRoles() async {
    try {
      final response = await client.get("https://api.edex365.com/api/Role/s/AllRoles");

      log('Role API response: ${response.data}');
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
      log("Role fetch error: $e");
      rethrow;
    }
  }
}
