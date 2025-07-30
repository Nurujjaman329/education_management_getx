import 'package:edex_365_getx/features/teacher_panel/teacher_get_skill/model/teacher_get_skill_response_model.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_get_skill/teacher_get_skill_service.dart';
import 'package:get/get.dart';


class TeacherGetSkillController extends GetxController {
  final TeacherGetSkillService service;

  TeacherGetSkillController(this.service);

  var isLoading = false.obs;
  var skills = <TeacherGetSkillResponseModel>[].obs;
  var errorMessage = ''.obs;

  Future<void> fetchSkills(String userId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await service.getAllSkills(userId);
      skills.value = result;
    } catch (e) {
      errorMessage.value = 'Failed to load skills';
    } finally {
      isLoading.value = false;
    }
  }
}
