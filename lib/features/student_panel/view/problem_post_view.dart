
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
    // sharedController.fetchSubjectList();
    // sharedController.fetchVersions();
    // sharedController.fetchBanglaClasses();
    // sharedController.fetchEnglishClasses();
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
    // Get the AuthController instance
    final authController = Get.find<AuthController>();
    
    // Prepare the problem post body
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
      userId: authController.userId.value, // Get userId from AuthController
    );

    // Call the post problem API
    postController.postProblem(problemPostBody).then((_) {
      if (postController.errorMessage.value.isEmpty) {
        Get.back(); // Close the problem post screen
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
        title: const Text('Post a Problem'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Describe your problem',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Fill in the details below to get help from the community',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Problem Image Section
              Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Problem Image (Optional)',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.divider,
                              width: 1.5,
                            ),
                          ),
                          child: selectedImage.value == null
                              ? const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 40,
                                      color: AppColors.textSecondary,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Tap to add image',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    selectedImage.value!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                      if (selectedImage.value != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => selectedImage.value = null,
                              child: const Text(
                                'Remove image',
                                style: TextStyle(
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  )),
              const SizedBox(height: 24),

              // Problem Topic
              const Text(
                'Problem Topic*',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter the topic of your problem...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.divider,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) => problemTopic.value = value,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a topic' : null,
              ),
              const SizedBox(height: 16),

              // Problem Description
              const Text(
                'Problem Description*',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Describe your problem in detail...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.divider,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) => problemDescription.value = value,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please describe your problem' : null,
              ),
              const SizedBox(height: 24),

              // Category Selection Header
              const Text(
                'Problem Categories',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select the relevant categories for your problem',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),

              // Subject Dropdown
              Obx(() => _CustomDropdown(
                    value: selectedSubject.value.isEmpty ? null : selectedSubject.value,
                    label: 'Subject*',
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
                    items: sharedController.versionList
                        .map((item) => DropdownMenuItem(
                              value: item.id,
                              child: Text(item.postName),
                            ))
                        .toList(),
                    onChanged: (value) {
                      selectedAcademy.value = value ?? '';
                      // Clear the class selections when version changes
                      selectedEnglish.value = '';
                      selectedBangla.value = '';
                    },
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please select academic version' : null,
                  )),
              const SizedBox(height: 16),

              // Show only one class dropdown based on selected academic version
              Obx(() {
                if (sharedController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                // Find the selected academic version's name for clarity
                final selectedVersion = sharedController.versionList.firstWhereOrNull((v) => v.id == selectedAcademy.value);
                final versionName = selectedVersion != null
                    ? selectedVersion.postName.toLowerCase()
                    : '';
                if (selectedAcademy.value.isEmpty) {
                  return const SizedBox();
                }
                if (versionName == 'english medium' || selectedAcademy.value == '1') {
                  return _CustomDropdown(
                    value: selectedEnglish.value.isEmpty ? null : selectedEnglish.value,
                    label: 'Class (English Version)*',
                    items: sharedController.englishClassList
                        .map((item) => DropdownMenuItem(
                              value: item.id,
                              child: Text(item.className),
                            ))
                        .toList(),
                    onChanged: (value) => selectedEnglish.value = value ?? '',
                    validator: (value) => value == null || value.isEmpty ? 'Please select a class' : null,
                  );
                } else if (versionName == 'general(english version/bangla)' || selectedAcademy.value == '2') {
                  return _CustomDropdown(
                    value: selectedBangla.value.isEmpty ? null : selectedBangla.value,
                    label: 'Class (Bangla Version)*',
                    items: sharedController.banglaClassList
                        .map((item) => DropdownMenuItem(
                              value: item.id,
                              child: Text(item.className),
                            ))
                        .toList(),
                    onChanged: (value) => selectedBangla.value = value ?? '',
                    validator: (value) => value == null || value.isEmpty ? 'Please select a class' : null,
                  );
                }
                return const SizedBox();
              }),
              const SizedBox(height: 32),

              // Submit Button
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: postController.isLoading.value ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: postController.isLoading.value
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Post Problem',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  )),
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
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const _CustomDropdown({
    required this.value,
    required this.label,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.divider,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: AppColors.surface,
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
    );
  }
}
