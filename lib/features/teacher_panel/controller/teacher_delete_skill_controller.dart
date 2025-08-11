import 'package:edex_365_getx/features/teacher_panel/service/teacher_delete_skill_service.dart';
import 'package:get/get.dart';

class TeacherDeleteSkillController extends GetxController {
  final TeacherDeleteSkillService service;
  TeacherDeleteSkillController(this.service);

  var isDeleting = false.obs;
  var deleteMessage = ''.obs;
  var deleteError = ''.obs;

  Future<void> deleteSkill(String userId, List<String> subIds) async {
    isDeleting.value = true;
    deleteMessage.value = '';
    deleteError.value = '';

    try {
      final message = await service.deleteSkill(userId, subIds);
      deleteMessage.value = message;
    } catch (e) {
      deleteError.value = e.toString();
    } finally {
      isDeleting.value = false;
    }
  }
}