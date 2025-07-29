import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';

class StudentWalletService {
  final Dio client;

  StudentWalletService(this.client);

  Future<String> getStudentWallet(String userId) async {
    final String url = "/api/StudentWallet/s/GetTotalBalance?userId=$userId";

    try {
      final fullUrl = client.options.baseUrl + url;
      log('Fetching student wallet for userId: $userId');
      log('Request Full URL: $fullUrl');

      final response = await client.get(url);
      log('Response Status Code: ${response.statusCode}');
      log('Response Data: ${response.data}');
      log("Request URI -> ${response.realUri}");

      if (response.statusCode == 200) {
        if (response.data is String) {
          final raw = response.data as String;
          final balance = raw.replaceAll("Balance:", "").trim();
          return balance;
        } else {
          throw ServerException();
        }
      } else if (response.statusCode == 404) {
        throw AuthException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      log('Error fetching student wallet: $e');
      rethrow;
    }
  }
}
