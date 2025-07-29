import 'package:edex_365_getx/features/shared_panel/communication_message/communication_message_service.dart';
import 'package:edex_365_getx/features/shared_panel/communication_message/controller/communication_message_controller.dart';
import 'package:get/get.dart';


class CommunicationMessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CommunicationMessageService(Get.find()));
    Get.lazyPut(() => CommunicationMessageController(Get.find()));
  }
}
