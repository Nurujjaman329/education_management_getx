import 'package:edex_365_getx/features/teacher_panel/teacher_post_accept_problem/controller/teacher_post_accept_problem_controller.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_problem_get/teacher_problem_get_service.dart';
import 'package:get/get.dart';


class TeacherPostAcceptProblemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeacherProblemGetService(Get.find()));
    Get.lazyPut(() => TeacherPostAcceptProblemController(Get.find()));
  }
}
