import 'package:edex_365_getx/features/authentication/auth_controller.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    // Add other global controllers here too if needed
  }
}
