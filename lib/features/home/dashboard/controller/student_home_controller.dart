import 'package:edex_365_getx/features/authentication/login/model/login_response.dart';
import 'package:edex_365_getx/features/authentication/user_details/model/user_details_response_model.dart';
import 'package:edex_365_getx/features/authentication/user_details/user_details_service.dart';
import 'package:edex_365_getx/features/student_panel/student_problem_list/model/student_problem_list_response_model.dart';
import 'package:edex_365_getx/features/student_panel/student_problem_list/view/student_problem_list_service.dart';
import 'package:edex_365_getx/routes/app_routes.dart';
import 'package:get/get.dart';


class StudentHomeController extends GetxController {
  final StudentProblemService _problemService;
  final UserDetailsService _userDetailsService;
  
  var selectedIndex = 0.obs;
  var auth = Rxn<LoginResponse>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  
  // Problem lists
  var totalProblems = <StudentProblemListResponseModel>[].obs;
  var pendingProblems = <StudentProblemListResponseModel>[].obs;
  var solvedProblems = <StudentProblemListResponseModel>[].obs;
  
  // User details
  var userDetails = <UserDetailsResponseModel>[].obs;
  
  StudentHomeController(this._problemService, this._userDetailsService);
  
  @override
  void onInit() {
    final auth = Get.arguments as LoginResponse?;
    if (auth != null) {
      this.auth.value = auth;
      fetchAllData(auth.id);
    }
    super.onInit();
  }
  
  Future<void> fetchAllData(String userId) async {
    try {
      isLoading.value = true;
      await Future.wait([
        fetchProblems(userId),
        fetchUserDetails(userId),
      ]);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> fetchProblems(String userId) async {
    final results = await Future.wait([
      _problemService.getStudentProblems(userId),
      _problemService.getPendingProblems(userId),
      _problemService.getSolvedProblems(userId),
    ]);
    
    totalProblems.assignAll(results[0]);
    pendingProblems.assignAll(results[1]);
    solvedProblems.assignAll(results[2]);
  }
  
  Future<void> fetchUserDetails(String userId) async {
    userDetails.assignAll(await _userDetailsService.getUserDetails(userId));
  }
  
  void changeTabIndex(int index) {
    selectedIndex.value = index;
    if (index == 0 && auth.value != null) {
      fetchAllData(auth.value!.id);
    }
  }
  
  void logout() {
    Get.offAllNamed(AppRoutes.login);
  }
}