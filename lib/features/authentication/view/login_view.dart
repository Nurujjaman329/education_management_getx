import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final mobileController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: mobileController, decoration: const InputDecoration(labelText: 'Mobile Number'),keyboardType: TextInputType.number,),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 16),
            Obx(() => controller.isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      await controller.login(mobileController.text, passwordController.text);
                      final type = controller.loginResponse.value?.type;
                      if (type == 'student') {
                        Get.offAllNamed('/student-home');
                      } else if (type == 'teacher') {
                        Get.offAllNamed('/teacher-home');
                      }
                    },
                    child: const Text('Login'),
                  )),
            TextButton(
              onPressed: () => Get.toNamed('/register'),
              child: const Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
