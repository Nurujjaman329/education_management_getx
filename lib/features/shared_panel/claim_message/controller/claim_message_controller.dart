import 'dart:io';
import 'package:edex_365_getx/features/shared_panel/claim_message/claim_message_service.dart';
import 'package:edex_365_getx/features/shared_panel/claim_message/model/claim_message_response_model.dart';
import 'package:get/get.dart';


class ClaimMessageController extends GetxController {
  final ClaimMessageService service;

  ClaimMessageController(this.service);

  var isSending = false.obs;
  var isFetching = false.obs;
  var chatList = <ClaimMessageResponseModel>[].obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;

  Future<void> postClaimMessage({
    required String text,
    required String userId,
    required String solutionId,
    File? voiceUrl,
    File? imageUrl,
  }) async {
    try {
      isSending(true);
      errorMessage('');
      successMessage('');

      final result = await service.claimMessage(
        text: text,
        userId: userId,
        solutionId: solutionId,
        voiceUrl: voiceUrl,
        imageUrl: imageUrl,
      );

      successMessage(result);
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isSending(false);
    }
  }

  Future<void> fetchClaimChat(String solutionId) async {
    try {
      isFetching(true);
      errorMessage('');
      chatList.clear();

      final result = await service.getClaimChat(solutionId);
      chatList.assignAll(result);
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isFetching(false);
    }
  }
}
