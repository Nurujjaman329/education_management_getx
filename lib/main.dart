import 'package:edex_365_getx/core/config/app_themes.dart';
import 'package:edex_365_getx/core/controllers/connectivity_controller.dart';
import 'package:edex_365_getx/core/controllers/theme_controller.dart';
import 'package:edex_365_getx/core/widgets/global_network_status.dart';
import 'package:edex_365_getx/features/authentication/controller/auth_controller.dart';
import 'package:edex_365_getx/features/shared_panel/controller/shared_controller.dart';
import 'package:edex_365_getx/routes/app_pages.dart';
import 'package:edex_365_getx/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  Get.put(ConnectivityController(), permanent: true);
  Get.put(SharedController());
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Education App',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeController.themeMode.value,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      builder: (context, child) {
        return GlobalNetworkStatus(child: child ?? const SizedBox());
      },
    );
  }
}
