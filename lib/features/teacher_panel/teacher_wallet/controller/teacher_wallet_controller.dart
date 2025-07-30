import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_wallet/teacher_wallet_service.dart';
import 'package:get/get.dart';


class TeacherWalletController extends GetxController {
  final TeacherWalletService service;

  TeacherWalletController(this.service);

  var isLoading = false.obs;
  var walletBalance = ''.obs;
  var error = ''.obs;

  Future<void> fetchWalletBalance(String userId) async {
    isLoading.value = true;
    error.value = '';
    walletBalance.value = '';

    try {
      final result = await service.getTeacherWallet(userId);
      walletBalance.value = result;
    } catch (e) {
      if (e is AuthException) {
        error.value = 'Authentication failed.';
      } else if (e is ServerException) {
        error.value = 'Server error occurred.';
      } else {
        error.value = 'Unknown error: ${e.toString()}';
      }
    } finally {
      isLoading.value = false;
    }
  }
}
