
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/core/network/dio_client.dart';

class TeacherDeleteSkillService {
  final Dio client = DioClient.getInstance();

  Future<String> deleteSkill(String userId, List<String> subIds) async {
    try {
      if (userId.isEmpty || subIds.isEmpty) {
        throw InputException('userId or subIds cannot be empty');
      }

      // Log input params
      log('🔹 Sending POST /api/SubjectUpdate/s/DeleteSkill?userId=$userId');
      log('🔹 Deleting subjects: $subIds');

      final response = await client.post(
        '/api/SubjectUpdate/s/DeleteSkill?userId=$userId',
        data: jsonEncode(subIds),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      // Log response info
      log('✅ Response status: ${response.statusCode}');
      log('✅ Response data: ${response.data}');

      final responseData = response.data as String;

      if (responseData == "skill are deleted...") {
        return responseData;
      } else {
        log('⚠️ Unexpected response: $responseData');
        throw InputException("Unexpected response: $responseData");
      }
    } catch (error, stackTrace) {
      log('❌ Exception in deleteSkill: $error', stackTrace: stackTrace);
      throw InputException("Failed to delete skill: ${error.toString()}");
    }
  }
}
