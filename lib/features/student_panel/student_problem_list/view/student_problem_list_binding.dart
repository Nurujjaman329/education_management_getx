import 'package:edex_365_getx/features/student_panel/student_problem_list/controller/student_problem_list_controller.dart';
import 'package:edex_365_getx/features/student_panel/student_problem_list/view/student_problem_list_service.dart';
import 'package:get/get.dart';


class StudentGetProblemListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StudentProblemService(Get.find()));
    Get.lazyPut(() => StudentProblemListController(Get.find()));
  }
}
