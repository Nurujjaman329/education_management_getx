import 'package:edex_365_getx/features/shared_panel/all_english_version_class/controller/all_english_version_class_controller.dart';
import 'package:get/get.dart';

class AllEnglishVersionClassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllEnglishVersionClassController>(() => AllEnglishVersionClassController());
  }
}