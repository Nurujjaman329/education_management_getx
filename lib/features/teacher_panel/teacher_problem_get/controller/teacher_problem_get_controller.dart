import 'package:edex_365_getx/features/teacher_panel/teacher_problem_get/teacher_problem_get_service.dart';
import 'package:get/get.dart';
import '../model/teacher_problem_get_model.dart';

class TeacherProblemController extends GetxController {
  final TeacherProblemGetService service;
  TeacherProblemController(this.service);

  var isLoading = false.obs;
  var problemList = <TeacherProblemGetModel>[].obs;
  var errorMessage = ''.obs;

  Future<void> fetchProblems(String userId) async {
    isLoading.value = true;
    errorMessage.value = '';
    problemList.clear();

    try {
      final data = await service.getTeacherProblems(userId);
      problemList.assignAll(data);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
