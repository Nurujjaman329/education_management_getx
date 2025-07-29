import 'package:edex_365_getx/features/payment/bkash_create_payment/bkash_create_payment_service.dart';
import 'package:edex_365_getx/features/payment/bkash_create_payment/controller/bkash_create_payment_controller.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';


class BkashCreatePaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Dio()); // or your configured Dio instance
    Get.lazyPut<BkashCreatePaymentService>(() => BkashCreatePaymentService(Get.find<Dio>()));
    Get.lazyPut<BkashCreatePaymentController>(() => BkashCreatePaymentController(Get.find<BkashCreatePaymentService>()));
  }
}
