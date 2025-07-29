import 'package:edex_365_getx/features/authentication/forgot_password/forgot_password_service.dart';
import 'package:get/get.dart';


class ForgotPasswordController extends GetxController {
  final ForgotPasswordService _forgotPasswordService;

  ForgotPasswordController(this._forgotPasswordService);

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;

  Future<void> sendOtp(String mobileNo) async {
    _setLoading(true);
    try {
      final message = await _forgotPasswordService.forgotPasswordSendOtp(mobileNo);
      successMessage.value = message;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> verifyOtp(String mobileNo, String otp) async {
    _setLoading(true);
    try {
      final message = await _forgotPasswordService.forgotPasswordVerifyOtp(mobileNo, otp);
      successMessage.value = message;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> confirmPassword(String mobileNo, String password) async {
    _setLoading(true);
    try {
      final message = await _forgotPasswordService.forgotPasswordConfirm(mobileNo, password);
      successMessage.value = message;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading.value = value;
    if (value) {
      errorMessage.value = '';
      successMessage.value = '';
    }
  }
}
