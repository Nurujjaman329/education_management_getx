import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_problem_get/model/teacher_problem_get_model.dart';


class TeacherProblemGetService {
  final Dio client;

  TeacherProblemGetService(this.client);

  /// 🔍 Get all teacher problems by userId
  Future<List<TeacherProblemGetModel>> getTeacherProblem(String userId) async {
    final String url = "/api/Teacher/s/AllProblems/$userId";
    try {
      final fullUrl = client.options.baseUrl + url;
      log('Fetching teacher problems for userId: $userId');
      log('Request Full URL: $fullUrl');

      final response = await client.get(url);
      log('Response Status Code: ${response.statusCode}');
      log('Response Data: ${response.data}');
      log("Request URI -> ${response.realUri}");

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
        log('No problems found for the provided user ID: $userId');
        throw AuthException();
      }

      throw ServerException();
    } catch (e) {
      log('Error fetching teacher problems: $e');
      rethrow;
    }
  }

  /// ✅ Accept a specific teacher problem
  Future<List<TeacherProblemGetModel>> postAcceptProblemTeacher(
      String userId, String postId) async {
    try {
      log("Initiating POST request to /api/Teacher/s/UpdateProblemFlag");

      final response = await client.post(
        '/api/Teacher/s/UpdateProblemFlag/$userId/$postId',
      );

      log("Request URI: ${response.realUri}");
      log("Response Status Code: ${response.statusCode}");
      log("Response Body===>: ${response.data}");

      if (response.statusCode == 200) {
        if (response.data is String) {
          String serverMessage = response.data.toString().trim();

          if (serverMessage.toLowerCase() == "already have a task.") {
            throw InputException("You have already accepted another problem. Please solve it first.");
          } else {
            throw InputException(serverMessage);
          }
        } else if (response.data is List) {
          return (response.data as List)
              .map((e) => TeacherProblemGetModel.fromJson(e))
              .toList();
        } else {
          throw ServerException();
        }
      } else if (response.statusCode == 404) {
        log('No problems found for the provided user ID: $userId');
        throw AuthException();
      } else {
        log('Unexpected server response: ${response.statusCode}');
        throw ServerException();
      }
    } catch (error) {
      log('Caught Error: ${error.toString()}');
      if (error is InputException) rethrow;
      throw InputException("Invalid Input");
    }
  }




  Future<List<TeacherProblemGetModel>> getAcceptProblemList(String userId) async {
  try {
    final String url = "/api/Teacher/s/GetAllAcceptProblem/$userId";
    final response = await client.get(url);

    switch (response.statusCode) {
      case 200:
        List<dynamic> body = response.data as List<dynamic>;
        return body
            .map((json) => TeacherProblemGetModel.fromJson(json))
            .toList();

      case 404:
        throw AuthException();

      default:
        throw ServerException();
    }
  } catch (e) {
    rethrow;
  }
}


Future<List<TeacherProblemGetModel>> getAllSolutionList(String userId) async {
  try {
    final String url = "/api/Teacher/s/AllSolutionByTeacher/$userId";
    final response = await client.get(url);

    switch (response.statusCode) {
      case 200:
        List<dynamic> body = response.data as List<dynamic>;
        return body
            .map((json) => TeacherProblemGetModel.fromJson(json))
            .toList();

      case 404:
        throw AuthException();

      default:
        throw ServerException();
    }
  } catch (e) {
    rethrow;
  }
}


}

