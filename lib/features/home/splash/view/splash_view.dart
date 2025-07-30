import 'package:edex_365_getx/core/config/app_colors.dart';
import 'package:edex_365_getx/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';


class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // Show splash for 2s

    final token = await _secureStorage.read(key: 'auth_token');
    final role = await _secureStorage.read(key: 'user_type'); // 👈 store this at login

    if (token != null && token.isNotEmpty) {
      // Navigate by user role
      if (role?.toLowerCase() == 'teacher') {
        Get.offAllNamed(AppRoutes.teacherHome);
      } else if (role?.toLowerCase() == 'student') {
        Get.offAllNamed(AppRoutes.studentHome);
      } else {
        Get.offAllNamed(AppRoutes.login); // fallback
      }
    } else {
      Get.offAllNamed(AppRoutes.login); // not logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'EduSmart',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Learning. Simplified.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

