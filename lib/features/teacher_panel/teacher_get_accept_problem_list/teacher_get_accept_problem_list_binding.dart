import 'package:edex_365_getx/features/teacher_panel/teacher_get_accept_problem_list/controller/teacher_get_accept_problem_list_controller.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_problem_get/teacher_problem_get_service.dart';
import 'package:get/get.dart';

class TeacherGetAcceptProblemListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeacherProblemGetService(Get.find()));
    Get.lazyPut(() => TeacherGetAcceptProblemListController(Get.find()));
  }
}
