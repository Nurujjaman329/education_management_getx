import 'dart:io';

import 'package:edex_365_getx/core/config/app_colors.dart';
import 'package:edex_365_getx/features/shared_panel/academy_version_list/controller/academy_version_list_controller.dart';
import 'package:edex_365_getx/features/shared_panel/all_bangla_version_class/controller/all_bangla_version_class_controller.dart';
import 'package:edex_365_getx/features/shared_panel/all_english_version_class/controller/all_english_version_class_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edex_365_getx/features/shared_panel/subject/controller/subject_controller.dart';
import 'package:image_picker/image_picker.dart';

class ProblemPostView extends StatelessWidget {
  ProblemPostView({super.key});

  final SubjectController subjectController = Get.find<SubjectController>();
  final AcademyVersionListController academyController = Get.find<AcademyVersionListController>();
  final AllBanglaVersionClassController banglaController = Get.find<AllBanglaVersionClassController>();
  final AllEnglishVersionClassController englishController = Get.find<AllEnglishVersionClassController>();

  final _formKey = GlobalKey<FormState>();
  final RxString selectedSubject = ''.obs;
  final RxString selectedAcademy = ''.obs;
  final RxString selectedBangla = ''.obs;
  final RxString selectedEnglish = ''.obs;
  final RxString problemDescription = ''.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle submission logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Problem posted successfully!'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: AppColors.success,
        ),
      );
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
              Text(
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
                      Text(
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
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 40,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(height: 8),
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
                              child: Text(
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

              // Problem Description
              Text(
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
                    borderSide: BorderSide(
                      color: AppColors.divider,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
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
              Text(
                'Problem Categories',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
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
                    items: subjectController.subjects
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
                    items: academyController.subjects
                        .map((item) => DropdownMenuItem(
                              value: item.id,
                              child: Text(item.postName),
                            ))
                        .toList(),
                    onChanged: (value) => selectedAcademy.value = value ?? '',
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please select academic version' : null,
                  )),
              const SizedBox(height: 16),

              // Bangla Version Dropdown
              Obx(() => _CustomDropdown(
                    value: selectedBangla.value.isEmpty ? null : selectedBangla.value,
                    label: 'Bangla Version*',
                    items: banglaController.banglaClass
                        .map((item) => DropdownMenuItem(
                              value: item.id,
                              child: Text(item.className),
                            ))
                        .toList(),
                    onChanged: (value) => selectedBangla.value = value ?? '',
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please select Bangla version' : null,
                  )),
              const SizedBox(height: 16),

              // English Version Dropdown
              Obx(() => _CustomDropdown(
                    value: selectedEnglish.value.isEmpty ? null : selectedEnglish.value,
                    label: 'English Version*',
                    items: englishController.englishVersions
                        .map((item) => DropdownMenuItem(
                              value: item.id,
                              child: Text(item.className),
                            ))
                        .toList(),
                    onChanged: (value) => selectedEnglish.value = value ?? '',
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please select English version' : null,
                  )),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _submit(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Post Problem',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
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
        labelStyle: TextStyle(
          color: AppColors.textSecondary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.divider,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: AppColors.surface,
      ),
      dropdownColor: AppColors.surface,
      icon: Icon(
        Icons.arrow_drop_down,
        color: AppColors.textSecondary,
      ),
      items: items,
      onChanged: onChanged,
      validator: validator,
      style: TextStyle(
        color: AppColors.textPrimary,
      ),
    );
  }
}
