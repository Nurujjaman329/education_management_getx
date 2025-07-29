import 'package:edex_365_getx/features/shared_panel/roles/controller/user_roles_controller.dart';
import 'package:get/get.dart';

class RolesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRolesController>(() => UserRolesController());
  }
}
