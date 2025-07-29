import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/features/student_panel/student_problem_list/model/student_problem_list_response_model.dart';
import '../../../../core/error/exceptions.dart';

class StudentProblemService {
  final Dio client;

  StudentProblemService(this.client);

  Future<List<StudentProblemListResponseModel>> _fetchProblems(String url) async {
    try {
      final fullUrl = client.options.baseUrl + url;
      log('Request URL: $fullUrl');

      final response = await client.get(url);
      log('Status: ${response.statusCode}');
      log('Data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data is List) {
          return (response.data as List)
              .map((e) => StudentProblemListResponseModel.fromJson(e))
              .toList();
        } else if (response.data is String) {
          return [];
        } else {
          throw ServerException();
        }
      } else if (response.statusCode == 404) {
        throw AuthException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      log('Error fetching problems: $e');
      rethrow;
    }
  }

  Future<List<StudentProblemListResponseModel>> getStudentProblems(String userId) {
    return _fetchProblems("/api/ProblemsPost/s/AllProblemsPost/$userId");
  }

  Future<List<StudentProblemListResponseModel>> getPendingProblems(String userId) {
    return _fetchProblems("/api/ProblemsPost/s/AllPendingPost/$userId");
  }

  Future<List<StudentProblemListResponseModel>> getSolvedProblems(String userId) {
    return _fetchProblems("/api/ProblemsPost/s/AllSolutionsPost/$userId");
  }
}
