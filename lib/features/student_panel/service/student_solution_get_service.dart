import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/core/network/dio_client.dart';
import 'package:edex_365_getx/features/student_panel/model/students_solution_get_response_body_model.dart';

class StudentSolutionGetService {
  final Dio client = DioClient.getInstance();

  Future<List<StudentsSolutionGetResponseBodyModel>> getSolutions(String postId) async {
    final String url = "/api/SolutionPost/s/Solution/$postId";
    try {
      final fullUrl = client.options.baseUrl + url;
      log('Fetching student solutions for postId: $postId');
      log('Request Full URL: $fullUrl');

      final response = await client.get(url);
      log('Response Status Code: ${response.statusCode}');
      log('Response Data: ${response.data}');
      log("Request URI -> ${response.realUri}");

      if (response.statusCode == 200) {
        List<dynamic> body = response.data;
        return body
            .map((e) => StudentsSolutionGetResponseBodyModel.fromJson(e))
            .toList();
      } else if (response.statusCode == 404) {
        log('No solutions found for postId: $postId');
        throw AuthException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      log('Error fetching solutions: $e');
      rethrow;
    }
  }
}
