import 'package:edex_365_getx/features/shared_panel/claim_message/claim_message_service.dart';
import 'package:edex_365_getx/features/shared_panel/claim_message/controller/claim_message_controller.dart';
import 'package:get/get.dart';

class ClaimMessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ClaimMessageService(Get.find()));
    Get.lazyPut(() => ClaimMessageController(Get.find()));
  }
}
