import 'package:dio/dio.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_transaction_history/controller/teacher_transaction_history_controller.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_transaction_history/teacher_transaction_history_service.dart';
import 'package:get/get.dart';


class TeacherTransactionHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeacherTransactionHistoryService(Get.find<Dio>()));
    Get.lazyPut(() => TeacherTransactionHistoryController(Get.find()));
  }
}
