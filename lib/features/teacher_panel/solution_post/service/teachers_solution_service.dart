import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/features/teacher_panel/solution_post/model/teachers_solution_body.dart';
import 'package:edex_365_getx/features/teacher_panel/solution_post/model/teachers_solution_response.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/error/exceptions.dart';

class TeacherSolutionService {
  final Dio client = DioClient.getInstance();

  Future<List<TeachersSolutionResponseBodyModel>> solutionPost(
    TeachersSolutionBody teacherSolutionBody,
    String postId,
  ) async {
    final formData = await teacherSolutionBody.toFormData();
    log('=> FormData: $formData');

    try {
      final url = '/api/SolutionPost/s/SolutionPost/$postId';
      log('Request URL: $url');

      final response = await client.post(url, data: formData);

      log('Response Status: ${response.statusCode}');
      log('Response Data: ${response.data}');
      log('Final URL: ${response.realUri}');

      switch (response.statusCode) {
        case 200:
          return TeachersSolutionResponseBodyModel.fromJsonList(
              response.data as List<dynamic>);
        case 400:
          throw InputException("Input Error");
        case 404:
          throw AuthException();
        default:
          throw ServerException();
      }
    } catch (error, stackTrace) {
      log('Error in solutionPost: $error\n$stackTrace');
      throw ServerException();
    }
  }
}
