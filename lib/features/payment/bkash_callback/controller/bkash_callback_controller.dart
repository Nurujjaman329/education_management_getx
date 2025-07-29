import 'package:edex_365_getx/features/payment/bkash_callback/bkash_callback_service.dart';
import 'package:edex_365_getx/features/payment/bkash_callback/model/bkash_callback_response_model.dart';
import 'package:get/get.dart';

class BkashCallbackController extends GetxController {
  final BkashCallbackService _service;

  BkashCallbackController(this._service);

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  Rx<BkashCallbackResponseModel?> callbackResponse = Rx<BkashCallbackResponseModel?>(null);

  Future<void> performCallback(String userId, String paymentID) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await _service.bkashCallBack(userId, paymentID);
      callbackResponse.value = response;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
