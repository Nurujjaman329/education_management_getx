import 'package:edex_365_getx/features/student_panel/student_wallet/student_wallet_service.dart';
import 'package:get/get.dart';


class StudentWalletController extends GetxController {
  final StudentWalletService service;

  StudentWalletController(this.service);

  var balance = ''.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> fetchStudentWallet(String userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await service.getStudentWallet(userId);
      balance.value = result;
    } catch (e) {
      errorMessage.value = 'Failed to load wallet balance.';
    } finally {
      isLoading.value = false;
    }
  }
}
