import 'package:edex_365_getx/features/teacher_panel/model/teacher_skill/teacher_update_skill_body.dart';
import 'package:edex_365_getx/features/teacher_panel/model/teacher_skill/teacher_update_skill_response_model.dart';
import 'package:edex_365_getx/features/teacher_panel/service/teacher_update_skill_service.dart';
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
    if (result != null) {
      response.value = result;
    } else {
      // Handle the case where API returns no response body
      // For example, set a success message manually
      response.value = TeacherUpdateSkillResponseModel(
        message: "Skill updated successfully",
        updateDetails: TeacherUpdateSkill(subject: body.subject),
      );
    }
  } catch (e) {
    error.value = 'Failed to update skill.';
  } finally {
    isLoading.value = false;
  }
}

}