import 'package:edex_365_getx/features/student_panel/student_problem_list/model/student_problem_list_response_model.dart';
import 'package:edex_365_getx/features/student_panel/student_problem_list/view/student_problem_list_service.dart';
import 'package:get/get.dart';


class StudentProblemListController extends GetxController {
  final StudentProblemService _service;

  StudentProblemListController(this._service);

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var totalProblems = <StudentProblemListResponseModel>[].obs;
  var pendingProblems = <StudentProblemListResponseModel>[].obs;
  var solvedProblems = <StudentProblemListResponseModel>[].obs;

  Future<void> fetchAllProblems(String userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final results = await Future.wait([
        _service.getStudentProblems(userId),
        _service.getPendingProblems(userId),
        _service.getSolvedProblems(userId),
      ]);

      totalProblems.assignAll(results[0]);
      pendingProblems.assignAll(results[1]);
      solvedProblems.assignAll(results[2]);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
