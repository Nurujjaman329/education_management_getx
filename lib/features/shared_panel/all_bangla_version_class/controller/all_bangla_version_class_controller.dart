import 'package:edex_365_getx/features/shared_panel/all_bangla_version_class/all_bangla_version_class_service.dart';
import 'package:edex_365_getx/features/shared_panel/all_bangla_version_class/model/all_bangla_version_class_response_model.dart';
import 'package:get/get.dart';


class AllBanglaVersionClassController extends GetxController {
  final AllBanglaVersionClassService _service = AllBanglaVersionClassService();

  var banglaClass = <AllBanglaVersionClassResponseModel>[].obs;
  var selectedBanglaVersionIds = <String>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> loadBanglaVersion() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedBanglaVersions = await _service.fetchClasses();
      banglaClass.assignAll(fetchedBanglaVersions);
    } catch (e) {
      errorMessage.value = 'Failed to load Bangla Versions';
    } finally {
      isLoading.value = false;
    }
  }

  void toggleBanglaVersion(String id) {
    if (selectedBanglaVersionIds.contains(id)) {
      selectedBanglaVersionIds.remove(id);
    } else {
      selectedBanglaVersionIds.add(id);
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadBanglaVersion();
  }
}