import 'dart:io';
import 'package:edex_365_getx/features/authentication/controller/auth_controller.dart';
import 'package:edex_365_getx/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  static void navigate(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const RegistrationView(),
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
  bool isTeacher = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Obx(() {
        return Stack(
          children: [
            // Background Decoration with improved gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      theme.colorScheme.surface.withOpacity(0.05),
                      theme.colorScheme.surface.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
            
            // Floating bubbles decoration
            Positioned(
              top: 100,
              right: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              left: -30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            
            SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        
                        // Header with improved design
                        Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Join our learning community',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: theme.textTheme.bodyMedium?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Personal Info Section with improved cards
                        _buildSectionHeader('Personal Information', Icons.person, theme),
                        _buildTextFieldCard(
                          'Full Name',
                          controller.nameController,
                          icon: Icons.person_outline,
                          validator: (value) => value?.isEmpty ?? true ? 'Please enter your name' : null,
                          theme: theme,
                        ),
                        _buildTextFieldCard(
                          'Mobile Number',
                          controller.mobileController,
                          icon: Icons.phone_android,
                          keyboard: TextInputType.phone,
                          validator: (value) {
                            if (value?.isEmpty ?? true) return 'Please enter mobile number';
                            if (value!.length != 10) return 'Mobile number must be 10 digits';
                            return null;
                          },
                          theme: theme,
                        ),
                        _buildTextFieldCard(
                          'Email Address',
                          controller.emailController,
                          icon: Icons.email_outlined,
                          keyboard: TextInputType.emailAddress,
                          validator: (value) {
                            if (value?.isEmpty ?? true) return 'Please enter email';
                            if (!value!.contains('@')) return 'Please enter a valid email';
                            return null;
                          },
                          theme: theme,
                        ),
                        _buildTextFieldCard(
                          'Password',
                          controller.passwordController,
                          icon: Icons.lock_outline,
                          isObscure: true,
                          validator: (value) {
                            if (value?.isEmpty ?? true) return 'Please enter password';
                            if (value!.length < 6) return 'Password must be at least 6 characters';
                            return null;
                          },
                          theme: theme,
                        ),
                        _buildDOBField(theme),
                        const SizedBox(height: 24),
                        
                        // Role Selection (Single Select) moved up
                        _buildSectionHeader('Select Your Role', Icons.school, theme),
                        _buildRoleSelection(theme),
                        const SizedBox(height: 24),
                        
                        // Only show documents section if teacher is selected
                        if (isTeacher) ...[
                          _buildSectionHeader('Professional Documents', Icons.folder, theme),
                          _buildFilePickerCard(
                            label: 'Profile Photo',
                            file: controller.image.value,
                            onTap: controller.pickImage,
                            isRequired: true,
                            icon: Icons.camera_alt,
                            theme: theme,
                          ),
                          _buildFilePickerCard(
                            label: 'CV (Required for Teachers)',
                            file: controller.cv.value,
                            onTap: controller.pickCV,
                            isRequired: true,
                            icon: Icons.description,
                            theme: theme,
                          ),
                          _buildFilePickerCard(
                            label: 'Academic Certificates',
                            file: controller.academicImage.value,
                            onTap: controller.pickAcademicImage,
                            isRequired: true,
                            icon: Icons.school,
                            theme: theme,
                          ),
                          const SizedBox(height: 24),
                        ] else ...[
                          // For students, only show profile photo
                          _buildSectionHeader('Profile Photo', Icons.camera_alt, theme),
                          _buildFilePickerCard(
                            label: 'Profile Photo',
                            file: controller.image.value,
                            onTap: controller.pickImage,
                            isRequired: true,
                            icon: Icons.camera_alt,
                            theme: theme,
                          ),
                          const SizedBox(height: 24),
                        ],
                        
                        // Subjects Section
                        _buildSectionHeader('Subjects of Interest', Icons.subject, theme),
                        _buildSubjects(theme),
                        const SizedBox(height: 30),
                        
                        // Submit Button with improved design
                        controller.isLoading.value
                            ? Center(child: CircularProgressIndicator(color: theme.colorScheme.primary))
                            : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ?? false) {
                                      if (controller.image.value == null) {
                                        Get.snackbar(
                                          'Profile Image Required',
                                          'Please upload your profile photo',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: theme.colorScheme.error,
                                          colorText: theme.colorScheme.onError,
                                        );
                                        return;
                                      }
                                      if (isTeacher && controller.cv.value == null) {
                                        Get.snackbar(
                                          'CV Required',
                                          'Please upload your CV',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: theme.colorScheme.error,
                                          colorText: theme.colorScheme.onError,
                                        );
                                        return;
                                      }
                                      if (selectedRoleId == null) {
                                        Get.snackbar(
                                          'Role Required',
                                          'Please select your role',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: theme.colorScheme.error,
                                          colorText: theme.colorScheme.onError,
                                        );
                                        return;
                                      }
                                      controller.submit();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.colorScheme.primary,
                                    padding: const EdgeInsets.symmetric(vertical: 18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                    shadowColor: theme.colorScheme.primary.withOpacity(0.3),
                                  ),
                                  child: Text(
                                    "Create Account",
                                    style: TextStyle(
                                      color: theme.colorScheme.onPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 16),
                        
                        // Error Message with improved visibility
                        if (controller.errorMessage.isNotEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              controller.errorMessage.value,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: theme.colorScheme.error,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),
                        
                        // Login Link with improved design
                        Center(
                          child: GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.login),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: RichText(
                                text: TextSpan(
                                  text: "Already have an account? ",
                                  style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                                  children: [
                                    TextSpan(
                                      text: "Login",
                                      style: TextStyle(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
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
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldCard(
    String label,
    TextEditingController controller, {
    IconData? icon,
    TextInputType keyboard = TextInputType.text,
    bool isObscure = false,
    String? Function(String?)? validator,
    required ThemeData theme,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.dividerColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextFormField(
          controller: controller,
          obscureText: isObscure && !this.controller.showPassword.value,
          keyboardType: keyboard,
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
            border: InputBorder.none,
            prefixIcon: icon != null ? Icon(icon, color: theme.colorScheme.primary) : null,
            suffixIcon: isObscure
                ? Obx(() => IconButton(
                      icon: Icon(
                        this.controller.showPassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                      onPressed: () => this.controller.showPassword.toggle(),
                    ))
                : null,
          ),
          validator: validator,
        ),
      ),
    );
  }

  Widget _buildFilePickerCard({
    required String label,
    required File? file,
    required VoidCallback onTap,
    required bool isRequired,
    required IconData icon,
    required ThemeData theme,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.dividerColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  if (isRequired) 
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        '*',
                        style: TextStyle(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        file != null 
                            ? file.path.split('/').last 
                            : 'Tap to select file',
                        style: TextStyle(
                          color: file != null 
                              ? theme.textTheme.bodyLarge?.color 
                              : theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                    if (file != null) 
                      Icon(Icons.check_circle, color: theme.colorScheme.primary),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDOBField(ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.dividerColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: controller.pickDOB,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: theme.colorScheme.primary),
              const SizedBox(width: 16),
              Obx(() => Text(
                    controller.dob.value != null
                        ? DateFormat('MMMM dd, yyyy').format(controller.dob.value!)
                        : 'Select Date of Birth',
                    style: TextStyle(
                      color: controller.dob.value != null 
                          ? theme.textTheme.bodyLarge?.color 
                          : theme.textTheme.bodyMedium?.color,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjects(ThemeData theme) {
    return Obx(() {
      final subjects = controller.subjectController.subjectList;
      final selected = controller.subjectController.selectedSubjectIds;

      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: subjects.map((subject) {
          final isSelected = selected.contains(subject.id);
          return FilterChip(
            label: Text(subject.subjectName),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                controller.subjectController.selectedSubjectIds.add(subject.id);
              } else {
                controller.subjectController.selectedSubjectIds.remove(subject.id);
              }
            },
            selectedColor: theme.colorScheme.primary.withOpacity(0.2),
            backgroundColor: theme.cardColor,
            labelStyle: TextStyle(
              color: isSelected ? theme.colorScheme.primary : theme.textTheme.bodyLarge?.color,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: isSelected 
                    ? theme.colorScheme.primary 
                    : theme.dividerColor,
              ),
            ),
            checkmarkColor: theme.colorScheme.primary,
            showCheckmark: true,
          );
        }).toList(),
      );
    });
  }

  Widget _buildRoleSelection(ThemeData theme) {
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
                  isTeacher = role.name.toLowerCase().contains('teacher');
                  controller.roleController.selectedRoleIds.value = [role.id];
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? theme.colorScheme.primary.withOpacity(0.1) 
                      : theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected 
                        ? theme.colorScheme.primary 
                        : theme.dividerColor,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? theme.colorScheme.primary : theme.textTheme.bodyMedium?.color ?? Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? Icon(Icons.check, size: 14, color: theme.colorScheme.onPrimary)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            role.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.bodyLarge?.color,
                              fontSize: 16,
                            ),
                          ),
                          ...[
                          const SizedBox(height: 4),
                          Text(
                            role.name,
                            style: TextStyle(
                              color: theme.textTheme.bodyMedium?.color,
                              fontSize: 12,
                            ),
                          ),
                        ],
                        ],
                      ),
                    ),
                    Icon(
                      role.name.toLowerCase().contains('teacher')
                          ? Icons.school
                          : Icons.school_outlined,
                      color: isSelected ? theme.colorScheme.primary : theme.textTheme.bodyMedium?.color,
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

