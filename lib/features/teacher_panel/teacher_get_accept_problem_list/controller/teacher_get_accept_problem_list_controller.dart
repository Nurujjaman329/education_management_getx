import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_problem_get/model/teacher_problem_get_model.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_problem_get/teacher_problem_get_service.dart';
import 'package:get/get.dart';


class TeacherGetAcceptProblemListController extends GetxController {
  final TeacherProblemGetService service;

  TeacherGetAcceptProblemListController(this.service);

  var isLoading = false.obs;
  var problemList = <TeacherProblemGetModel>[].obs;
  var error = ''.obs;

  Future<void> fetchAcceptedProblems(String userId) async {
    isLoading.value = true;
    error.value = '';
    problemList.clear();

    try {
      final result = await service.getAcceptProblemList(userId);
      problemList.assignAll(result);
    } catch (e) {
      if (e is AuthException) {
        error.value = 'Authentication failed';
      } else if (e is ServerException) {
        error.value = 'Server error occurred';
      } else {
        error.value = e.toString();
      }
    } finally {
      isLoading.value = false;
    }
  }
}
