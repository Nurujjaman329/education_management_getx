import 'package:edex_365_getx/features/authentication/update_password/update_password_service.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  final UpdatePasswordService service;
  UpdatePasswordController({required this.service});

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;

  Future<void> updatePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    successMessage.value = '';

    try {
      final result = await service.updatePassword(userId, oldPassword, newPassword);
      successMessage.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
