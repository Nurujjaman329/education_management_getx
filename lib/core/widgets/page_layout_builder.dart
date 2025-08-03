  // onTap: () {
  //                   final userId = Get.find<AuthController>().userId.value;
  //                   Navigator.of(context).push(
  //                     PageRouteBuilder(
  //                       pageBuilder: (_, __, ___) =>
  //                           UpdatePasswordForm(userId: userId),
  //                       transitionsBuilder: (_, animation, __, child) {
  //                         const begin = Offset(1.0, 0.0); // Start from right
  //                         const end = Offset.zero; // End at center
  //                         const curve = Curves.easeInOut;

  //                         final tween = Tween(begin: begin, end: end)
  //                             .chain(CurveTween(curve: curve));
  //                         final offsetAnimation = animation.drive(tween);

  //                         return SlideTransition(
  //                           position: offsetAnimation,
  //                           child: child,
  //                         );
  //                       },
  //                     ),
  //                   );
  //                 },