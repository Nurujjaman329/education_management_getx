import 'package:edex_365_getx/features/teacher_panel/teacher_solution/controller/teacher_solution_controller.dart';
import 'package:get/get.dart';
import 'teacher_solution_service.dart';

class TeacherSolutionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeacherSolutionService(Get.find()));
    Get.lazyPut(() => TeacherSolutionPostController(Get.find()));
  }
}
