import 'package:edex_365_getx/features/authentication/forgot_password/controller/forgot_password_controller.dart';
import 'package:edex_365_getx/features/authentication/forgot_password/forgot_password_service.dart';
import 'package:get/get.dart';


class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgotPasswordService(Get.find()));
    Get.lazyPut(() => ForgotPasswordController(Get.find()));
  }
}
