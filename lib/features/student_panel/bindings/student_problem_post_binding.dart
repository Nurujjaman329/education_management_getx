import 'package:edex_365_getx/features/authentication/controller/auth_controller.dart';
import 'package:edex_365_getx/features/shared_panel/controller/shared_controller.dart';
import 'package:get/get.dart';
import '../controller/student_problem_post_controller.dart';

class StudentProblemPostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StudentProblemPostController());
    Get.lazyPut(() => SharedController());
    Get.lazyPut(() => AuthController());
  }
}
