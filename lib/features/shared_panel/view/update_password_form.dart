import 'package:edex_365_getx/core/widgets/custom_curved_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edex_365_getx/features/shared_panel/controller/shared_controller.dart';

class UpdatePasswordForm extends StatefulWidget {
  final String userId;
  const UpdatePasswordForm({super.key, required this.userId});

  @override
  State<UpdatePasswordForm> createState() => _UpdatePasswordFormState();
}

class _UpdatePasswordFormState extends State<UpdatePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final oldPassCtrl = TextEditingController();
  final newPassCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();
  final RxBool _showOldPassword = false.obs;
  final RxBool _showNewPassword = false.obs;
  final RxBool _showConfirmPassword = false.obs;

  @override
  void dispose() {
    oldPassCtrl.dispose();
    newPassCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  final controller = Get.find<SharedController>();
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final textTheme = theme.textTheme;

  return Scaffold(
    backgroundColor: theme.scaffoldBackgroundColor,
    appBar: const CustomCurvedAppBar(title: "Change Password"),
    body: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Obx(() {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Header
              Text(
                'Update Your Password',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create a strong and secure password',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 32),

              // Old Password Field
              Text(
                'Current Password',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => TextFormField(
                controller: oldPassCtrl,
                obscureText: !_showOldPassword.value,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showOldPassword.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    onPressed: () {
                      _showOldPassword.toggle();
                    },
                  ),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter your current password' : null,
              )),
              const SizedBox(height: 20),

              // New Password Field
              Text(
                'New Password',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => TextFormField(
                controller: newPassCtrl,
                obscureText: !_showNewPassword.value,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showNewPassword.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    onPressed: () {
                      _showNewPassword.toggle();
                    },
                  ),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter a new password' : null,
              )),
              const SizedBox(height: 20),

              // Confirm Password Field
              Text(
                'Confirm New Password',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => TextFormField(
                controller: confirmPassCtrl,
                obscureText: !_showConfirmPassword.value,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showConfirmPassword.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    onPressed: () {
                      _showConfirmPassword.toggle();
                    },
                  ),
                ),
                validator: (val) =>
                    val != newPassCtrl.text ? 'Passwords do not match' : null,
              )),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await controller.updatePassword(
                        userId: widget.userId,
                        oldPassword: oldPassCtrl.text.trim(),
                        newPassword: newPassCtrl.text.trim(),
                      );

                      if (controller.successMessage.isNotEmpty) {
                        Get.snackbar(
                          "Success",
                          controller.successMessage.value,
                          colorText: colorScheme.onSecondary,
                          backgroundColor: colorScheme.secondary,
                        );
                      } else if (controller.errorMessage.isNotEmpty) {
                        Get.snackbar(
                          "Error",
                          controller.errorMessage.value,
                          colorText: colorScheme.onError,
                          backgroundColor: colorScheme.error,
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isLoading.value
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: colorScheme.onPrimary,
                          ),
                        )
                      : Text(
                          'Update Password',
                          style: textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      }),
    ),
  );
}
}