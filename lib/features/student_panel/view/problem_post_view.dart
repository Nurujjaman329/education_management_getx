
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
     
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildSectionHeader(
                title: "Problem Details",
                subtitle: "Provide information about the problem you're facing",
              ),
              const SizedBox(height: 24),

              // Image Upload
              _buildImageUploadSection(),
              const SizedBox(height: 24),

              // Problem Info Section
              _buildSectionHeader(
                title: "Problem Information",
                subtitle: "Describe what you need help with",
              ),
              const SizedBox(height: 16),
              
              // Topic Field
              _buildTextField(
                label: "Problem Topic*",
                hint: "E.g. Quadratic Equations, Newton's Laws...",
                controller: TextEditingController(text: problemTopic.value),
                onChanged: (value) => problemTopic.value = value,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a topic' : null,
              ),
              const SizedBox(height: 16),
              
              // Description Field
              _buildTextField(
                label: "Problem Description*",
                hint: "Describe your problem in detail...",
                controller: TextEditingController(text: problemDescription.value),
                onChanged: (value) => problemDescription.value = value,
                validator: (value) => value?.isEmpty ?? true ? 'Please describe your problem' : null,
                maxLines: 5,
              ),
              const SizedBox(height: 24),

              // Category Section
              _buildSectionHeader(
                title: "Problem Categories",
                subtitle: "Select relevant categories for your problem",
              ),
              const SizedBox(height: 16),
              
              // Subject Dropdown
              _buildDropdown(
                label: "Subject*",
                value: selectedSubject.value,
                items: sharedController.subjectList
                    .map((s) => DropdownMenuItem(
                          value: s.id,
                          child: Text(s.subjectName),
                        ))
                    .toList(),
                onChanged: (value) => selectedSubject.value = value ?? '',
                validator: (value) => value?.isEmpty ?? true ? 'Please select a subject' : null,
              ),
              const SizedBox(height: 16),
              
              // Version Dropdown
              _buildDropdown(
                label: "Academic Version*",
                value: selectedAcademy.value,
                items: sharedController.versionList
                    .map((v) => DropdownMenuItem(
                          value: v.id,
                          child: Text(v.postName),
                        ))
                    .toList(),
                onChanged: (value) {
                  selectedAcademy.value = value ?? '';
                  selectedEnglish.value = '';
                  selectedBangla.value = '';
                },
                validator: (value) => value?.isEmpty ?? true ? 'Please select version' : null,
              ),
              const SizedBox(height: 16),
              
              // Class Dropdown (Conditional)
              Obx(() {
                if (sharedController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (selectedAcademy.value.isEmpty) return const SizedBox();
                
                final isEnglish = selectedAcademy.value == '1' || 
                    (sharedController.versionList
                        .firstWhereOrNull((v) => v.id == selectedAcademy.value)
                        ?.postName.toLowerCase().contains('english') ?? false);
                
                return _buildDropdown(
                  label: isEnglish ? "Class (English)*" : "Class (Bangla)*",
                  value: isEnglish ? selectedEnglish.value : selectedBangla.value,
                  items: (isEnglish 
                      ? sharedController.englishClassList 
                      : sharedController.banglaClassList)
                      .map((c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.className),
                          ))
                      .toList(),
                  onChanged: (value) => isEnglish 
                      ? selectedEnglish.value = value ?? '' 
                      : selectedBangla.value = value ?? '',
                  validator: (value) => value?.isEmpty ?? true ? 'Please select class' : null,
                );
              }),
              const SizedBox(height: 32),
              
              // Submit Button
              Obx(() => _buildSubmitButton()),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable Widgets

  Widget _buildSectionHeader({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Problem Image (Optional)",
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
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selectedImage.value == null 
                    ? AppColors.divider.withOpacity(0.5)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: selectedImage.value == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 40,
                        color: AppColors.textSecondary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Tap to add image",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
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
                              color: Colors.black.withOpacity(0.6),
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
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    required FormFieldValidator<String> validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          style: TextStyle(color: AppColors.textPrimary),
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
    required FormFieldValidator<String?> validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value.isEmpty ? null : value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          style: TextStyle(color: AppColors.textPrimary),
          dropdownColor: AppColors.surface,
          icon: Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
          isExpanded: true,
          hint: Text(
            "Select ${label.split('*').first.trim()}",
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: postController.isLoading.value ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
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
                "Post Problem",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
