import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/student_panel/student_sloution_list/model/student_sloution_list_response_model.dart';
import 'package:edex_365_getx/features/student_panel/student_sloution_list/student_sloution_list_service.dart';
import 'package:get/get.dart';

class StudentSloutionListController extends GetxController {
  final StudentSloutionListService _service;

  StudentSloutionListController(this._service);

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var studentSolutions = <StudentSloutionListResponseModel>[].obs;

  Future<void> fetchSolutions(String postId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      studentSolutions.clear();

      final result = await _service.solutionGet(postId);
      studentSolutions.assignAll(result);
    } on InputException catch (e) {
      errorMessage.value = e.message;
    } on AuthException {
      errorMessage.value = 'Authentication failed.';
    } catch (e) {
      errorMessage.value = 'Something went wrong';
    } finally {
      isLoading.value = false;
    }
  }
}
