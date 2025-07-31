import 'package:edex_365_getx/routes/app_pages.dart';
import 'package:edex_365_getx/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


void main() {
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
    );
  }
}
