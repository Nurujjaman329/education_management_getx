import 'package:edex_365_getx/features/shared_panel/problem_details/model/problem_details_response_model.dart';
import 'package:edex_365_getx/features/shared_panel/problem_details/problem_details_service.dart';
import 'package:get/get.dart';


class ProblemDetailsController extends GetxController {
  final ProblemDetailsService service;
  ProblemDetailsController(this.service);

  var isLoading = false.obs;
  var problemDetails = Rxn<ProblemDetailsResponseModel>();
  var errorMessage = ''.obs;

  Future<void> fetchProblemDetails(String subId) async {
    try {
      isLoading(true);
      errorMessage('');
      final result = await service.getProblemDetails(subId);
      problemDetails(result);
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
