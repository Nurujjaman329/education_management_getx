import 'package:edex_365_getx/features/shared_panel/model/all_version_class_list_response_model.dart';
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
  var errorMessage = ''.obs;
  var successMessage = ''.obs;
  var error = Rxn<String>();

  // Lists
  var versionList = <AcademyVersionListResponseModel>[].obs;
  var banglaClassList = <AllVersionClassListResponseModel>[].obs;
  var englishClassList = <AllVersionClassListResponseModel>[].obs;
  var userRoleList = <UserRolesResponseModel>[].obs;
  var subjectList = <SubjectResponseModel>[].obs;
  var userDetailsList = <UserDetailsResponseModel>[].obs;
  var updatedUser = Rxn<UpdateUserInfoResponseModel>();
  var problemDetails = Rxn<ProblemDetailsResponseModel>();


  // Selected IDs
  var selectedRoleIds = <String>[].obs;
  var selectedSubjectIds = <String>[].obs;

  /// Fetch all necessary shared data (used in registration, filters, etc.)
  Future<void> fetchInitialData() async {
    await Future.wait([
      fetchVersions(),
      fetchBanglaClasses(),
      fetchEnglishClasses(),
      fetchSubjectList(),
      fetchUserRoleList(),
     // fetchProblemDetails(),
     
    ]);
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


  Future<void> fetchVersions() async {
    try {
      errorMessage.value = '';
      final versions = await _service.fetchVersion();
      versionList.assignAll(versions);
    } catch (e) {
      errorMessage.value = 'Failed to fetch version list';
      versionList.clear(); // Clear the list on error
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
      banglaClassList.clear(); // Clear the list on error
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
      englishClassList.clear(); // Clear the list on error
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
      subjectList.clear(); // Clear the list on error
      rethrow;
    }
  }

  // Optional: Add helper methods to get class names by ID
  String getEnglishClassNameById(String id) {
    return englishClassList.firstWhere(
      (element) => element.id == id,
      orElse: () => AllVersionClassListResponseModel(id: '', className: 'Unknown'),
    ).className;
  }

  String getBanglaClassNameById(String id) {
    return banglaClassList.firstWhere(
      (element) => element.id == id,
      orElse: () => AllVersionClassListResponseModel(id: '', className: 'Unknown'),
    ).className;
  }


  /// Fetch user details by ID
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
      final result = await _service.updatePassword(userId, oldPassword, newPassword);
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
    updatedUser.value = result; // ✅ now matches the type
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

}
