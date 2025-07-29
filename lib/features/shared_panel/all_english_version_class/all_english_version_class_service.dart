import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/shared_panel/all_english_version_class/model/all_english_version_class_response_model.dart';

class AllEnglishVersionClassService {
  final Dio client = Dio();

  Future<List<AllEnglishVersionClassResponseModel>> fetchClasses() async {
    try {
      final response = await client.get("https://api.edex365.com/api/class/s/AllClass");

      log('Subject API response: ${response.data}');
      switch (response.statusCode) {
        case 200:
          List<dynamic> data = response.data;
          return data.map((e) => AllEnglishVersionClassResponseModel.fromJson(e)).toList();
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