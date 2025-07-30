import 'package:edex_365_getx/features/teacher_panel/teacher_update_skill/controller/teacher_update_skill_controller.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_update_skill/teacher_update_skill_service.dart';
import 'package:get/get.dart';

class TeacherSkillUpdateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeacherUpdateSkillService(Get.find())); 
    Get.lazyPut(() => TeacherUpdateSkillController(Get.find()));
  }
}
