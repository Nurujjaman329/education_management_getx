import 'package:edex_365_getx/features/teacher_panel/teacher_delete_skill/controller/teacher_delete_skill_controller.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_get_skill/teacher_get_skill_service.dart';
import 'package:get/get.dart';


class TeacherSkillBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeacherGetSkillService(Get.find()));
    Get.lazyPut(() => TeacherDeleteSkillController(Get.find()));
  }
}

