import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_get_skill/model/teacher_get_skill_response_model.dart';

import 'dart:convert';


class TeacherGetSkillService {
  final Dio client;
  TeacherGetSkillService(this.client);

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

  /// 🔴 Move the delete logic into the same service class
  Future<String> deleteSkill(String userId, List<String> subIds) async {
    try {
      if (userId.isEmpty || subIds.isEmpty) {
        throw InputException('userId or subIds cannot be empty');
      }

      final response = await client.post(
        '/api/SubjectUpdate/s/DeleteSkill?userId=$userId',
        data: jsonEncode(subIds),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      final responseData = response.data as String;

      if (responseData == "skill are deleted...") {
        return responseData;
      } else {
        throw InputException("Unexpected response: $responseData");
      }
    } catch (error) {
      throw InputException("Failed to delete skill: ${error.toString()}");
    }
  }
}

