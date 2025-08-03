import 'dart:io';

import 'package:edex_365_getx/core/config/app_colors.dart';
import 'package:edex_365_getx/core/widgets/custom_curved_appbar.dart';
import 'package:edex_365_getx/features/authentication/controller/auth_controller.dart';
import 'package:edex_365_getx/features/shared_panel/controller/shared_controller.dart';
import 'package:edex_365_getx/features/shared_panel/model/update_user_info_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _schoolController = TextEditingController();
  final _dobController = TextEditingController();
  final _sharedController = Get.find<SharedController>();
  final _authController = Get.find<AuthController>();
  final Rx<File?> _selectedImage = Rx<File?>(null);
  DateTime? _selectedDob;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = _sharedController.userDetailsList.firstOrNull;
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _schoolController.text = user.school;
      if (user.dob != null) {
        _selectedDob = user.dob;
        _dobController.text = DateFormat('dd MMM yyyy').format(user.dob!);
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _selectedImage.value = File(pickedFile.path);
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDob = picked;
        _dobController.text = DateFormat('dd MMM yyyy').format(picked);
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updateBody = UpdateDetailsResponseBody(
        id: _authController.userId.value,
        name: _nameController.text,
        email: _emailController.text,
        password: '', // Password updates handled separately
        dob: _selectedDob,
        school: _schoolController.text,
        image: _selectedImage.value,
      );

      try {
        await _sharedController.updateUser(updateBody);
        Get.back(); // Close the edit view
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.success,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomCurvedAppBar(title: "Edit Profile"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Image Section
              Obx(() {
                final user = _sharedController.userDetailsList.firstOrNull;
                return Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          backgroundImage: _selectedImage.value != null
                              ? FileImage(_selectedImage.value!)
                              : (user?.image.isNotEmpty ?? false)
                                  ? NetworkImage(user!.image)
                                  : null,
                          child: _selectedImage.value == null &&
                                  (user?.image.isEmpty ?? true)
                              ? const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: AppColors.textSecondary,
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tap to change photo',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 24),

              // Form Fields
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: const TextStyle(color: AppColors.textSecondary),
                        prefixIcon: const Icon(Icons.person, color: AppColors.primary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.divider),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.primary),
                        ),
                      ),
                      style: const TextStyle(color: AppColors.textPrimary),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Please enter your name' : null,
                    ),
                    const SizedBox(height: 16),

                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: AppColors.textSecondary),
                        prefixIcon: const Icon(Icons.email, color: AppColors.primary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.divider),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.primary),
                        ),
                      ),
                      style: const TextStyle(color: AppColors.textPrimary),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Please enter your email';
                        if (!value!.contains('@')) return 'Please enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // School Field
                    TextFormField(
                      controller: _schoolController,
                      decoration: InputDecoration(
                        labelText: 'School (Optional)',
                        labelStyle: const TextStyle(color: AppColors.textSecondary),
                        prefixIcon: const Icon(Icons.school, color: AppColors.primary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.divider),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.primary),
                        ),
                      ),
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 16),

                    // Date of Birth Field
                    TextFormField(
                      controller: _dobController,
                      decoration: InputDecoration(
                        labelText: 'Date of Birth (Optional)',
                        labelStyle: const TextStyle(color: AppColors.textSecondary),
                        prefixIcon: const Icon(Icons.calendar_today, color: AppColors.primary),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.edit, color: AppColors.primary),
                          onPressed: _selectDate,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.divider),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.primary),
                        ),
                      ),
                      style: const TextStyle(color: AppColors.textPrimary),
                      readOnly: true,
                      onTap: _selectDate,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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