import 'package:edex_365_getx/features/student_panel/student_wallet/controller/student_wallet_controller.dart';
import 'package:edex_365_getx/features/student_panel/student_wallet/student_wallet_service.dart';
import 'package:get/get.dart';


class GetStudentWalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StudentWalletService(Get.find()));
    Get.lazyPut(() => StudentWalletController(Get.find()));
  }
}
