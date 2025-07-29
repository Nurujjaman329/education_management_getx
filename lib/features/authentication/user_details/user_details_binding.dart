import 'package:edex_365_getx/features/authentication/user_details/controller/user_details_controller.dart';
import 'package:edex_365_getx/features/authentication/user_details/user_details_service.dart';
import 'package:get/get.dart';


class GetUserDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserDetailsService(Get.find()));
    Get.lazyPut(() => UserDetailsController(Get.find()));
  }
}
