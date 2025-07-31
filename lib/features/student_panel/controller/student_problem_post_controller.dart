import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/shared_panel/controller/shared_controller.dart';
import 'package:edex_365_getx/features/student_panel/model/parameter_body/problem_post_body.dart';
import 'package:edex_365_getx/features/student_panel/model/problem_post_response_model.dart';
import 'package:get/get.dart';
import '../service/student_problem_post_service.dart';

class StudentProblemPostController extends GetxController {
  final StudentProblemPostService _service = StudentProblemPostService();
  final SharedController sharedController = Get.find<SharedController>();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  Rx<ProblemPostResponseModel?> responseModel = Rx<ProblemPostResponseModel?>(null);

  Future<void> postProblem(ProblemPostBody problemPostBody) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await _service.postProblem(problemPostBody);
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
