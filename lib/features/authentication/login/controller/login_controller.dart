import 'package:edex_365_getx/features/authentication/login/login_service.dart';
import 'package:edex_365_getx/features/authentication/login/model/login_response.dart';
import 'package:edex_365_getx/routes/app_pages.dart';
import 'package:get/get.dart';

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

      // ✅ Role-based navigation
      if (response.type.toLowerCase() == 'teacher') {
        Get.offAllNamed(Routes.teacherHome); // Define this route in your route file
      } else if (response.type.toLowerCase() == 'student') {
        Get.offAllNamed(Routes.studentHome); // Define this route in your route file
      } else {
        errorMessage.value = 'Unknown user role: ${response.type}';
      }
    } catch (e) {
      errorMessage.value = 'Login failed: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
}
