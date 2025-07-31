import 'package:edex_365_getx/features/authentication/model/login_response.dart';
import 'package:edex_365_getx/features/authentication/model/parameter_body/signup_request_body.dart';
import 'package:edex_365_getx/features/authentication/service/auth_service.dart';
import 'package:edex_365_getx/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthController extends GetxController {
  final AuthService _service = AuthService();

  var isLoading = false.obs;
  var loginResponse = Rxn<LoginResponse>();

  Future<void> login(String mobileNo, String password) async {
    try {
      isLoading.value = true;

      // Use a static or test token for now
      const deviceToken = 'static_device_token_123';
      

      final response = await _service.login(
        mobileNo: mobileNo,
        password: password,
        deviceToken: deviceToken,
      );

      loginResponse.value = response;

      // Save token & type
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response.token);
      await prefs.setString('userType', response.type);

      print('Login successful: ${response.token}, ${response.type}');

      final userType = response.type.toLowerCase();

      if (userType == 'student') {
        Get.offAllNamed(AppRoutes.studentHome);
      } else if (userType == 'teacher') {
        Get.offAllNamed(AppRoutes.teacherHome);
      } else {
        Get.snackbar("Error", "Invalid user type");
      }
    } catch (e) {
      print('Login error: $e');
      Get.snackbar("Login Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(SignUpRequestBody body) async {
    try {
      isLoading.value = true;
      await _service.register(body);
      Get.back(); // Go back to login or previous page
    } catch (e) {
      Get.snackbar('Registration Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    loginResponse.value = null;
    Get.offAllNamed(AppRoutes.login);
  }

  Future<bool> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }
}

