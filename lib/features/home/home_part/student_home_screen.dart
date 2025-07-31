import 'package:edex_365_getx/features/authentication/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      body: const Center(child: Text('👨‍🎓 Welcome Student!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          authController.logout();
        },
        tooltip: 'Logout',
        child: const Icon(Icons.logout),
      ),
    );
  }
}

