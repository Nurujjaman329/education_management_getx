import 'package:edex_365_getx/features/authentication/login/login_binding.dart';
import 'package:edex_365_getx/features/authentication/login/view/login_view.dart';
import 'package:edex_365_getx/features/authentication/registration/registration_binding.dart';
import 'package:edex_365_getx/features/authentication/registration/view/registration_view.dart';
import 'package:get/get.dart';

abstract class AppPages {
  static final List<GetPage> routes = [
    GetPage(
      name: Routes.login,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.registration,
      page: () => RegistrationView(),
      binding: RegistrationBinding(),
    ),
  ];
}

abstract class Routes {
  static const login = '/login';
  static const registration = '/registration';
}