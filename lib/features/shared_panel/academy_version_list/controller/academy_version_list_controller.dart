import 'package:edex_365_getx/features/shared_panel/academy_version_list/academy_version_list_service.dart';
import 'package:get/get.dart';
import '../model/academy_version_list_response_model.dart';

class AcademyVersionListController extends GetxController {
  final AcademyVersionListService _service = AcademyVersionListService();

  var subjects = <AcademyVersionListResponseModel>[].obs;
  var selectedVersionIds = <String>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> loadVersions() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedVersions = await _service.fetchVersion();
      subjects.assignAll(fetchedVersions);
    } catch (e) {
      errorMessage.value = 'Failed to load subjects';
    } finally {
      isLoading.value = false;
    }
  }

  void toggleVersion(String id) {
    if (selectedVersionIds.contains(id)) {
      selectedVersionIds.remove(id);
    } else {
      selectedVersionIds.add(id);
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadVersions();
  }
}
