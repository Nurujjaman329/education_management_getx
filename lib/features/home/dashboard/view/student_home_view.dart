// import 'package:edex_365_getx/core/config/app_colors.dart';
// import 'package:edex_365_getx/features/home/dashboard/controller/student_home_controller.dart';
// import 'package:edex_365_getx/features/home/dashboard/widgets/problem_card.dart';
// import 'package:edex_365_getx/features/home/dashboard/widgets/problem_statistics_chart.dart';
// import 'package:edex_365_getx/routes/app_routes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';


// class StudentHomeView extends GetView<StudentHomeController> {
//   final PageController _pageController = PageController();

//   StudentHomeView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: AppColors.background,
//         drawer: _buildDrawer(context),
//         body: PageView(
//           controller: _pageController,
//           onPageChanged: controller.changeTabIndex,
//           children: [
//             _buildHomeBody(context),
//             // ProblemPostView(),
//             // ProfileView(),
//           ],
//         ),
//         bottomNavigationBar: _buildBottomNavBar(),
//       ),
//     );
//   }

//   Widget _buildDrawer(BuildContext context) {
//     return Obx(() => Drawer(
//       child: Column(
//         children: [
//           Expanded(
//             flex: 2,
//             child: DrawerHeader(
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage("assets/images/drawer.jpg"),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.black.withOpacity(0.6),
//                       Colors.transparent,
//                     ],
//                     begin: Alignment.bottomCenter,
//                     end: Alignment.topCenter,
//                   ),
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(20),
//                     bottomRight: Radius.circular(20),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 16.0, bottom: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       // Profile Image
//                       controller.userDetails.isNotEmpty &&
//                           controller.userDetails[0].image.isNotEmpty
//                           ? ClipOval(
//                               child: Image.network(
//                                 controller.userDetails[0].image,
//                                 width: 70,
//                                 height: 70,
//                                 fit: BoxFit.cover,
//                               ),
//                             )
//                           : CircleAvatar(
//                               radius: 35,
//                               backgroundColor: Colors.grey[300],
//                               child: Icon(
//                                 Icons.person,
//                                 size: 40,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                       const SizedBox(height: 12),
//                       // User Name
//                       Text(
//                         controller.auth.value?.name ?? "Not Logged In",
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       // User Email
//                       Text(
//                         controller.auth.value?.email ?? "Not Logged In",
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.9),
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Column(
//               children: [
//                 ListTile(
//                   leading: const Icon(Icons.payment, color: AppColors.primary),
//                   title: const Text("Recharge Amount"),
//                   onTap: () {
//                     // Get.toNamed(
//                     //   AppRoutes.checkout,
//                     //   arguments: {
//                     //     'userId': controller.auth.value!.id,
//                     //     'userName': controller.auth.value!.name,
//                     //   },
//                     // );
//                   },
//                 ),
//                 const Divider(),
//                 ListTile(
//                   leading: const Icon(Icons.support_agent, color: AppColors.primary),
//                   title: const Text("Contact HO"),
//                   onTap: () {},
//                 ),
//                 const Divider(),
//                 ListTile(
//                   leading: const Icon(Icons.logout, color: Colors.redAccent),
//                   title: const Text("Log Out"),
//                   onTap: controller.logout,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ));
//   }

//   Widget _buildHomeBody(BuildContext context) {
//     return RefreshIndicator(
//       color: AppColors.background,
//       backgroundColor: AppColors.primary,
//       onRefresh: () => controller.fetchAllData(controller.auth.value!.id),
//       child: CustomScrollView(
//         slivers: <Widget>[
//           SliverAppBar(
//             iconTheme:  IconThemeData(
//               color: AppColors.background,
//             ),
//             backgroundColor: Colors.transparent,
//             expandedHeight: 200.0,
//             floating: false,
//             pinned: true,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Image.asset(
//                 'assets/images/book.png',
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Obx(() => Column(
//                 children: [
//                   ProblemStatisticsChart(
//                     totalProblems: controller.totalProblems.length,
//                     pendingProblems: controller.pendingProblems.length,
//                     solvedProblems: controller.solvedProblems.length,
//                   ),
//                   const SizedBox(height: 20),
//                   GridView.count(
//                     crossAxisCount: 3,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     crossAxisSpacing: 16,
//                     mainAxisSpacing: 16,
//                     children: [
//                       ProblemCard(
//                         title: 'Total Problems',
//                         count: controller.totalProblems.length.toString(),
//                         icon: Icons.assignment,
//                         color: Colors.blue,
//                       //  onTap: () => Get.toNamed(AppRoutes.studentProblemList),
//                       ),
//                       ProblemCard(
//                         title: 'Pending Problems',
//                         count: controller.pendingProblems.length.toString(),
//                         icon: Icons.pending_actions,
//                         color: Colors.orange,
//                        // onTap: () => Get.toNamed(AppRoutes.pendingProblemList),
//                       ),
//                       ProblemCard(
//                         title: 'Solved Problems',
//                         count: controller.solvedProblems.length.toString(),
//                         icon: Icons.check_circle,
//                         color: Colors.green,
//                        // onTap: () => Get.toNamed(AppRoutes.solvedProblemList),
//                       ),
//                     ],
//                   ),
//                 ],
//               )),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomNavBar() {
//     return Obx(() => CurvedNavigationBar(
//       index: controller.selectedIndex.value,
//       onTap: (index) {
//         controller.changeTabIndex(index);
//         _pageController.jumpToPage(index);
//       },
//       backgroundColor: AppColors.background,
//       color: AppColors.primary,
//       buttonBackgroundColor: AppColors.primary,
//       items: const [
//         Icon(Icons.home, color: AppColors.background),
//         Icon(Icons.add, color: AppColors.background),
//         Icon(Icons.person, color: AppColors.background),
//       ],
//     ));
//   }

//   Future<bool> _onWillPop() async {
//     DateTime now = DateTime.now();
//     DateTime? currentBackPressTime;
    
//     if (currentBackPressTime == null ||
//         now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
//       currentBackPressTime = now;
//       Get.snackbar('Info', 'Press Back Again to Exit.');
//       return false;
//     }
//     return true;
//   }
// }