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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: const CustomCurvedAppBar(title: "User Profile"),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: user == null
          ? Center(
              child: Text(
                "No user data found",
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  // Profile Header with Image
                  _buildProfileHeader(user, theme),
                  const SizedBox(height: 24),
                  
                  // User Information Card
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
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
                        _buildInfoRow(
                          label: 'Name', 
                          value: user.name,
                          theme: theme,
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          label: 'Email', 
                          value: user.email,
                          theme: theme,
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          label: 'Mobile', 
                          value: user.mobileNo,
                          theme: theme,
                        ),
                        if (user.dob != null) ...[
                          const Divider(height: 24),
                          _buildInfoRow(
                            label: 'Date of Birth', 
                            value: DateFormat('dd MMM yyyy').format(user.dob!),
                            theme: theme,
                          ),
                        ],
                        if (user.school.isNotEmpty) ...[
                          const Divider(height: 24),
                          _buildInfoRow(
                            label: 'School', 
                            value: user.school,
                            theme: theme,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader(UserDetailsResponseModel user, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      children: [
        // Profile Image with Hero animation
        Hero(
          tag: 'user-profile-image',
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.primary.withOpacity(0.2),
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
                            color: colorScheme.primary,
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => _buildDefaultAvatar(theme),
                    )
                  : _buildDefaultAvatar(theme),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (user.email.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            user.email,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDefaultAvatar(ThemeData theme) {
    return Container(
      color: theme.colorScheme.primary.withOpacity(0.1),
      child: Center(
        child: Icon(
          Icons.person,
          size: 48,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String label, 
    required String value,
    required ThemeData theme,
  }) {
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
