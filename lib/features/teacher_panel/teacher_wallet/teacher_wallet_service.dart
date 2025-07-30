import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';

class TeacherWalletService {
  final Dio client;

  TeacherWalletService(this.client);

  Future<String> getTeacherWallet(String userId) async {
    final String url = "/api/TeacherWallet/s/GetTotalTeacherBalance?userId=$userId";
    
    try {
      final fullUrl = client.options.baseUrl + url;
      log('🔄 Fetching teacher wallet for userId: $userId');
      log('🌐 Full URL: $fullUrl');

      final response = await client.get(url);

      log('📦 Status Code: ${response.statusCode}');
      log('🧾 Response Data: ${response.data}');
      log("🔗 Request URI: ${response.realUri}");

      if (response.statusCode == 200) {
        if (response.data is String) {
          final raw = response.data as String;
          final balance = raw.replaceAll("Balance:", "").trim();
          log('✅ Parsed Balance: $balance');
          return balance;
        } else {
          throw ServerException();
        }
      } else if (response.statusCode == 404) {
        log('❌ Wallet not found for user ID: $userId');
        throw AuthException();
      } else {
        log('❌ Unexpected status: ${response.statusCode}');
        throw ServerException();
      }
    } catch (e) {
      log('🔥 Error fetching teacher wallet: $e');
      rethrow;
    }
  }
}
