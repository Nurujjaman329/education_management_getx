import 'package:edex_365_getx/features/teacher_panel/teacher_problem_get/model/teacher_problem_get_model.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_problem_get/teacher_problem_get_service.dart';
import 'package:get/get.dart';


class TeacherPostAcceptProblemController extends GetxController {
  final TeacherProblemGetService service;
  TeacherPostAcceptProblemController(this.service);

  var isAccepting = false.obs;
  var acceptedProblems = <TeacherProblemGetModel>[].obs;
  var acceptError = ''.obs;

  Future<void> acceptProblem(String userId, String postId) async {
    isAccepting.value = true;
    acceptError.value = '';
    acceptedProblems.clear();

    try {
      final problems = await service.postAcceptProblemTeacher(userId, postId);
      acceptedProblems.assignAll(problems);
    } catch (e) {
      acceptError.value = e.toString();
    } finally {
      isAccepting.value = false;
    }
  }
}
