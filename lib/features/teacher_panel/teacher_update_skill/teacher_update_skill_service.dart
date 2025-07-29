import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_update_skill/model/teacher_update_skill_body.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_update_skill/model/teacher_update_skill_response_model.dart';

class TeacherUpdateSkillService {
  final Dio client;
  TeacherUpdateSkillService(this.client);

  Future<TeacherUpdateSkillResponseModel> updateSkill(
      TeacherUpdateSkillBody body) async {
    try {
      final formData = body.toFormData();
      final response = await client.put(
        '/api/SubjectUpdate/s/TeacherSkill',
        data: formData,
      );

      switch (response.statusCode) {
        case 200:
          return TeacherUpdateSkillResponseModel.fromJson(response.data);
        case 400:
          throw InputException("Input Error");
        case 404:
          throw AuthException();
        default:
          throw ServerException();
      }
    } catch (error) {
      throw ServerException();
    }
  }
}
