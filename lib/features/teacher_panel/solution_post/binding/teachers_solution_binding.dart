import 'package:edex_365_getx/features/teacher_panel/solution_post/controller/teachers_solution_controller.dart';
import 'package:edex_365_getx/features/teacher_panel/solution_post/service/teachers_solution_service.dart';
import 'package:get/get.dart';


class TeacherSolutionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeacherSolutionService());
    Get.lazyPut(() => TeacherSolutionController());
  }
}
