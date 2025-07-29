import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/payment/bkash_create_payment/model/bkash_create_payment_response_model.dart';

class BkashCreatePaymentService {
  final Dio client;

  BkashCreatePaymentService(this.client);

  Future<BkashCreatePaymentResponseModel> bkashCreatePayment(String userId, double amount) async {
    try {
      final response = await client.post(
        '/api/Payment/Bkash/create-payment',
        data: jsonEncode(<String, dynamic>{
          'userId': userId,
          'amount': amount,
        }),
      );

      return BkashCreatePaymentResponseModel.fromJson(response.data as Map<String, dynamic>);
    } catch (error) {
      log('BkashPaymentService Error: $error');
      if (error is DioException) {
        final message = error.response?.data["message"]?.toString() ?? "Unknown error";
        throw InputException(message);
      }
      throw InputException("Unexpected error occurred");
    }
  }
}
