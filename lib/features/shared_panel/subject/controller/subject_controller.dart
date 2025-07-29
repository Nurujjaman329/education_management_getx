import 'package:edex_365_getx/features/shared_panel/subject/subject_service.dart';
import 'package:get/get.dart';
import '../model/subject_response_model.dart';

class SubjectController extends GetxController {
  final SubjectService _service = SubjectService();

  var subjects = <SubjectResponseModel>[].obs;
  var selectedSubjectIds = <String>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> loadSubjects() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedSubjects = await _service.fetchSubjects();
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
