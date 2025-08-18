import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/core/network/dio_client.dart';
import 'package:edex_365_getx/features/teacher_panel/model/teacher_skill/teacher_update_skill_body.dart';
import 'package:edex_365_getx/features/teacher_panel/model/teacher_skill/teacher_update_skill_response_model.dart';

import 'dart:developer';

class TeacherUpdateSkillService {
  final Dio client = DioClient.getInstance();

Future<TeacherUpdateSkillResponseModel?> updateSkill(
    TeacherUpdateSkillBody body) async {
  try {
    final formData = body.toFormData();

    // Log FormData fields clearly:
    final formDataMap = <String, dynamic>{};
    for (var element in formData.fields) {
      formDataMap[element.key] = element.value;
    }
    log('🔹 Sending PUT /api/SubjectUpdate/s/TeacherSkill with data: $formDataMap');

    final response = await client.put(
      '/api/SubjectUpdate/s/TeacherSkill',
      data: formData,
    );

    log('✅ Response status: ${response.statusCode}');
    log('✅ Response data: ${response.data}');

    if (response.statusCode == 200) {
      if (response.data == null) {
        return null;
      }
      return TeacherUpdateSkillResponseModel.fromJson(
          response.data as Map<String, dynamic>);
    } else if (response.statusCode == 400) {
      log('⚠️ Input Error 400');
      throw InputException("Input Error");
    } else if (response.statusCode == 404) {
      log('⚠️ Auth Error 404');
      throw AuthException();
    } else {
      log('⚠️ Server Error: ${response.statusCode}');
      throw ServerException();
    }
  } catch (error, stackTrace) {
    log('❌ Exception in updateSkill: $error', stackTrace: stackTrace);
    throw ServerException();
  }
}



}
