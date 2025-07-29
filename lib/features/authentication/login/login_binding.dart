import 'package:edex_365_getx/core/config/app.dart';
import 'package:edex_365_getx/features/authentication/login/login_service.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'controller/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Dio>(() => Dio(BaseOptions(baseUrl: EdexAppConfig.apiBase)));
    Get.lazyPut<LoginService>(() => LoginService(Get.find<Dio>()));
    Get.lazyPut<LoginController>(() => LoginController(loginService: Get.find<LoginService>()));
  }
}
