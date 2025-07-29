import 'package:edex_365_getx/features/authentication/user_details/model/user_details_response_model.dart';
import 'package:edex_365_getx/features/authentication/user_details/user_details_service.dart';
import 'package:get/get.dart';


class UserDetailsController extends GetxController {
  final UserDetailsService _userDetailsService;

  UserDetailsController(this._userDetailsService);

  var userDetailsList = <UserDetailsResponseModel>[].obs;
  var isLoading = false.obs;
  var error = Rxn<String>();

  Future<void> fetchUserDetails(String userId) async {
    try {
      isLoading.value = true;
      error.value = null;

      final result = await _userDetailsService.getUserDetails(userId);
      userDetailsList.value = result;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
