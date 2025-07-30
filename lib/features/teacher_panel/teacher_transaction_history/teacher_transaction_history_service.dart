import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/teacher_panel/teacher_transaction_history/model/teacher_transaction_history_response_model.dart';

class TeacherTransactionHistoryService {
  final Dio client;

  TeacherTransactionHistoryService(this.client);

  Future<List<TeacherTransactionHistoryResponseModel>> getTransactionHistory(String userId) async {
    final String url = "/api/TeacherWallet/s/TeacherTransaction?userId=$userId";
    try {
      final fullUrl = client.options.baseUrl + url;
      log('Fetching teacher transaction history for userId: $userId');
      log('Request Full URL: $fullUrl');

      final response = await client.get(url);
      log('Response Status Code: ${response.statusCode}');
      log('Response Data: ${response.data}');
      log("Request URI -> ${response.realUri}");

      if (response.statusCode == 200) {
        if (response.data is List) {
          return (response.data as List)
              .map((e) => TeacherTransactionHistoryResponseModel.fromJson(e))
              .toList();
        } else if (response.data is String) {
          log("API returned string instead of list. Treating as empty.");
          return [];
        } else {
          throw ServerException();
        }
      } else if (response.statusCode == 404) {
        log('No transaction history found for userId: $userId');
        throw AuthException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      log('Error fetching transaction history: $e');
      rethrow;
    }
  }
}
