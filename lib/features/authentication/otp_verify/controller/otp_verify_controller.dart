import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/authentication/otp_verify/otp_verify_service.dart';
import 'package:get/get.dart';


class OtpVerifyController extends GetxController {
  final OtpVerifyService service;

  OtpVerifyController(this.service);

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isSuccess = false.obs;

  Future<void> verifyOtp(String id, String otp) async {
    isLoading.value = true;
    errorMessage.value = '';
    isSuccess.value = false;

    try {
      final result = await service.verifyOtp(id, otp);
      if (result.message == "Verifyed Otp..") {
        isSuccess.value = true;
      } else {
        errorMessage.value = result.message;
      }
    } on InputException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = "Unexpected error: ${e.toString()}";
    } finally {
      isLoading.value = false;
    }
  }
}
