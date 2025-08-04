import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:edex_365_getx/core/error/exceptions.dart';
import 'package:edex_365_getx/features/authentication/model/login_response.dart';
import 'package:edex_365_getx/features/authentication/model/parameter_body/signup_request_body.dart';
import 'package:edex_365_getx/features/authentication/service/auth_service.dart';
import 'package:edex_365_getx/features/authentication/view/otp_verify_view.dart';
import 'package:edex_365_getx/features/shared_panel/controller/shared_controller.dart';
import 'package:edex_365_getx/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';



class AuthController extends GetxController {
  final AuthService _service = AuthService();

  var isLoading = false.obs;
  var loginResponse = Rxn<LoginResponse>();
  var userId = ''.obs;
  var errorMessage = ''.obs;
  var isSuccess = false.obs;
  
  var showPassword = false.obs;
  var dob = Rxn<DateTime>();
  var image = Rxn<File>();
  var cv = Rxn<File>();
  var academicImage = Rxn<File>();
  
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final SharedController subjectController = Get.find<SharedController>();
  final SharedController roleController = Get.find<SharedController>();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    _loadRegistrationData();
  }

    @override
  void onClose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }


    Future<void> _loadRegistrationData() async {
    try {
      // Load both subjects and roles in parallel
      await Future.wait([
        subjectController.fetchSubjectList(),
        roleController.fetchUserRoleList(),
      ]);
    } catch (e) {
      errorMessage.value = 'Failed to load registration data: ${e.toString()}';
      Get.snackbar('Error', errorMessage.value);
    }
  }

Future<void> login(String mobileNo, String password) async {
  try {
    isLoading.value = true;
    const deviceToken = 'static_device_token_123';

    final response = await _service.login(
      mobileNo: mobileNo,
      password: password,
      deviceToken: deviceToken,
    );

    loginResponse.value = response;
    userId.value = response.id;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', response.token);
    await prefs.setString('userType', response.type);
    await prefs.setString('userId', response.id);

    log('Login successful: ${response.token}, ${response.type}');

    final userType = response.type.toLowerCase();

    if (userType == 'student') {
      Get.offAllNamed(AppRoutes.studentHome);
    } else if (userType == 'teacher') {
      Get.offAllNamed(AppRoutes.teacherHome);
    } else {
      Get.snackbar("Error", "Invalid user type");
    }
  } catch (e) {
    log('Login error: $e');

    String errorMessage = "An unexpected error occurred. Please try again.";

    if (e is DioException) {
      final statusCode = e.response?.statusCode;
      final serverMessage = e.response?.data['message'] ?? '';

      if (statusCode == 500) {
        errorMessage = "Server error. Please try again later.";
      } else if (statusCode == 401) {
        errorMessage = serverMessage.isNotEmpty ? serverMessage : "Unauthorized. Check your credentials.";
      } else if (statusCode == 400) {
        errorMessage = serverMessage.isNotEmpty ? serverMessage : "Invalid request data.";
      } else {
        errorMessage = serverMessage.isNotEmpty ? serverMessage : "Something went wrong. Please try again.";
      }
    } else if (e is Exception) {
      // Clean up generic exception message if needed
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    }

    Get.snackbar(
      "Login Failed",
      errorMessage,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  } finally {
    isLoading.value = false;
  }
}


    // Add this method to get userId from shared preferences when app starts
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userId.value = prefs.getString('userId') ?? '';
  }


    Future<void> submit() async {
    try {
      if (image.value == null) {
        errorMessage.value = 'Profile image is required';
        return;
      }

      isLoading.value = true;
      errorMessage.value = '';

      final body = SignUpRequestBody(
        name: nameController.text.trim(),
        mobileNo: mobileController.text.trim(),
        image: image.value,
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        dob: dob.value,
        cv: cv.value,
        academicImage: academicImage.value,
        subject: subjectController.selectedSubjectIds,
        role: roleController.selectedRoleIds,
      );

      final response = await _service.register(body);
      
      // Navigate to OTP verification with mobile number
      Get.offAll(() => OtpVerifyView(
        mobileNo: response.signupDetails?.mobileNo ?? mobileController.text.trim(),
        // userId: response.signupDetails?.id ?? '',
      ));
      
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Registration Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
    }
  }

  Future<void> pickCV() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      cv.value = File(result.files.single.path!);
    }
  }

  Future<void> pickAcademicImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      academicImage.value = File(pickedFile.path);
    }
  }

  Future<void> pickDOB() async {
    final pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
    );
    if (pickedDate != null) {
      dob.value = pickedDate;
    }
  }

Future<void> register(SignUpRequestBody body) async {
  try {
    isLoading.value = true;
    final mobileNo = await _service.register(body);
    Get.to(() => OtpVerifyView(mobileNo: mobileNo.signupDetails!.mobileNo)); // Navigate to OTP screen
  } catch (e) {
    Get.snackbar('Registration Error', e.toString());
  } finally {
    isLoading.value = false;
  }
}

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    loginResponse.value = null;
    Get.offAllNamed(AppRoutes.login);
  }

  Future<bool> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }

    Future<void> verifyOtp(String id, String otp) async {
    isLoading.value = true;
    errorMessage.value = '';
    isSuccess.value = false;

    try {
      final result = await _service.verifyOtp(id, otp);
      if (result.message == "Verifyed Otp..") {
        isSuccess.value = true;
      } else {
        errorMessage.value = result.message;
      }
    } on InputException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = "Unexpected error: ${e.toString()}";
    } finally {
      isLoading.value = false;
    }
  }
}

