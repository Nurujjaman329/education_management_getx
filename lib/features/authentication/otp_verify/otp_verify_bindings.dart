import 'package:edex_365_getx/features/authentication/otp_verify/controller/otp_verify_controller.dart';
import 'package:edex_365_getx/features/authentication/otp_verify/otp_verify_service.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class OtpVerifyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Dio()); // Or provide a singleton if needed
    Get.lazyPut(() => OtpVerifyService(Get.find()));
    Get.lazyPut(() => OtpVerifyController(Get.find()));
  }
}
