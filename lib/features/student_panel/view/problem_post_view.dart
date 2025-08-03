
import 'dart:io';

import 'package:edex_365_getx/core/config/app_colors.dart';
import 'package:edex_365_getx/features/authentication/controller/auth_controller.dart';
import 'package:edex_365_getx/features/shared_panel/controller/shared_controller.dart';
import 'package:edex_365_getx/features/student_panel/controller/student_problem_post_controller.dart';
import 'package:edex_365_getx/features/student_panel/model/parameter_body/problem_post_body.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProblemPostView extends StatelessWidget {
  ProblemPostView({super.key}) {
    final SharedController sharedController = Get.find<SharedController>();
    sharedController.fetchInitialData();
  }

  final SharedController sharedController = Get.find<SharedController>();
  final StudentProblemPostController postController = Get.put(StudentProblemPostController());
  final AuthController authController = Get.find<AuthController>();

  final _formKey = GlobalKey<FormState>();
  final RxString selectedSubject = ''.obs;
  final RxString selectedAcademy = ''.obs;
  final RxString selectedBangla = ''.obs;
  final RxString selectedEnglish = ''.obs;
  final RxString problemDescription = ''.obs;
  final RxString problemTopic = ''.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final authController = Get.find<AuthController>();
      
      final problemPostBody = ProblemPostBody(
        postTypeId: [selectedAcademy.value],
        subject: [selectedSubject.value],
        topic: problemTopic.value,
        sClass: [
          if (selectedAcademy.value == '1') selectedEnglish.value,
          if (selectedAcademy.value == '2') selectedBangla.value,
        ],
        description: problemDescription.value,
        photo: selectedImage.value,
        userId: authController.userId.value,
      );

      postController.postProblem(problemPostBody).then((_) {
        if (postController.errorMessage.value.isEmpty) {
          Get.back();
          Get.snackbar(
            'Success',
            'Problem posted successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.success,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            postController.errorMessage.value,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.error,
            colorText: Colors.white,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Post Your Problem'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Need Help With a Problem?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Fill in the details below to get help from our community',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Problem Image Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Problem Image (Optional)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Obx(() => Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selectedImage.value == null 
                              ? AppColors.divider 
                              : Colors.transparent,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: selectedImage.value == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 48,
                                  color: AppColors.textSecondary,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Tap to upload an image',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            )
                          : Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.file(
                                    selectedImage.value!,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () => selectedImage.value = null,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    )),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Problem Topic
              const Text(
                'Problem Topic*',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'E.g. Quadratic Equations, Newton\'s Laws...',
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: const TextStyle(color: AppColors.textPrimary),
                onChanged: (value) => problemTopic.value = value,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a topic' : null,
              ),
              const SizedBox(height: 20),

              // Problem Description
              const Text(
                'Problem Description*',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Describe your problem in detail...',
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: const TextStyle(color: AppColors.textPrimary),
                onChanged: (value) => problemDescription.value = value,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please describe your problem' : null,
              ),
              const SizedBox(height: 28),

              // Category Selection Header
              const Text(
                'Problem Categories',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Select the relevant categories for your problem',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),

              // Subject Dropdown
              Obx(() => _CustomDropdown(
                    value: selectedSubject.value.isEmpty ? null : selectedSubject.value,
                    label: 'Subject*',
                    hint: 'Select subject',
                    items: sharedController.subjectList
                        .map((subject) => DropdownMenuItem(
                              value: subject.id,
                              child: Text(subject.subjectName),
                            ))
                        .toList(),
                    onChanged: (value) => selectedSubject.value = value ?? '',
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please select a subject' : null,
                  )),
              const SizedBox(height: 16),

              // Academic Version Dropdown
              Obx(() => _CustomDropdown(
                    value: selectedAcademy.value.isEmpty ? null : selectedAcademy.value,
                    label: 'Academic Version*',
                    hint: 'Select version',
                    items: sharedController.versionList
                        .map((item) => DropdownMenuItem(
                              value: item.id,
                              child: Text(item.postName),
                            ))
                        .toList(),
                    onChanged: (value) {
                      selectedAcademy.value = value ?? '';
                      selectedEnglish.value = '';
                      selectedBangla.value = '';
                    },
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please select academic version' : null,
                  )),
              const SizedBox(height: 16),

              // Class Dropdown (Conditional)
              Obx(() {
                if (sharedController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final selectedVersion = sharedController.versionList
                    .firstWhereOrNull((v) => v.id == selectedAcademy.value);
                final versionName = selectedVersion?.postName.toLowerCase() ?? '';
                
                if (selectedAcademy.value.isEmpty) return const SizedBox();
                
                if (versionName.contains('english') || selectedAcademy.value == '1') {
                  return _CustomDropdown(
                    value: selectedEnglish.value.isEmpty ? null : selectedEnglish.value,
                    label: 'Class (English Version)*',
                    hint: 'Select class',
                    items: sharedController.englishClassList
                        .map((item) => DropdownMenuItem(
                              value: item.id,
                              child: Text(item.className),
                            ))
                        .toList(),
                    onChanged: (value) => selectedEnglish.value = value ?? '',
                    validator: (value) => 
                        value == null || value.isEmpty ? 'Please select a class' : null,
                  );
                } else {
                  return _CustomDropdown(
                    value: selectedBangla.value.isEmpty ? null : selectedBangla.value,
                    label: 'Class (Bangla Version)*',
                    hint: 'Select class',
                    items: sharedController.banglaClassList
                        .map((item) => DropdownMenuItem(
                              value: item.id,
                              child: Text(item.className),
                            ))
                        .toList(),
                    onChanged: (value) => selectedBangla.value = value ?? '',
                    validator: (value) => 
                        value == null || value.isEmpty ? 'Please select a class' : null,
                  );
                }
              }),
              const SizedBox(height: 40),

              // Submit Button
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: postController.isLoading.value ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: postController.isLoading.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Post Problem',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomDropdown extends StatelessWidget {
  final String? value;
  final String label;
  final String hint;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const _CustomDropdown({
    required this.value,
    required this.label,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          dropdownColor: AppColors.surface,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: AppColors.textSecondary,
          ),
          items: items,
          onChanged: onChanged,
          validator: validator,
          style: const TextStyle(
            color: AppColors.textPrimary,
          ),
          isExpanded: true,
        ),
      ],
    );
  }
}
