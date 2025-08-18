import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/teacher_panel/model/teacher_transaction_history_model.dart';
import 'package:edex_365_getx/features/teacher_panel/service/teacher_transaction_history_service.dart';
import 'package:get/get.dart';

class TeacherTransactionHistoryController extends GetxController {
  final TeacherTransactionHistoryService service;

  TeacherTransactionHistoryController(this.service);

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var transactionList = <TeacherTransactionHistoryResponseModel>[].obs;

  Future<void> fetchTransactionHistory(String userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await service.getTransactionHistory(userId);
      transactionList.assignAll(result);
    } catch (e) {
      if (e is ServerException) {
        errorMessage.value = 'Server error occurred. Please try again later.';
      } else if (e is AuthException) {
        errorMessage.value = 'Authentication failed. Please login again.';
      } else if (e is InputException) {
        errorMessage.value = e.toString();
      } else {
        errorMessage.value = 'Unexpected error occurred';
      }
    } finally {
      isLoading.value = false;
    }
  }
}