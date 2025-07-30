import 'package:edex_365_getx/core/config/app_colors.dart';
import 'package:edex_365_getx/features/authentication/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              // Navigate to edit profile
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // User Profile Section
            _buildProfileHeader(),
            const SizedBox(height: 32),
            
            // Account Balance Card
            _buildBalanceCard(),
            const SizedBox(height: 24),
            
            // Profile Options
            _buildProfileOptions(),
            const SizedBox(height: 24),
            
            // Logout Button
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Container(
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
            child: Image.network(
              'https://randomuser.me/api/portraits/men/1.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.person,
                size: 60,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'John Doe',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'john.doe@example.com',
          style: TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

Widget _buildBalanceCard() {
  return Container(
    width: double.infinity, // 👈 Ensures full width
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: AppColors.primary.withOpacity(0.08),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: AppColors.primary.withOpacity(0.15),
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withOpacity(0.05),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.account_balance_wallet_outlined,
            size: 36, color: AppColors.primary),
        SizedBox(height: 12),
        Text(
          'Account Balance',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 10),
        Text(
          '\$245.50',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    ),
  );
}




  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        backgroundColor: AppColors.primary.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildProfileOptions() {
    return Column(
      children: [
        _ProfileOptionTile(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Account Details',
          onTap: () {},
        ),
        const Divider(height: 1),
        _ProfileOptionTile(
          icon: Icons.lock_outline,
          title: 'Update Password',
          onTap: () {},
        ),
        const Divider(height: 1),
        _ProfileOptionTile(
          icon: Icons.history_outlined,
          title: 'Transaction History',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          _showLogoutConfirmation(context);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.error),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Logout'),
      ),
    );
  }

void _showLogoutConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Get.find<AuthController>().logout(); // ✅ Perform logout and redirect
          },
          child: const Text(
            'Logout',
            style: TextStyle(color: AppColors.error),
          ),
        ),
      ],
    ),
  );
}

}

class _ProfileOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileOptionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textSecondary,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    );
  }
}