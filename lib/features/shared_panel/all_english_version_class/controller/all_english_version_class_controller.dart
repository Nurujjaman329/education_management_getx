import 'package:edex_365_getx/features/shared_panel/all_english_version_class/all_english_version_class_service.dart';
import 'package:edex_365_getx/features/shared_panel/all_english_version_class/model/all_english_version_class_response_model.dart';
import 'package:get/get.dart';


class AllEnglishVersionClassController extends GetxController {
  final AllEnglishVersionClassService _service = AllEnglishVersionClassService();

  var englishVersions = <AllEnglishVersionClassResponseModel>[].obs;
  var selectedEnglishVersionsIds = <String>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> loadEnglishVersions() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedEnglishVersions = await _service.fetchClasses();
      englishVersions.assignAll(fetchedEnglishVersions);
    } catch (e) {
      errorMessage.value = 'Failed to load English Versions';
    } finally {
      isLoading.value = false;
    }
  }

  void toggleEnglishVersion(String id) {
    if (selectedEnglishVersionsIds.contains(id)) {
      selectedEnglishVersionsIds.remove(id);
    } else {
      selectedEnglishVersionsIds.add(id);
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadEnglishVersions();
  }
}