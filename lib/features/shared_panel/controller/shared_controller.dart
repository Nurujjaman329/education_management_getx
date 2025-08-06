import 'dart:io';
import 'package:edex_365_getx/features/shared_panel/model/all_version_class_list_response_model.dart';
import 'package:edex_365_getx/features/shared_panel/model/get_claim_message_response_model.dart';
import 'package:edex_365_getx/features/shared_panel/model/problem_details_response_model.dart';
import 'package:edex_365_getx/features/shared_panel/model/subject_response_model.dart';
import 'package:edex_365_getx/features/shared_panel/model/update_user_info_response_model.dart';
import 'package:edex_365_getx/features/shared_panel/model/user_details_response_model.dart';
import 'package:edex_365_getx/features/shared_panel/model/user_role_response_model.dart';
import 'package:get/get.dart';
import '../model/academy_version_list_response_model.dart';
import '../service/shared_service.dart';

class SharedController extends GetxController {
  final SharedService _service = SharedService();

  // Observables
  var isLoading = false.obs;
  var isSending = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;
  var error = Rxn<String>();
  var responseMessage = ''.obs;

  // Lists
  var versionList = <AcademyVersionListResponseModel>[].obs;
  var banglaClassList = <AllVersionClassListResponseModel>[].obs;
  var englishClassList = <AllVersionClassListResponseModel>[].obs;
  var userRoleList = <UserRolesResponseModel>[].obs;
  var subjectList = <SubjectResponseModel>[].obs;
  var userDetailsList = <UserDetailsResponseModel>[].obs;
  var updatedUser = Rxn<UpdateUserInfoResponseModel>();
  var problemDetails = Rxn<ProblemDetailsResponseModel>();
  var claimMessages = <GetClaimMessageResponseModel>[].obs;

  // Selected IDs
  var selectedRoleIds = <String>[].obs;
  var selectedSubjectIds = <String>[].obs;

  // Fetch all shared data used during registration, filters, etc.
  Future<void> fetchInitialData() async {
    await Future.wait([
      fetchVersions(),
      fetchBanglaClasses(),
      fetchEnglishClasses(),
      fetchSubjectList(),
      fetchUserRoleList(),
    ]);
  }

  Future<void> fetchVersions() async {
    try {
      errorMessage.value = '';
      final versions = await _service.fetchVersion();
      versionList.assignAll(versions);
    } catch (e) {
      errorMessage.value = 'Failed to fetch version list';
      versionList.clear();
      rethrow;
    }
  }

  Future<void> fetchBanglaClasses() async {
    try {
      errorMessage.value = '';
      final classes = await _service.fetchBanglaVersionClassList();
      banglaClassList.assignAll(classes);
    } catch (e) {
      errorMessage.value = 'Failed to fetch Bangla version classes';
      banglaClassList.clear();
      rethrow;
    }
  }

  Future<void> fetchEnglishClasses() async {
    try {
      errorMessage.value = '';
      final classes = await _service.fetchEnglishVersionClassList();
      englishClassList.assignAll(classes);
    } catch (e) {
      errorMessage.value = 'Failed to fetch English version classes';
      englishClassList.clear();
      rethrow;
    }
  }

  Future<void> fetchSubjectList() async {
    try {
      errorMessage.value = '';
      final subjects = await _service.fetchSubjectList();
      subjectList.assignAll(subjects);
    } catch (e) {
      errorMessage.value = 'Failed to fetch subjects';
      subjectList.clear();
      rethrow;
    }
  }

  Future<void> fetchUserRoleList() async {
    try {
      errorMessage.value = '';
      final roles = await _service.fetchUserRoleList();
      userRoleList.assignAll(roles);
    } catch (e) {
      errorMessage.value = 'Failed to fetch user roles';
      userRoleList.clear();
      rethrow;
    }
  }

  String getEnglishClassNameById(String id) {
    return englishClassList
        .firstWhere(
          (e) => e.id == id,
          orElse: () =>
              AllVersionClassListResponseModel(id: '', className: 'Unknown'),
        )
        .className;
  }

  String getBanglaClassNameById(String id) {
    return banglaClassList
        .firstWhere(
          (e) => e.id == id,
          orElse: () =>
              AllVersionClassListResponseModel(id: '', className: 'Unknown'),
        )
        .className;
  }

  Future<void> fetchUserDetails(String userId) async {
    try {
      isLoading.value = true;
      error.value = null;
      final result = await _service.getUserDetails(userId);
      userDetailsList.assignAll(result);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    successMessage.value = '';

    try {
      final result =
          await _service.updatePassword(userId, oldPassword, newPassword);
      successMessage.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser(UpdateDetailsResponseBody updateBody) async {
    isLoading.value = true;
    error.value = null;

    try {
      final result = await _service.updateUser(updateBody);
      updatedUser.value = result;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProblemDetails(String problemId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await _service.getProblemDetails(problemId);
      problemDetails.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage({
    required String text,
    required String userId,
    required String solutionId,
    File? voiceFile,
    File? imageFile,
  }) async {
    try {
      isSending.value = true;
      errorMessage.value = '';
      final result = await _service.claimMessage(
        text,
        userId,
        solutionId,
        voiceFile,
        imageFile,
      );

      responseMessage.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isSending.value = false;
    }
  }

  Future<void> fetchClaimMessages(String solutionId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await _service.getClaimChat(solutionId);
      claimMessages.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
      claimMessages.clear();
    } finally {
      isLoading.value = false;
    }
  }


    Future<void> sendPendingMessage({
    required String text,
    required String userId,
    required String problemPostId,
    File? voiceFile,
  }) async {
    try {
      isLoading.value = true;
      responseMessage.value = '';
      errorMessage.value = '';

      final message = await _service.postMessage(
        text: text,
        userId: userId,
        problemPostId: problemPostId,
        voiceFile: voiceFile,
      );

      responseMessage.value = message;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
 
}
