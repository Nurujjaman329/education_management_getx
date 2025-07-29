import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/student_panel/problem_post/model/problem_post_body.dart';
import 'package:edex_365_getx/features/student_panel/problem_post/model/problem_post_response_model.dart';
import 'package:edex_365_getx/features/student_panel/problem_post/problem_post_service.dart';
import 'package:get/get.dart';

class ProblemPostController extends GetxController {
  final ProblemPostService _service;

  ProblemPostController(this._service);

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  Rx<ProblemPostResponseModel?> responseModel = Rx<ProblemPostResponseModel?>(null);

  Future<void> postProblem(ProblemPostBody problemPostBody) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await _service.problemPost(problemPostBody);
      responseModel.value = response;
    } catch (e) {
      if (e is InputException) {
        errorMessage.value = e.message;
      } else {
        errorMessage.value = 'Something went wrong';
      }
    } finally {
      isLoading.value = false;
    }
  }
}
