// lib/features/student_panel/services/student_problem_list_service.dart
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/network/dio_client.dart';
import 'package:edex_365_getx/features/student_panel/model/student_problem_list_response_model.dart';

class StudentProblemListService {
  final Dio client = DioClient.getInstance();

  Future<List<StudentProblemListResponseModel>> _fetchProblems(String url) async {
    try {
      final fullUrl = client.options.baseUrl + url;
      log('➡️ Fetching from URL: $fullUrl');

      final response = await client.get(url);

      log('⬅️ Response status: ${response.statusCode}');
      log('⬅️ Response data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data is List) {
          final list = (response.data as List)
              .map((e) => StudentProblemListResponseModel.fromJson(e))
              .toList();
          log('✅ Parsed list length: ${list.length}');
          if (list.isEmpty) {
            log('⚠️ Returned list is empty for $fullUrl');
          }
          return list;
        } else if (response.data is String) {
          log('⚠️ Empty or string response for $fullUrl');
          return [];
        } else {
          log('❌ Unexpected response type for $fullUrl: ${response.data.runtimeType}');
          throw Exception('ServerException');
        }
      } else if (response.statusCode == 404) {
        log('❌ 404 Not Found for $fullUrl');
        throw Exception('AuthException');
      } else {
        log('❌ ServerException for $fullUrl, status: ${response.statusCode}');
        throw Exception('ServerException');
      }
    } catch (e) {
      log('❌ Error fetching from $url: $e');
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
