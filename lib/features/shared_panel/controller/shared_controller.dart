import 'package:edex_365_getx/features/shared_panel/model/all_version_class_list_response_model.dart';
import 'package:edex_365_getx/features/shared_panel/model/subject_response_model.dart';
import 'package:edex_365_getx/features/shared_panel/model/user_role_response_model.dart';
import 'package:get/get.dart';
import '../model/academy_version_list_response_model.dart';
import '../service/shared_service.dart';

class SharedController extends GetxController {
  final SharedService _service = SharedService();

  var isLoading = false.obs;
  var versionList = <AcademyVersionListResponseModel>[].obs;
  var banglaClassList = <AllVersionClassListResponseModel>[].obs;
  var englishClassList = <AllVersionClassListResponseModel>[].obs;
  var userRoleList = <UserRolesResponseModel>[].obs;
  var subjectList = <SubjectResponseModel>[].obs;
  var errorMessage = ''.obs;

  // Add a method to fetch all initial data at once
  Future<void> fetchInitialData() async {
    await Future.wait([
      fetchVersions(),
      fetchBanglaClasses(),
      fetchEnglishClasses(),
      fetchSubjectList()
    ]);
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
}
