import 'package:edex_365_getx/features/authentication/controller/auth_controller.dart';
import 'package:edex_365_getx/features/shared_panel/controller/shared_controller.dart';
import 'package:get/get.dart';
import '../controller/teacher_problem_controller.dart';
import '../service/teacher_problem_service.dart';

class TeacherProblemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeacherProblemService());
    Get.lazyPut(() => TeacherProblemController(Get.find()));
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => SharedController());

  }
}
