import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_solution/model/teacher_solution_body.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_solution/model/teacher_solution_response_model.dart';

class TeacherSolutionService {
  final Dio client;

  TeacherSolutionService(this.client);

  Future<List<TeacherSolutionResponseModel>> solutionPost(
    TeacherSolutionBody body,
    String postId,
  ) async {
    final formData = await body.toFormData();
    debugPrint('FormData: $formData');

    try {
      final url = '/api/SolutionPost/s/SolutionPost/$postId';
      debugPrint('Request URL: $url');

      final response = await client.post(url, data: formData);

      debugPrint('Response Status: ${response.statusCode}');
      debugPrint('Response Data: ${response.data}');

      switch (response.statusCode) {
        case 200:
          if (response.data is List) {
            return (response.data as List)
                .map((item) => TeacherSolutionResponseModel.fromJson(item))
                .toList();
          } else {
            return [TeacherSolutionResponseModel.fromJson(response.data)];
          }
        case 400:
          throw InputException("Input Error");
        case 404:
          throw AuthException();
        default:
          throw ServerException();
      }
    } catch (e, stackTrace) {
      debugPrint('Error in solutionPost: $e\n$stackTrace');
      throw ServerException();
    }
  }
}
