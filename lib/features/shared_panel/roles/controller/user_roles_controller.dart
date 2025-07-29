import 'package:edex_365_getx/features/shared_panel/roles/model/user_roles_response_model.dart';
import 'package:edex_365_getx/features/shared_panel/roles/roles_service.dart';
import 'package:get/get.dart';

class UserRolesController extends GetxController {
  final RoleService _service = RoleService();

  var roles = <UserRolesResponseModel>[].obs;
  var selectedRoleIds = <String>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> loadRoles() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedRoles = await _service.fetchRoles();
      roles.assignAll(fetchedRoles);
    } catch (e) {
      errorMessage.value = 'Failed to load roles';
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSubject(String id) {
    if (selectedRoleIds.contains(id)) {
      selectedRoleIds.remove(id);
    } else {
      selectedRoleIds.add(id);
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadRoles();
  }
}
