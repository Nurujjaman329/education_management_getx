import 'package:edex_365_getx/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userType = prefs.getString('userType');

if (token != null && token.isNotEmpty) {
  if (userType?.toLowerCase() == 'student') {
    Get.offAllNamed(AppRoutes.studentHome);
  } else if (userType?.toLowerCase() == 'teacher') {
    Get.offAllNamed(AppRoutes.teacherHome);
  } else {
    Get.offAllNamed(AppRoutes.login);
  }
} else {
  Get.offAllNamed(AppRoutes.login);
}


  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
