import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';

class CommunicationMessageService {
  final Dio client;
  CommunicationMessageService(this.client);

  Future<String> postMessage({
    required String text,
    required String userId,
    required String problemPostId,
    File? voiceUrl,
  }) async {
    try {
      final encodedText = Uri.encodeComponent(text);
      final url =
          '/api/Communication/s/SaveMessage?Text=$encodedText&userId=$userId&problempostId=$problemPostId';

      final formData = FormData();

      if (voiceUrl != null) {
        final fileName = voiceUrl.path.split('/').last;
        formData.files.add(MapEntry(
          'voiceUrl',
          await MultipartFile.fromFile(voiceUrl.path, filename: fileName),
        ));
      }

      final response = await client.post(
        url,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      log("BothPanel URL -> ${response.realUri}");
      log("Response body -> ${response.data}");

      final data = response.data as Map<String, dynamic>;
      return data['message'] ?? 'No message returned';
    } catch (error) {
      log('BothPanelMessage Error: $error');
      throw InputException("Failed to send message");
    }
  }
}
