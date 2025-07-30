import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_get_skill/teacher_get_skill_service.dart';

extension TeacherDeleteSkillService on TeacherGetSkillService {
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
