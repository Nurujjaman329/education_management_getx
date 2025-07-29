import 'dart:io';
import 'package:edex_365_getx/features/shared_panel/communication_message/communication_message_service.dart';
import 'package:get/get.dart';

class CommunicationMessageController extends GetxController {
  final CommunicationMessageService service;
  CommunicationMessageController(this.service);

  var isLoading = false.obs;
  var successMessage = ''.obs;
  var errorMessage = ''.obs;

  Future<void> postMessage({
    required String text,
    required String userId,
    required String problemPostId,
    File? voiceUrl,
  }) async {
    try {
      isLoading(true);
      errorMessage('');
      successMessage('');

      final result = await service.postMessage(
        text: text,
        userId: userId,
        problemPostId: problemPostId,
        voiceUrl: voiceUrl,
      );

      successMessage(result);
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
