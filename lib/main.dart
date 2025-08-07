import 'package:edex_365_getx/core/controllers/connectivity_controller.dart';
import 'package:edex_365_getx/core/widgets/global_network_status.dart';
import 'package:edex_365_getx/routes/app_pages.dart';
import 'package:edex_365_getx/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


void main() {
  Get.put(ConnectivityController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Education App',
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      builder: (context, child) {
        return GlobalNetworkStatus(child: child ?? const SizedBox());
      },
    );
  }
}
