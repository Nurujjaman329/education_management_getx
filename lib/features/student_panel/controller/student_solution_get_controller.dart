import 'package:edex_365_getx/features/student_panel/model/students_solution_get_response_body_model.dart';
import 'package:edex_365_getx/features/student_panel/service/student_solution_get_service.dart';
import 'package:get/get.dart';

class StudentSolutionGetController extends GetxController {
  final StudentSolutionGetService _service = StudentSolutionGetService();

  var isLoading = false.obs;
  var solutions = <StudentsSolutionGetResponseBodyModel>[].obs;
  var errorMessage = ''.obs;

  Future<void> fetchSolutions(String postId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await _service.getSolutions(postId);
      solutions.assignAll(result);
    } catch (e) {
      errorMessage.value = 'Failed to fetch solutions';
    } finally {
      isLoading.value = false;
    }
  }
}
