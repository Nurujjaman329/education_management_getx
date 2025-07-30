import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_problem_get/model/teacher_problem_get_model.dart';

class TeacherProblemGetService {
  final Dio client;
  TeacherProblemGetService(this.client);

  Future<List<TeacherProblemGetModel>> getTeacherProblems(String userId) async {
    final String url = "/api/Teacher/s/AllProblems/$userId";

    try {
      final fullUrl = client.options.baseUrl + url;
      log('Fetching teacher problems for userId: $userId');
      log('Request Full URL: $fullUrl');

      final response = await client.get(url);
      log('Response Status Code: ${response.statusCode}');
      log('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic> && data.containsKey('message')) {
          final message = data['message'].toString();
          log('Block Message Detected: $message');

          if (message.toLowerCase().contains('temporarily blocked') ||
              message.toLowerCase().contains('unblock time')) {
            throw InputException(message);
          }
        }

        if (data is List) {
          return data.map((e) => TeacherProblemGetModel.fromJson(e)).toList();
        }

        throw InputException('Unexpected response format from the server.');
      }

      if (response.statusCode == 404) {
        log('No problems found for userId: $userId');
        throw AuthException();
      }

      throw ServerException();
    } catch (e) {
      log('Error fetching teacher problems: $e');
      rethrow;
    }
  }
}
