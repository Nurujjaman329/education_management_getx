import 'package:edex_365_getx/features/shared_panel/all_english_version_class/all_english_version_class_service.dart';
import 'package:edex_365_getx/features/shared_panel/all_english_version_class/model/all_english_version_class_response_model.dart';
import 'package:get/get.dart';


class AllEnglishVersionClassController extends GetxController {
  final AllEnglishVersionClassService _service = AllEnglishVersionClassService();

  var subjects = <AllEnglishVersionClassResponseModel>[].obs;
  var selectedSubjectIds = <String>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> loadSubjects() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedSubjects = await _service.fetchClasses();
      subjects.assignAll(fetchedSubjects);
    } catch (e) {
      errorMessage.value = 'Failed to load subjects';
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSubject(String id) {
    if (selectedSubjectIds.contains(id)) {
      selectedSubjectIds.remove(id);
    } else {
      selectedSubjectIds.add(id);
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadSubjects();
  }
}