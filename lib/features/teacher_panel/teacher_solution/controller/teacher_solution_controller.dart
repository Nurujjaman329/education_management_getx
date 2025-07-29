import 'package:edex_365_getx/features/teacher_panel/teacher_solution/model/teacher_solution_body.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_solution/model/teacher_solution_response_model.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_solution/teacher_solution_service.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class TeacherSolutionPostController extends GetxController {
  final TeacherSolutionService _service;

  TeacherSolutionPostController(this._service);

  var isLoading = false.obs;
  var responseList = <TeacherSolutionResponseModel>[].obs;
  var errorMessage = ''.obs;

  Future<void> postSolution(TeacherSolutionBody body, String postId) async {
    isLoading.value = true;
    errorMessage.value = '';
    responseList.clear();

    try {
      final result = await _service.solutionPost(body, postId);
      responseList.value = result;
    } catch (e) {
      debugPrint('Error: $e');
      errorMessage.value = 'Something went wrong';
    } finally {
      isLoading.value = false;
    }
  }
}

