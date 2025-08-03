import 'package:edex_365_getx/core/config/app_colors.dart';
import 'package:edex_365_getx/core/widgets/custom_curved_appbar.dart';
import 'package:edex_365_getx/features/shared_panel/model/user_details_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../shared_panel/controller/shared_controller.dart';

class UserInfoDetailsView extends StatelessWidget {
  const UserInfoDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Get.find<SharedController>().userDetailsList.firstOrNull;

    return Scaffold(
      appBar: const CustomCurvedAppBar(title: "User Profile"),
      backgroundColor: AppColors.background,
      body: user == null
          ? Center(
              child: Text(
                "No user data found",
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  // Profile Header with Image
                  _buildProfileHeader(user),
                  const SizedBox(height: 24),
                  
                  // User Information Card
                  Container(
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
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildInfoRow(label: 'Name', value: user.name),
                        const Divider(height: 24),
                        _buildInfoRow(label: 'Email', value: user.email),
                        const Divider(height: 24),
                        _buildInfoRow(label: 'Mobile', value: user.mobileNo),
                        if (user.dob != null) ...[
                          const Divider(height: 24),
                          _buildInfoRow(
                            label: 'Date of Birth', 
                            value: DateFormat('dd MMM yyyy').format(user.dob!)
                          ),
                        ],
                        if (user.school.isNotEmpty) ...[
                          const Divider(height: 24),
                          _buildInfoRow(label: 'School', value: user.school),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader(UserDetailsResponseModel user) {
    return Column(
      children: [
        // Profile Image with Hero animation
        Hero(
          tag: 'user-profile-image-',
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
                width: 3,
              ),
            ),
            child: ClipOval(
              child: user.image.isNotEmpty
                  ? Image.network(
                      user.image,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => _buildDefaultAvatar(),
                    )
                  : _buildDefaultAvatar(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        if (user.email.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: AppColors.primary.withOpacity(0.1),
      child: Center(
        child: Icon(
          Icons.person,
          size: 48,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildInfoRow({required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
