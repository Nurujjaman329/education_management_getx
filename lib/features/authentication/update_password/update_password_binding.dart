import 'package:edex_365_getx/features/authentication/update_password/update_password_service.dart';
import 'package:get/get.dart';
import 'package:edex_365_getx/features/authentication/update_password/controller/update_password_controller.dart';

class UpdatePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UpdatePasswordService(Get.find()));
    Get.lazyPut(() => UpdatePasswordController(service: Get.find()));
  }
}
