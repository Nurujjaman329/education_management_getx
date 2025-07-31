// import 'package:dio/dio.dart';
// import 'package:edex_365_getx/core/config/app.dart';
// import 'package:edex_365_getx/features/authentication/auth_controller.dart';
// import 'package:edex_365_getx/features/authentication/login/controller/login_controller.dart';
// import 'package:edex_365_getx/features/authentication/login/login_service.dart';
// import 'package:get/get.dart';

// class InitialBinding extends Bindings {
//   @override
//   void dependencies() {
//     // Global Dio registration
//     if (!Get.isRegistered<Dio>()) {
//       Get.put(Dio(BaseOptions(baseUrl: EdexAppConfig.apiBase)));
//     }

//     // Global AuthController
//     Get.lazyPut<AuthController>(() => AuthController());
//     Get.lazyPut<LoginService>(() => LoginService(Get.find()));
//     Get.lazyPut<LoginController>(() => LoginController(loginService: Get.find()));

//   }
// }

