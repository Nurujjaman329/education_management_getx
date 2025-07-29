
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/shared_panel/subject/model/subject_response_model.dart';
import 'package:dio/dio.dart';


import 'dart:developer';


class SubjectService {
  final Dio client = Dio();

  Future<List<SubjectResponseModel>> fetchSubjects() async {
    try {
      final response = await client.get("https://api.edex365.com/api/subject/s/AllSubject");

      log('Subject API response: ${response.data}');
      switch (response.statusCode) {
        case 200:
          List<dynamic> data = response.data;
          return data.map((e) => SubjectResponseModel.fromJson(e)).toList();
        case 404:
          throw AuthException();
        default:
          throw ServerException();
      }
    } catch (e) {
      log("Subject fetch error: $e");
      rethrow;
    }
  }
}


