import 'package:edex_365_getx/features/authentication/update_user_info/controller/update_user_info_controller.dart';
import 'package:edex_365_getx/features/authentication/update_user_info/update_user_info_service.dart';
import 'package:get/get.dart';


class UpdateUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UpdateUserInfoService(Get.find()));
    Get.lazyPut(() => UpdateUserInfoController(Get.find()));
  }
}
