import 'package:edex_365_getx/features/shared_panel/controller/shared_controller.dart';
import 'package:edex_365_getx/features/student_panel/controller/student_solution_get_controller.dart';
import 'package:get/get.dart';

class SolutionAndClaimChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentSolutionGetController>(() => StudentSolutionGetController());
    Get.lazyPut<SharedController>(() => SharedController());
  }
}
