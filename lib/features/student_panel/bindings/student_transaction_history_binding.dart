import 'package:edex_365_getx/features/student_panel/controller/transaction_history_controller.dart';
import 'package:edex_365_getx/features/student_panel/service/transaction_history_service.dart';
import 'package:get/get.dart';

class TransactionHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TransactionHistoryService());
    Get.lazyPut(() => TransactionHistoryController(Get.find()));
  }
}
