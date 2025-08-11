import 'package:edex_365_getx/features/authentication/controller/auth_controller.dart';
import 'package:edex_365_getx/features/shared_panel/controller/shared_controller.dart';
import 'package:edex_365_getx/features/teacher_panel/controller/teacher_delete_skill_controller.dart';
import 'package:edex_365_getx/features/teacher_panel/controller/teacher_get_skill_controller.dart';
import 'package:edex_365_getx/features/teacher_panel/controller/teacher_update_skill_controller.dart';
import 'package:edex_365_getx/features/teacher_panel/service/teacher_delete_skill_service.dart';
import 'package:edex_365_getx/features/teacher_panel/service/teacher_get_skill_service.dart';
import 'package:edex_365_getx/features/teacher_panel/service/teacher_update_skill_service.dart';
import 'package:get/get.dart';

class TeacherSkillManagementBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    
    Get.lazyPut(() => TeacherGetSkillService());
    Get.lazyPut(() => TeacherDeleteSkillService());
    Get.lazyPut(() => TeacherUpdateSkillService());

    // Controllers
    Get.lazyPut(() => SharedController());
    Get.lazyPut(() => TeacherGetSkillController(Get.find()));
    Get.lazyPut(() => TeacherDeleteSkillController(Get.find()));
    Get.lazyPut(() => TeacherUpdateSkillController(Get.find()));
    Get.lazyPut(() => AuthController());
  }
}
