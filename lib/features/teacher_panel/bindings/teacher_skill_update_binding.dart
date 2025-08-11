import 'package:edex_365_getx/features/teacher_panel/controller/teacher_update_skill_controller.dart';
import 'package:edex_365_getx/features/teacher_panel/service/teacher_update_skill_service.dart';
import 'package:get/get.dart';

class TeacherSkillUpdateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeacherUpdateSkillService()); 
    Get.lazyPut(() => TeacherUpdateSkillController(Get.find()));
  }
}