import 'package:edex_365_getx/core/config/app_colors.dart';
import 'package:edex_365_getx/features/authentication/controller/auth_controller.dart';
import 'package:edex_365_getx/features/shared_panel/controller/shared_controller.dart';
import 'package:edex_365_getx/features/shared_panel/view/edit_profile_view.dart';
import 'package:edex_365_getx/features/shared_panel/view/update_password_form.dart';
import 'package:edex_365_getx/features/shared_panel/view/user_info_details_view.dart';
import 'package:edex_365_getx/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final sharedController = Get.find<SharedController>();
    final userId = Get.find<AuthController>().userId.value;

    if (sharedController.userDetailsList.isEmpty &&
        !sharedController.isLoading.value) {
      sharedController.fetchUserDetails(userId);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Profile Section
          Obx(() {
            if (sharedController.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (sharedController.error.value != null) {
              return Center(
                child: Text(
                  sharedController.error.value!,
                  style: const TextStyle(color: AppColors.error, fontSize: 16),
                ),
              );
            }

            final user = sharedController.userDetailsList.firstOrNull;

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.person, size: 30, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'User',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? 'email@example.com',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                 IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.primary),
                    onPressed: () {
                      Get.to(
                        () => const EditProfileView(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 32),

          // Account Settings Section
          const Text(
            'Account Settings',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                _buildSettingsItem(
                  icon: Icons.person_outline,
                  title: 'User Info',

                    onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            const UserInfoDetailsView(),
                        transitionsBuilder: (_, animation, __, child) {
                          const begin = Offset(1.0, 0.0); // Start from right
                          const end = Offset.zero; // End at center
                          const curve = Curves.easeInOut;

                          final tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          final offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },

          
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _buildSettingsItem(
                  icon: Icons.lock_outline,
                  title: 'Change Password',
                  onTap: () {
                    final userId = Get.find<AuthController>().userId.value;
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            UpdatePasswordForm(userId: userId),
                        transitionsBuilder: (_, animation, __, child) {
                          const begin = Offset(1.0, 0.0); // Start from right
                          const end = Offset.zero; // End at center
                          const curve = Curves.easeInOut;

                          final tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          final offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _buildSettingsItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notification Settings'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // App Settings Section
          const Text(
            'App Settings',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                _buildSettingsItem(
                  icon: Icons.color_lens_outlined,
                  title: 'App Theme',
                  onTap: () {
                    // Optional: navigate to theme settings or show dialog
                  },
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _buildSettingsItem(
                    icon: Icons.help_outline, title: 'Help & Support'),
              ],
            ),
          ),
          const SizedBox(height: 32),

        SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close dialog
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog first
                Get.find<AuthController>().logout();
                Get.offAllNamed(AppRoutes.login);
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.error.withOpacity(0.1),
      foregroundColor: AppColors.error,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
    ),
    child: const Text(
      'Logout',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(color: AppColors.textPrimary)),
      trailing: trailing ??
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
