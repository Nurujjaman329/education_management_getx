import 'package:edex_365_getx/features/authentication/update_user_info/model/update_user_info_response_model.dart';
import 'package:edex_365_getx/features/authentication/update_user_info/update_user_info_service.dart';
import 'package:get/get.dart';

class UpdateUserInfoController extends GetxController {
  final UpdateUserInfoService _service;

  UpdateUserInfoController(this._service);

  RxBool isLoading = false.obs;
  Rxn<UpdateUserInfoResponseModel> updatedUser = Rxn();
  RxnString error = RxnString();

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
}
