import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/core/network/dio_client.dart';
import 'package:edex_365_getx/features/teacher_panel/model/teacher_skill/teacher_get_skill_response_model.dart';

class TeacherGetSkillService {
  final Dio client = DioClient.getInstance();

  Future<List<TeacherGetSkillResponseModel>> getAllSkills(String userId) async {
    final String url = "/api/SubjectUpdate/s/AllSkill/$userId";

    try {
      final fullUrl = client.options.baseUrl + url;
      log('Fetching teacher skills for userId: $userId');
      log('Request Full URL: $fullUrl');

      final response = await client.get(url);
      log('Response Status: ${response.statusCode}');
      log('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data is List) {
          return (response.data as List)
              .map((e) => TeacherGetSkillResponseModel.fromJson(e))
              .toList();
        } else if (response.data is String) {
          log("API returned a string instead of a list: ${response.data}");
          return [];
        } else {
          throw ServerException();
        }
      } else if (response.statusCode == 404) {
        throw AuthException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      log('Error fetching skills: $e');
      rethrow;
    }
  }
}