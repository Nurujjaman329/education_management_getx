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
  final StudentProblemPostController postController =
      Get.put(StudentProblemPostController());
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
        title: const Text('Post Problem'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 16),

              // Image Picker
              Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Image (Optional)',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: selectedImage.value == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt,
                                      size: 32,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Tap to add photo',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
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
                        TextButton(
                          onPressed: () => selectedImage.value = null,
                          child: const Text('Remove'),
                        ),
                    ],
                  )),

              const SizedBox(height: 24),

              // Problem Topic
              Text(
                'Problem Title',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'What is your problem about?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                onChanged: (value) => problemTopic.value = value,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a title'
                    : null,
              ),
              const SizedBox(height: 16),

              // Problem Description
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Explain your problem in detail...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                onChanged: (value) => problemDescription.value = value,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please describe your problem'
                    : null,
              ),
              const SizedBox(height: 24),

              // Category Section
              Text(
                'Categories',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 12),

              // Subject Dropdown
              Obx(() => _CustomDropdown(
                    value: selectedSubject.value.isEmpty
                        ? null
                        : selectedSubject.value,
                    hint: 'Select Subject',
                    items: sharedController.subjectList
                        .map((subject) => DropdownMenuItem(
                              value: subject.id,
                              child: Text(subject.subjectName),
                            ))
                        .toList(),
                    onChanged: (value) => selectedSubject.value = value ?? '',
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please select a subject'
                        : null,
                  )),
              const SizedBox(height: 16),

              // Academic Version Dropdown
              Obx(() => _CustomDropdown(
                    value: selectedAcademy.value.isEmpty
                        ? null
                        : selectedAcademy.value,
                    hint: 'Academic Version',
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
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please select version'
                        : null,
                  )),
              const SizedBox(height: 16),

              // Class Dropdown (conditional)
              Obx(() {
                if (sharedController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final selectedVersion = sharedController.versionList
                    .firstWhereOrNull((v) => v.id == selectedAcademy.value);
                final versionName =
                    selectedVersion?.postName.toLowerCase() ?? '';

                if (selectedAcademy.value.isEmpty) return const SizedBox();

                if (versionName == 'english medium' ||
                    selectedAcademy.value == '1') {
                  return _CustomDropdown(
                    value: selectedEnglish.value.isEmpty
                        ? null
                        : selectedEnglish.value,
                    hint: 'Select Class',
                    items: sharedController.englishClassList
                        .map((item) => DropdownMenuItem(
                              value: item.id,
                              child: Text(item.className),
                            ))
                        .toList(),
                    onChanged: (value) => selectedEnglish.value = value ?? '',
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please select class'
                        : null,
                  );
                } else if (versionName == 'general(english version/bangla)' ||
                    selectedAcademy.value == '2') {
                  return _CustomDropdown(
                    value: selectedBangla.value.isEmpty
                        ? null
                        : selectedBangla.value,
                    hint: 'Select Class',
                    items: sharedController.banglaClassList
                        .map((item) => DropdownMenuItem(
                              value: item.id,
                              child: Text(item.className),
                            ))
                        .toList(),
                    onChanged: (value) => selectedBangla.value = value ?? '',
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please select class'
                        : null,
                  );
                }
                return const SizedBox();
              }),
              const SizedBox(height: 32),

              // Submit Button
              Obx(() => SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      
                      onPressed:
                          postController.isLoading.value ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: postController.isLoading.value
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Post',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.background,
                              ),
                            ),
                    ),
                  )),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomDropdown extends StatelessWidget {
  final String? value;
  final String hint;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const _CustomDropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      dropdownColor: Colors.white,
      icon: const Icon(Icons.keyboard_arrow_down),
      items: items,
      onChanged: onChanged,
      validator: validator,
      style: Theme.of(context).textTheme.bodyMedium,
      isExpanded: true,
    );
  }
}
