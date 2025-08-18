// lib/features/student_panel/bindings/student_problem_list_binding.dart
import 'package:edex_365_getx/features/student_panel/controller/student_problem_list_controller.dart';
import 'package:edex_365_getx/features/student_panel/service/student_problem_list_service.dart';
import 'package:get/get.dart';

class StudentProblemListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentProblemListService>(() => StudentProblemListService());
    Get.lazyPut<StudentProblemListController>(() => StudentProblemListController(Get.find<StudentProblemListService>()));
  }
}
