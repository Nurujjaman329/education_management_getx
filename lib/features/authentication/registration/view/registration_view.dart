import 'dart:io';
import 'package:edex_365_getx/features/shared_panel/roles/controller/user_roles_controller.dart';
import 'package:edex_365_getx/features/shared_panel/subject/controller/subject_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edex_365_getx/features/authentication/registration/controller/registration_controller.dart';
import '../../../../core/config/app_colors.dart';

import 'package:edex_365_getx/features/authentication/login/view/login_view.dart';


class RegistrationView extends StatelessWidget {
  RegistrationView({super.key});
  final RegistrationController controller = Get.find<RegistrationController>();

  /// Use this static method to navigate to RegistrationView with controller setup
  static void navigate(BuildContext context) {
    if (!Get.isRegistered<SubjectController>()) {
      Get.put(SubjectController());
    }
    if (!Get.isRegistered<UserRolesController>()) {
      Get.put(UserRolesController());
    }
    if (!Get.isRegistered<RegistrationController>()) {
      Get.put(RegistrationController());
    }
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => RegistrationView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildTextField('Name', controller.nameController),
              _buildTextField('Mobile No', controller.mobileController, keyboard: TextInputType.phone),
              _buildTextField('Email', controller.emailController, keyboard: TextInputType.emailAddress),
              _buildTextField('Password', controller.passwordController, isObscure: true),
              _buildDOBField(),

              const SizedBox(height: 20),
              _buildFilePicker(
                label: 'Select Profile Image',
                file: controller.image.value,
                onTap: controller.pickImage,
              ),
              _buildFilePicker(
                label: 'Upload CV',
                file: controller.cv.value,
                onTap: controller.pickCV,
              ),
              _buildFilePicker(
                label: 'Upload Academic Image',
                file: controller.academicImage.value,
                onTap: controller.pickAcademicImage,
              ),

              _buildSubjects(),
              _buildRoles(),

              const SizedBox(height: 30),
              controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Register", style: TextStyle(fontSize: 16)),
                      ),
                    ),

              if (controller.errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => LoginView(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;
                            final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: const Text("Login"),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

Widget _buildTextField(
  String label,
  TextEditingController controller, {
  TextInputType keyboard = TextInputType.text,
  bool isObscure = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: TextField(
      controller: controller,
      obscureText: isObscure && !this.controller.showPassword.value,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: isObscure
            ? Obx(() => IconButton(
                  icon: Icon(
                    this.controller.showPassword.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    this.controller.showPassword.toggle();
                  },
                ))
            : null,
      ),
    ),
  );
}


  Widget _buildDOBField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () => controller.pickDOB(),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Date of Birth',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Obx(() => Text(
  controller.dob.value != null
      ? controller.dob.value!.toLocal().toString().split(' ')[0]
      : 'Tap to select date',
  style: const TextStyle(color: AppColors.textPrimary),
)
),
        ),
      ),
    );
  }

  Widget _buildFilePicker({
    required String label,
    required File? file,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.upload_file),
            label: Text(label),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              file != null ? file.path.split('/').last : 'No file selected',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjects() {
    return Obx(() {
      final subjects = controller.subjectController.subjects;
      final selected = controller.subjectController.selectedSubjectIds;

      return _buildMultiSelect(
        label: 'Select Subjects',
        items: subjects.map((s) => {'id': s.id, 'label': s.subjectName}).toList(),
        selectedIds: selected,
        onToggle: controller.subjectController.toggleSubject,
      );
    });
  }

  Widget _buildRoles() {
    return Obx(() {
      final roles = controller.roleController.roles;
      final selected = controller.roleController.selectedRoleIds;

      return _buildMultiSelect(
        label: 'Select Roles',
        items: roles.map((r) => {'id': r.id, 'label': r.name}).toList(),
        selectedIds: selected,
        onToggle: controller.roleController.toggleSubject,
      );
    });
  }

  Widget _buildMultiSelect({
    required String label,
    required List<Map<String, String>> items,
    required RxList<String> selectedIds,
    required Function(String id) onToggle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 10,
            children: items.map((item) {
              final id = item['id']!;
              final name = item['label']!;
              final isSelected = selectedIds.contains(id);
              return FilterChip(
                label: Text(name),
                selected: isSelected,
                selectedColor: AppColors.secondary.withOpacity(0.7),
                checkmarkColor: Colors.white,
                onSelected: (_) => onToggle(id),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

