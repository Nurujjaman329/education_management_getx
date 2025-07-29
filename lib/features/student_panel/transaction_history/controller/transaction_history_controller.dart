import 'package:edex_365_getx/features/student_panel/transaction_history/model/transaction_history_response_model.dart';
import 'package:edex_365_getx/features/student_panel/transaction_history/transaction_history_service.dart';
import 'package:get/get.dart';


class TransactionHistoryController extends GetxController {
  final TransactionHistoryService service;

  TransactionHistoryController(this.service);

  var rechargeHistory = <TransactionHistoryResponseModel>[].obs;
  var spentHistory = <TransactionHistoryResponseModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> fetchBothHistories(String userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final results = await Future.wait([
        service.getRechargeHistory(userId),
        service.getSpentHistory(userId),
      ]);

      rechargeHistory.assignAll(results[0]);
      spentHistory.assignAll(results[1]);
    } catch (e) {
      errorMessage.value = 'Failed to load histories: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
}
