import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/payment/bkash_callback/model/bkash_callback_response_model.dart';

class BkashCallbackService {
  final Dio client;

  BkashCallbackService(this.client);

  Future<BkashCallbackResponseModel> bkashCallBack(String userId, String paymentID) async {
    try {
      final response = await client.post(
        '/api/Payment/payment/bkash/callback?paymentID=$paymentID&userId=$userId',
      );

      return BkashCallbackResponseModel.fromJson(response.data as Map<String, dynamic>);
    } catch (error) {
      log('BkashCallbackService Error: $error');
      if (error is DioException) {
        final message = error.response?.data["message"]?.toString() ?? "Unknown error";
        throw InputException(message);
      }
      throw InputException("Unexpected error occurred");
    }
  }
}
