import 'package:edex_365_getx/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Edex App',
      debugShowCheckedModeBanner: false,
      navigatorKey: Get.key, // Add this line to fix GlobalKey issue
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes, // Changed from appPages to AppPages.routes
    );
  }
}
