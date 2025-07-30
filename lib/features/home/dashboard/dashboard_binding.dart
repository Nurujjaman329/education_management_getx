import 'package:edex_365_getx/features/authentication/user_details/user_details_service.dart';
import 'package:edex_365_getx/features/home/dashboard/controller/student_home_controller.dart';
import 'package:edex_365_getx/features/shared_panel/academy_version_list/controller/academy_version_list_controller.dart';
import 'package:edex_365_getx/features/shared_panel/all_bangla_version_class/controller/all_bangla_version_class_controller.dart';
import 'package:edex_365_getx/features/shared_panel/all_english_version_class/controller/all_english_version_class_controller.dart';
import 'package:edex_365_getx/features/shared_panel/subject/controller/subject_controller.dart';
import 'package:edex_365_getx/features/student_panel/student_problem_list/view/student_problem_list_service.dart';
import 'package:get/get.dart';

class StudentHomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubjectController>(() => SubjectController());
    Get.lazyPut(() => StudentProblemService(Get.find()));
    Get.lazyPut(() => UserDetailsService(Get.find()));
    Get.lazyPut(() => StudentHomeController(Get.find(), Get.find()));
    Get.lazyPut<AcademyVersionListController>(() => AcademyVersionListController());
    Get.lazyPut<AllBanglaVersionClassController>(() => AllBanglaVersionClassController());
    Get.lazyPut<AllEnglishVersionClassController>(() => AllEnglishVersionClassController());
  }
}