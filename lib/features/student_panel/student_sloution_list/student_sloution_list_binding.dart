import 'package:edex_365_getx/features/student_panel/student_sloution_list/controller/student_sloution_list_controller.dart';
import 'package:edex_365_getx/features/student_panel/student_sloution_list/student_sloution_list_service.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class StudentSloutionListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Dio>(() => Dio()); // Or your existing Dio setup
    Get.lazyPut<StudentSloutionListService>(() => StudentSloutionListService(Get.find()));
    Get.lazyPut<StudentSloutionListController>(() => StudentSloutionListController(Get.find()));
  }
}
