import 'dart:io';
import 'package:edex_365_getx/features/shared_panel/roles/controller/user_roles_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../shared_panel/subject/controller/subject_controller.dart';
import '../model/signup_details_body.dart';
import '../model/registration_response_model.dart';
import '../registration_service.dart';


class RegistrationController extends GetxController {
  final RegistrationService _service = RegistrationService();

  // Injected subject and role controllers
  final SubjectController subjectController = Get.find<SubjectController>();
  final UserRolesController roleController = Get.find<UserRolesController>();

  // Form Controllers
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // UI State
  var dob = Rxn<DateTime>();
  var image = Rxn<File>();
  var cv = Rxn<File>();
  var academicImage = Rxn<File>();
  var showPassword = false.obs;

  // Registration State
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var response = Rxn<RegistrationResponseModel>();

  @override
  void onInit() {
    super.onInit();
    subjectController.loadSubjects();
    roleController.loadRoles();
  }

  Future<void> submit() async {
    if (nameController.text.isEmpty ||
        mobileController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        roleController.selectedRoleIds.isEmpty) {
      errorMessage.value = "Please fill all required fields.";
      return;
    }

    final body = SignUpDetailsBody(
      name: nameController.text.trim(),
      mobileNo: mobileController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      dob: dob.value,
      image: image.value,
      cv: cv.value,
      academicImage: academicImage.value,
      subject: subjectController.selectedSubjectIds.toList(),
      role: roleController.selectedRoleIds.toList(),
    );

    await register(body);
  }

  Future<void> register(SignUpDetailsBody body) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await _service.postRegister(body);
      response.value = result;
      Get.snackbar('Success', result.message);
    } catch (e) {
      errorMessage.value = 'Registration failed';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // File pickers
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) image.value = File(picked.path);
  }

  Future<void> pickCV() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) cv.value = File(picked.path);
  }

  Future<void> pickAcademicImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) academicImage.value = File(picked.path);
  }

  Future<void> pickDOB() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime(2000),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    );
    if (picked != null) dob.value = picked;
  }

  @override
  void onClose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

