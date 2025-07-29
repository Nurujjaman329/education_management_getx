import 'package:edex_365_getx/features/teacher_panel/teacher_update_skill/model/teacher_update_skill_body.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_update_skill/model/teacher_update_skill_response_model.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_update_skill/teacher_update_skill_service.dart';
import 'package:get/get.dart';

class TeacherUpdateSkillController extends GetxController {
  final TeacherUpdateSkillService service;

  TeacherUpdateSkillController(this.service);

  var isLoading = false.obs;
  var error = ''.obs;
  var response = Rxn<TeacherUpdateSkillResponseModel>();

  Future<void> updateSkill(TeacherUpdateSkillBody body) async {
    isLoading.value = true;
    error.value = '';
    response.value = null;

    try {
      final result = await service.updateSkill(body);
      response.value = result;
    } catch (e) {
      error.value = 'Failed to update skill.';
    } finally {
      isLoading.value = false;
    }
  }
}
