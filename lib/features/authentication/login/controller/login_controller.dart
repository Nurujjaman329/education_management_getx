import 'package:edex_365_getx/features/authentication/login/login_service.dart';
import 'package:get/get.dart';
import '../model/login_response.dart';

class LoginController extends GetxController {
  final LoginService loginService;

  LoginController({required this.loginService});

  var isLoading = false.obs;
  var loginResponse = Rxn<LoginResponse>();
  var errorMessage = ''.obs;

  Future<void> login(String mobileNo, String password, String deviceToken) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final response = await loginService.login(
        mobileNo: mobileNo,
        password: password,
        deviceToken: deviceToken,
      );
      
      loginResponse.value = response;
      // TODO: Navigate to next screen based on login success
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
