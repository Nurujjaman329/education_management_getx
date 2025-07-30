import 'package:edex_365_getx/features/teacher_panel/teacher_get_solution_list/controller/teacher_get_solution_list_controller.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_problem_get/teacher_problem_get_service.dart';
import 'package:get/get.dart';

class TeacherAllSolutionListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeacherProblemGetService(Get.find()));
    Get.lazyPut(() => TeacherGetSolutionListController(Get.find()));
  }
}
