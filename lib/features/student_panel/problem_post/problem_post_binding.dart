import 'package:edex_365_getx/features/student_panel/problem_post/controller/problem_post_controller.dart';
import 'package:edex_365_getx/features/student_panel/problem_post/problem_post_service.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class ProblemPostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Dio()); // or your configured Dio instance
    Get.lazyPut<ProblemPostService>(() => ProblemPostService(Get.find<Dio>()));
    Get.lazyPut<ProblemPostController>(() => ProblemPostController(Get.find<ProblemPostService>()));
  }
}
