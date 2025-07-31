import 'package:edex_365_getx/features/authentication/bindings/auth_binding.dart';
import 'package:edex_365_getx/features/authentication/view/login_view.dart';
import 'package:edex_365_getx/features/authentication/view/registration_view.dart';
import 'package:edex_365_getx/features/home/home_part/student_home_screen.dart';
import 'package:edex_365_getx/features/home/home_part/teacher_home_screen.dart';
import 'package:edex_365_getx/features/home/splash_screen.dart';
import 'package:get/get.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegistrationScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.studentHome,
      page: () => const StudentHomeScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.teacherHome,
      page: () => const TeacherHomeScreen(),
      binding: AuthBinding(),
    ),
  ];
}
