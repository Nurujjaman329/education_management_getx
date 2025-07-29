import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/shared_panel/problem_details/model/problem_details_response_model.dart';

class ProblemDetailsService {
  final Dio client;
  ProblemDetailsService(this.client);

  Future<ProblemDetailsResponseModel> getProblemDetails(String subId) async {
    try {
      final response = await client.get('/api/ProblemsPost/s/ProblemDetails/$subId');

      log("Request URL -> ${response.realUri}");
      log("Response status: ${response.statusCode}");
      log("Response body: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        return ProblemDetailsResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw InputException("Failed to fetch data.");
      }
    } catch (error) {
      log("ProblemDetails Error: $error");
      throw InputException("Failed to fetch data.");
    }
  }
}
