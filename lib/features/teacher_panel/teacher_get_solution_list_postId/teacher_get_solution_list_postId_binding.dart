import 'package:edex_365_getx/features/teacher_panel/teacher_get_solution_list_postId/controller/teacher_get_solution_list_postId_controller.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_problem_get/teacher_problem_get_service.dart';
import 'package:get/get.dart';

class TeacherAllSolutionsByPostIdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeacherProblemGetService(Get.find()));
    Get.lazyPut(() => TeacherGetSolutionListPostidController(Get.find()));
  }
}
