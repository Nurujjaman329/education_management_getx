import 'package:edex_365_getx/routes/app_pages.dart';
import 'package:get/get.dart';
import 'auth_storage_service.dart';

class AuthController extends GetxController {
  final AuthStorageService _storageService = AuthStorageService();

  var isLoggedIn = false.obs;
  var userType = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final token = await _storageService.getToken();
    final type = await _storageService.getUserType();

    if (token != null && token.isNotEmpty) {
      isLoggedIn.value = true;
      userType.value = type ?? '';

      // ✅ Role-based redirection
      switch (userType.value.toLowerCase()) {
        case 'teacher':
          Get.offAllNamed(Routes.teacherHome);
          break;
        case 'student':
          Get.offAllNamed(Routes.studentHome);
          break;
        default:
          // Unknown role fallback
          Get.offAllNamed(Routes.login);
          break;
      }
    } else {
      // No valid token found
      isLoggedIn.value = false;
      userType.value = '';
      Get.offAllNamed(Routes.login);
    }
  }

  Future<void> logout() async {
    await _storageService.clearAll();
    isLoggedIn.value = false;
    userType.value = '';
    Get.offAllNamed(Routes.login); // ⬅️ Navigate to login screen
  }
}


