import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/student_panel/student_sloution_list/model/student_sloution_list_response_model.dart';

class StudentSloutionListService {
  final Dio client;

  StudentSloutionListService(this.client);

  Future<List<StudentSloutionListResponseModel>> solutionGet(String postId) async {
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
        List<dynamic> body = response.data as List<dynamic>;
        return body
            .map((e) => StudentSloutionListResponseModel.fromJson(e))
            .toList();
      } else if (response.statusCode == 404) {
        log('No solutions found for the provided postId: $postId');
        throw AuthException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      log('Error fetching student solutions: $e');
      rethrow;
    }
  }
}
