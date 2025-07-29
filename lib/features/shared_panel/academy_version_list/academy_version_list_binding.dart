import 'package:edex_365_getx/features/shared_panel/academy_version_list/controller/academy_version_list_controller.dart';
import 'package:get/get.dart';

class AcademyVersionListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AcademyVersionListController>(() => AcademyVersionListController());
  }
}
