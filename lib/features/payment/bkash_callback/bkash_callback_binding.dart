import 'package:edex_365_getx/features/payment/bkash_callback/bkash_callback_service.dart';
import 'package:edex_365_getx/features/payment/bkash_callback/controller/bkash_callback_controller.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class BkashCallbackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Dio()); // or your configured Dio instance
    Get.lazyPut<BkashCallbackService>(() => BkashCallbackService(Get.find<Dio>()));
    Get.lazyPut<BkashCallbackController>(() => BkashCallbackController(Get.find<BkashCallbackService>()));
  }
}
