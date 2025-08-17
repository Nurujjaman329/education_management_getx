import 'package:edex_365_getx/features/authentication/controller/auth_controller.dart';
import 'package:edex_365_getx/features/home/student_home_view.dart';
import 'package:edex_365_getx/features/shared_panel/view/settings_content.dart';
import 'package:edex_365_getx/features/student_panel/view/problem_post_view.dart';
import 'package:edex_365_getx/features/student_panel/view/transaction_history_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  final authController = Get.find<AuthController>();
  int _selectedIndex = 0;

  final List<String> _titles = [
    '', // No title for Home
    'Post Your Problem',
    'Wallet',
    'Settings',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Or use context.theme from GetX

    final List<Widget> pages = [
      const StudentHomeView(),
      ProblemPostView(),
      TransactionHistoryView(userId: authController.userId.value),
      const SettingsContent(),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _selectedIndex != 0
          ? AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: theme.colorScheme.primary,
              elevation: 0,
              centerTitle: true,
              title: Text(
                _titles[_selectedIndex],
                style: TextStyle(
                  color: theme.scaffoldBackgroundColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
            )
          : null,
      body: SafeArea(child: pages[_selectedIndex]),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.disabledColor,
        backgroundColor: theme.colorScheme.surface,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.edit_note), label: 'Post'),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Wallet'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
