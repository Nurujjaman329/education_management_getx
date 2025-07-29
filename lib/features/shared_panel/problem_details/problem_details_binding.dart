import 'package:edex_365_getx/features/shared_panel/problem_details/controller/problem_details_controller.dart';
import 'package:edex_365_getx/features/shared_panel/problem_details/problem_details_service.dart';
import 'package:get/get.dart';


class ProblemDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProblemDetailsService(Get.find()));
    Get.lazyPut(() => ProblemDetailsController(Get.find()));
  }
}
