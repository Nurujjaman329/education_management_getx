import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/features/student_panel/transaction_history/model/transaction_history_response_model.dart';
import '../../../../core/error/exceptions.dart';

class TransactionHistoryService {
  final Dio client;

  TransactionHistoryService(this.client);

  Future<List<TransactionHistoryResponseModel>> getRechargeHistory(String userId) async {
    return _fetchTransactions("/api/StudentWallet/s/StudentTransaction?userId=$userId");
  }

  Future<List<TransactionHistoryResponseModel>> getSpentHistory(String userId) async {
    return _fetchTransactions("/api/StudentWallet/s/StudentSpentTransaction?userId=$userId");
  }

  Future<List<TransactionHistoryResponseModel>> _fetchTransactions(String url) async {
    try {
      final fullUrl = client.options.baseUrl + url;
      log('Request URL: $fullUrl');

      final response = await client.get(url);
      log('Response Status Code: ${response.statusCode}');
      log('Response Data: ${response.data}');
      log("Request URI -> ${response.realUri}");

      if (response.statusCode == 200) {
        if (response.data is List) {
          return (response.data as List)
              .map((e) => TransactionHistoryResponseModel.fromJson(e))
              .toList();
        } else if (response.data is String) {
          log("API returned a string instead of a list: ${response.data}");
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
      log('Error fetching transaction history: $e');
      rethrow;
    }
  }
}
