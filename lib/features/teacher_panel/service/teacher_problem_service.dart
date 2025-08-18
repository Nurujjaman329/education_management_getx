import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/core/network/dio_client.dart';
import '../model/teacher_problem_get_model.dart';


class TeacherProblemService {
  final Dio client = DioClient.getInstance();

Future<List<TeacherProblemGetModel>> getTeacherProblem(String userId) async {
  final url = "/api/Teacher/s/AllProblems/$userId";
  try {
    log("🔹 API HIT: GET $url");
    final response = await client.get(url);
    log("✅ Response (${response.statusCode}): ${response.data}");

    if (response.statusCode == 200) {
      if (response.data is List) {
        return (response.data as List)
            .map((e) => TeacherProblemGetModel.fromJson(e))
            .toList();
      }
      if (response.data is Map && 
          (response.data as Map).containsKey('message')) {
        final message = response.data['message'].toString();
        throw InputException(message);
      }
      throw InputException("Unexpected response format");
    }
    if (response.statusCode == 404) throw AuthException();
    throw ServerException();
  } catch (e) {
    log("❌ Error getTeacherProblem: $e");
    rethrow;
  }
}

  Future<List<TeacherProblemGetModel>> postAcceptProblemTeacher(
      String userId, String postId) async {
    final url = "/api/Teacher/s/UpdateProblemFlag/$userId/$postId";
    try {
      log("🔹 API HIT: POST $url");
      final response = await client.post(url);
      log("✅ Response (${response.statusCode}): ${response.data}");

      if (response.statusCode == 200) {
        if (response.data is String) {
          final msg = response.data.toString().trim();
          throw InputException(msg);
        }
        if (response.data is List) {
          return (response.data as List)
              .map((e) => TeacherProblemGetModel.fromJson(e))
              .toList();
        }
        throw ServerException();
      }
      if (response.statusCode == 404) throw AuthException();
      throw ServerException();
    } catch (e) {
      log("❌ Error postAcceptProblemTeacher: $e");
      rethrow;
    }
  }

  Future<List<TeacherProblemGetModel>> getAcceptProblemList(String userId) async {
    final url = "/api/Teacher/s/GetAllAcceptProblem/$userId";
    try {
      log("🔹 API HIT: GET $url");
      final response = await client.get(url);
      log("✅ Response (${response.statusCode}): ${response.data}");

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((e) => TeacherProblemGetModel.fromJson(e))
            .toList();
      }
      if (response.statusCode == 404) throw AuthException();
      throw ServerException();
    } catch (e) {
      log("❌ Error getAcceptProblemList: $e");
      rethrow;
    }
  }

Future<List<TeacherProblemGetModel>> getAllSolutionList(String userId) async {
  final url = "/api/Teacher/s/AllSolutionByTeacher/$userId";
  try {
    log("🔹 API HIT: GET $url");
    final response = await client.get(url);
    log("✅ Response (${response.statusCode}): ${response.data}");

    if (response.statusCode == 200) {
      final rawData = response.data;

      // Decode if it's a String
      final decodedData = rawData is String ? jsonDecode(rawData) : rawData;

      // Ensure it's a List before mapping
      if (decodedData is List) {
        return decodedData
            .map((e) => TeacherProblemGetModel.fromJson(e))
            .toList();
      }

      log("⚠️ Unexpected format: $decodedData");
      return [];
    }

    if (response.statusCode == 404) throw AuthException();
    throw ServerException();
  } catch (e) {
    log("❌ Error getAllSolutionList: $e");
    rethrow;
  }
}


  Future<List<TeacherProblemGetModel>> getAllSolution(String postId) async {
    final url = "/api/Teacher/s/SolutionTeacherByPostId/$postId";
    try {
      log("🔹 API HIT: GET $url");
      final response = await client.get(url);
      log("✅ Response (${response.statusCode}): ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;
        final decoded = data is String ? jsonDecode(data) : data;
        if (decoded is List) {
          return decoded
              .map((e) => TeacherProblemGetModel.fromJson(e))
              .toList();
        }
        return [];
      }
      if (response.statusCode == 404) throw AuthException();
      throw ServerException();
    } catch (e) {
      log("❌ Error getAllSolution: $e");
      rethrow;
    }
  }
}

