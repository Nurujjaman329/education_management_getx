import 'package:edex_365_getx/features/teacher_panel/teacher_wallet/controller/teacher_wallet_controller.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_wallet/teacher_wallet_service.dart';
import 'package:get/get.dart';


class TeacherWalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeacherWalletService(Get.find()));
    Get.lazyPut(() => TeacherWalletController(Get.find()));
  }
}
