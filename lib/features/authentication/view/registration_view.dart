import 'dart:io';
import 'package:edex_365_getx/features/authentication/controller/auth_controller.dart';
import 'package:edex_365_getx/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/app_colors.dart';


class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  static void navigate(BuildContext context) {
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
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  final AuthController controller = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  String? selectedRoleId;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        return Stack(
          children: [
            // Background Decoration
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      
                      // Header
                      Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/edu_logo.png',
                              height: 70,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Join our learning community',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Personal Info Section
                      _buildSectionHeader('Personal Information'),
                      _buildTextField(
                        'Full Name',
                        controller.nameController,
                        icon: Icons.person_outline,
                        validator: (value) => value?.isEmpty ?? true ? 'Please enter your name' : null,
                      ),
                      _buildTextField(
                        'Mobile Number',
                        controller.mobileController,
                        icon: Icons.phone_android,
                        keyboard: TextInputType.phone,
                        validator: (value) {
                          if (value?.isEmpty ?? true) return 'Please enter mobile number';
                          if (value!.length != 10) return 'Mobile number must be 10 digits';
                          return null;
                        },
                      ),
                      _buildTextField(
                        'Email Address',
                        controller.emailController,
                        icon: Icons.email_outlined,
                        keyboard: TextInputType.emailAddress,
                        validator: (value) {
                          if (value?.isEmpty ?? true) return 'Please enter email';
                          if (!value!.contains('@')) return 'Please enter a valid email';
                          return null;
                        },
                      ),
                      _buildTextField(
                        'Password',
                        controller.passwordController,
                        icon: Icons.lock_outline,
                        isObscure: true,
                        validator: (value) {
                          if (value?.isEmpty ?? true) return 'Please enter password';
                          if (value!.length < 6) return 'Password must be at least 6 characters';
                          return null;
                        },
                      ),
                      _buildDOBField(),
                      const SizedBox(height: 24),
                      
                      // Documents Section
                      _buildSectionHeader('Documents'),
                      _buildFilePicker(
                        label: 'Profile Photo',
                        file: controller.image.value,
                        onTap: controller.pickImage,
                        isRequired: true,
                        icon: Icons.camera_alt,
                      ),
                      _buildFilePicker(
                        label: 'CV (Optional)',
                        file: controller.cv.value,
                        onTap: controller.pickCV,
                        isRequired: false,
                        icon: Icons.description,
                      ),
                      _buildFilePicker(
                        label: 'Academic Certificate (Optional)',
                        file: controller.academicImage.value,
                        onTap: controller.pickAcademicImage,
                        isRequired: false,
                        icon: Icons.school,
                      ),
                      const SizedBox(height: 24),
                      
                      // Subjects Section
                      _buildSectionHeader('Subjects'),
                      _buildSubjects(),
                      const SizedBox(height: 24),
                      
                      // Role Selection (Single Select)
                      _buildSectionHeader('Select Your Role'),
                      _buildRoleSelection(),
                      const SizedBox(height: 30),
                      
                      // Submit Button
                      controller.isLoading.value
                          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    if (controller.image.value == null) {
                                      Get.snackbar('Error', 'Profile image is required');
                                      return;
                                    }
                                    if (selectedRoleId == null) {
                                      Get.snackbar('Error', 'Please select a role');
                                      return;
                                    }
                                    controller.submit();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  "Create Account",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 16),
                      
                      // Error Message
                      if (controller.errorMessage.isNotEmpty)
                        Center(
                          child: Text(
                            controller.errorMessage.value,
                            style: TextStyle(
                              color: AppColors.error,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      
                      // Login Link
                      Center(
                        child: GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.login),
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(color: AppColors.textSecondary),
                              children: [
                                TextSpan(
                                  text: "Login",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    IconData? icon,
    TextInputType keyboard = TextInputType.text,
    bool isObscure = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure && !this.controller.showPassword.value,
        keyboardType: keyboard,
        style: TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: AppColors.textSecondary),
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          prefixIcon: icon != null ? Icon(icon, color: AppColors.primary) : null,
          suffixIcon: isObscure
              ? Obx(() => IconButton(
                    icon: Icon(
                      this.controller.showPassword.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () => this.controller.showPassword.toggle(),
                  ))
              : null,
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildFilePicker({
    required String label,
    required File? file,
    required VoidCallback onTap,
    required bool isRequired,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
              if (isRequired) const Text(' *', style: TextStyle(color: Colors.red)),
            ],
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(icon, color: AppColors.primary),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      file != null ? file.path.split('/').last : 'Tap to select file',
                      style: TextStyle(
                        color: file != null ? AppColors.textPrimary : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  if (file != null) Icon(Icons.check_circle, color: AppColors.success),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDOBField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: controller.pickDOB,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: AppColors.primary),
              const SizedBox(width: 16),
              Obx(() => Text(
                    controller.dob.value != null
                        ? DateFormat('MMMM dd, yyyy').format(controller.dob.value!)
                        : 'Select Date of Birth',
                    style: TextStyle(
                      color: controller.dob.value != null 
                          ? AppColors.textPrimary 
                          : AppColors.textSecondary,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjects() {
    return Obx(() {
      final subjects = controller.subjectController.subjectList;
      final selected = controller.subjectController.selectedSubjectIds;

      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: subjects.map((subject) {
          final isSelected = selected.contains(subject.id);
          return ChoiceChip(
            label: Text(subject.subjectName),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                controller.subjectController.selectedSubjectIds.add(subject.id);
              } else {
                controller.subjectController.selectedSubjectIds.remove(subject.id);
              }
            },
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.surface,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppColors.textPrimary,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildRoleSelection() {
    return Obx(() {
      final roles = controller.roleController.userRoleList;
      
      return Column(
        children: roles.map((role) {
          final isSelected = selectedRoleId == role.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedRoleId = role.id;
                  controller.roleController.selectedRoleIds.value = [role.id];
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppColors.primary.withOpacity(0.1) 
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected 
                        ? AppColors.primary 
                        : AppColors.divider,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      role.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}

