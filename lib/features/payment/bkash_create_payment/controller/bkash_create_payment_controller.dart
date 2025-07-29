import 'package:edex_365_getx/features/payment/bkash_create_payment/bkash_create_payment_service.dart';
import 'package:edex_365_getx/features/payment/bkash_create_payment/model/bkash_create_payment_response_model.dart';
import 'package:get/get.dart';

class BkashCreatePaymentController extends GetxController {
  final BkashCreatePaymentService _service;

  BkashCreatePaymentController(this._service);

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  Rx<BkashCreatePaymentResponseModel?> paymentResponse = Rx<BkashCreatePaymentResponseModel?>(null);

  Future<void> createPayment(String userId, double amount) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await _service.bkashCreatePayment(userId, amount);
      paymentResponse.value = response;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
