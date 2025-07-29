import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/student_panel/problem_post/model/problem_post_body.dart';
import 'package:edex_365_getx/features/student_panel/problem_post/model/problem_post_response_model.dart';

class ProblemPostService {
  final Dio client;

  ProblemPostService(this.client);

  Future<ProblemPostResponseModel> problemPost(ProblemPostBody problemPostBody) async {
    try {
      log('Request: ${problemPostBody.postTypeId} ${problemPostBody.subject}, ${problemPostBody.topic}, ${problemPostBody.sClass}, ${problemPostBody.photo?.path}, ${problemPostBody.description}, ${problemPostBody.userId}');

      FormData formData = await problemPostBody.toFormData();

      log('FormData: ${formData.fields}, File: ${formData.files}');

      final response = await client.post("/api/ProblemsPost/s/ProblemsPost", data: formData);

      log('Response Status: ${response.statusCode}');
      log('Response Data: ${response.data}');

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
      log('Error: $e');
      rethrow;
    }
  }
}
