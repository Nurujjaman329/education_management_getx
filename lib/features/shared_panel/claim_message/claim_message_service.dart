import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/shared_panel/claim_message/model/claim_message_response_model.dart';

class ClaimMessageService {
  final Dio client;
  ClaimMessageService(this.client);

  Future<String> claimMessage({
    required String text,
    required String userId,
    required String solutionId,
    File? voiceUrl,
    File? imageUrl,
  }) async {
    try {
      final url = '/api/ClaimCommunication/s/ClaimSaveMessage?userId=$userId&solutionId=$solutionId';
      final formData = FormData();

      formData.fields.add(MapEntry('text', text));

      if (voiceUrl != null) {
        final fileName = voiceUrl.path.split('/').last;
        formData.files.add(MapEntry(
          'voiceUrl',
          await MultipartFile.fromFile(voiceUrl.path, filename: fileName),
        ));
      }

      if (imageUrl != null) {
        final fileName = imageUrl.path.split('/').last;
        formData.files.add(MapEntry(
          'imageUrl',
          await MultipartFile.fromFile(imageUrl.path, filename: fileName),
        ));
      }

      final response = await client.post(url, data: formData);
      log("Claim Message Sent: ${response.realUri}");

      if (response.data is Map<String, dynamic>) {
        return response.data['message'] ?? 'No message returned';
      } else {
        throw InputException('Unexpected response format');
      }
    } catch (e) {
      log('Send Claim Message Error: $e');
      throw InputException("Failed to send claim message");
    }
  }

  Future<List<ClaimMessageResponseModel>> getClaimChat(String solutionId) async {
    try {
      final response = await client.get('/api/ClaimCommunication/GetSolutionChat?solutionId=$solutionId');
      log("Fetch Chat URL: ${response.realUri}");

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data is List) {
          return data
              .map((e) => ClaimMessageResponseModel.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          throw InputException("Unexpected response format");
        }
      } else {
        throw ServerException();
      }
    } catch (e) {
      log('Fetch Chat Error: $e');
      throw InputException("Failed to fetch chat messages");
    }
  }
}
