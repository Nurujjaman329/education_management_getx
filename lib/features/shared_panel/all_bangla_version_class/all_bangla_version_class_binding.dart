import 'package:edex_365_getx/features/shared_panel/all_bangla_version_class/controller/all_bangla_version_class_controller.dart';
import 'package:get/get.dart';

class AllBanglaVersionClassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllBanglaVersionClassController>(() => AllBanglaVersionClassController());
  }
}