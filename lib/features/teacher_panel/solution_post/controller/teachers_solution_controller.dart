import 'dart:io';
import 'package:edex_365_getx/features/teacher_panel/solution_post/model/teachers_solution_body.dart';
import 'package:edex_365_getx/features/teacher_panel/solution_post/model/teachers_solution_response.dart';
import 'package:edex_365_getx/features/teacher_panel/solution_post/service/teachers_solution_service.dart';
import 'package:get/get.dart';


class TeacherSolutionController extends GetxController {
  final TeacherSolutionService _service = TeacherSolutionService();

  

  var isLoading = false.obs;
  var solutions = <TeachersSolutionResponseBodyModel>[].obs;
  var errorMessage = ''.obs;

  /// store selected images
  var selectedImages = <File>[].obs;

  Future<void> postSolution(String teacherId, String postId) async {
    if (selectedImages.isEmpty) {
      errorMessage.value = "Please select at least one image.";
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final body = TeachersSolutionBody(
        teacherId: teacherId,
        photos: selectedImages.toList(),
      );

      final result = await _service.solutionPost(body, postId);
      solutions.assignAll(result);

      // clear after successful post
      selectedImages.clear();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
