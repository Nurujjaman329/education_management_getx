import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/student_panel/model/parameter_body/problem_post_body.dart';
import '../../../../core/network/dio_client.dart';import '../model/problem_post_response_model.dart';

class StudentProblemPostService {
  final Dio client = DioClient.getInstance();

  Future<ProblemPostResponseModel> postProblem(ProblemPostBody body) async {
    try {
      final formData = await body.toFormData();
      log("Sending problem post to ${client.options.baseUrl}/api/ProblemsPost/s/ProblemsPost");
      log("Request body: $formData");

      final response = await client.post("/api/ProblemsPost/s/ProblemsPost", data: formData);

      log("Response status: ${response.statusCode}");
      log("Response data: ${response.data}");

      switch (response.statusCode) {
        case 200:
          return ProblemPostResponseModel.fromJson(response.data);
        case 422:
          final message = response.data['message'] ?? 'No teacher available for this skill';
          throw InputException(message);
        case 404:
          throw AuthException();
        default:
          throw ServerException();
      }
    } catch (e) {
      log("Exception in postProblem: $e");
      rethrow;
    }
  }
}

