import 'package:edex_365_getx/features/shared_panel/roles/controller/user_roles_controller.dart';
import 'package:edex_365_getx/features/shared_panel/subject/controller/subject_controller.dart';
import 'package:get/get.dart';
import 'controller/registration_controller.dart';

class RegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SubjectController());
    Get.lazyPut(() => UserRolesController());
    Get.lazyPut(() => RegistrationController());
  }
}

