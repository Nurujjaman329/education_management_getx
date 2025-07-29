import 'package:edex_365_getx/features/student_panel/transaction_history/controller/transaction_history_controller.dart';
import 'package:edex_365_getx/features/student_panel/transaction_history/transaction_history_service.dart';
import 'package:get/get.dart';


class StudentTransactionHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TransactionHistoryService(Get.find()));
    Get.lazyPut(() => TransactionHistoryController(Get.find()));
  }
}
