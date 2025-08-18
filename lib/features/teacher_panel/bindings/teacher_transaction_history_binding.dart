import 'package:edex_365_getx/features/teacher_panel/controller/teacher_transaction_history_controller.dart';
import 'package:edex_365_getx/features/teacher_panel/service/teacher_transaction_history_service.dart';
import 'package:get/get.dart';

class TeacherTransactionHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeacherTransactionHistoryService());
    Get.lazyPut(() => TeacherTransactionHistoryController(Get.find()));
  }
}