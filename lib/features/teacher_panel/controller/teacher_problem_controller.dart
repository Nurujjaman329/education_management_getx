import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:get/get.dart';
import '../model/teacher_problem_get_model.dart';
import '../service/teacher_problem_service.dart';

class TeacherProblemController extends GetxController {
  final TeacherProblemService service;
  TeacherProblemController(this.service);

  var problems = <TeacherProblemGetModel>[].obs;
  var totalProblems = <TeacherProblemGetModel>[].obs;
  var acceptedProblems = <TeacherProblemGetModel>[].obs;
  var solvedProblems = <TeacherProblemGetModel>[].obs;

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var isBlocked = false.obs;
  var blockMessage = ''.obs;
  var unblockTime = ''.obs;
//** */


  Future<void> fetchTeacherProblems(String userId) async {
    try {
      isLoading(true);
      errorMessage.value = ''; // Clear previous error
      totalProblems.value = await service.getTeacherProblem(userId);
    } on InputException catch (e) {
      // This will properly display the exception message
      errorMessage.value = e.toString().replaceFirst('InputException: ', '');
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading(false);
    }
  }

  Future<void> acceptProblem(String userId, String postId) async {
    try {
      isLoading(true);
      problems.value = await service.postAcceptProblemTeacher(userId, postId);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading(false);
    }
  }

//** */
  Future<void> fetchAcceptedProblems(String userId) async {
    try {
      isLoading(true);
      acceptedProblems.value = await service.getAcceptProblemList(userId);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading(false);
    }
  }

// ***
  Future<void> fetchAllSolutionList(String userId) async {
    try {
      isLoading(true);
      solvedProblems.value = await service.getAllSolutionList(userId);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchSolutionsByPost(String postId) async {
    try {
      isLoading(true);
      problems.value = await service.getAllSolution(postId);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading(false);
    }
  }
}
