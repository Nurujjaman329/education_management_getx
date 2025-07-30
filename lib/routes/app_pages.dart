import 'package:edex_365_getx/features/authentication/login/login_binding.dart';
import 'package:edex_365_getx/features/authentication/login/view/login_view.dart';
import 'package:edex_365_getx/features/authentication/registration/registration_binding.dart';
import 'package:edex_365_getx/features/authentication/registration/view/registration_view.dart';
import 'package:edex_365_getx/features/home/dashboard/dashboard_binding.dart';
import 'package:edex_365_getx/features/home/dashboard/view/student_home_screen.dart';
import 'package:edex_365_getx/features/home/dashboard/view/teacher_home_screen.dart';
import 'package:edex_365_getx/features/home/splash/view/splash_view.dart';
import 'package:edex_365_getx/features/student_panel/transaction_history/transaction_history_binding.dart';
import 'package:edex_365_getx/features/student_panel/transaction_history/view/transaction_history_view.dart';
import 'package:edex_365_getx/routes/app_routes.dart';
import 'package:get/get.dart';

abstract class AppPages {
  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.registration,
      page: () => RegistrationView(),
      binding: RegistrationBinding(),
    ),
    GetPage(
      name: Routes.transactionHistory,
      page: () => TransactionHistoryView(),
      binding: StudentTransactionHistoryBinding(),
    ),
    GetPage(name: Routes.studentHome, page: () => const StudentHomeScreen(),binding: StudentHomeBinding(),),
    GetPage(name: Routes.teacherHome, page: () => const TeacherHomeScreen()),
  ];
}

abstract class Routes {
  static const login = '/login';
  static const registration = '/registration';
  static const transactionHistory = '/transaction-history';
  static const home = '/home';
  static const studentHome = '/student/home';
  static const teacherHome = '/teacher/home';
}
