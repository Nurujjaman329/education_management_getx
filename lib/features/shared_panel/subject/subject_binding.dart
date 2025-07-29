import 'package:edex_365_getx/features/shared_panel/subject/controller/subject_controller.dart';
import 'package:get/get.dart';

class SubjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubjectController>(() => SubjectController());
  }
}
