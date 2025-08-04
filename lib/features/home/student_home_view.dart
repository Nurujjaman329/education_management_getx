import 'package:edex_365_getx/core/config/app_colors.dart';
import 'package:edex_365_getx/features/authentication/controller/auth_controller.dart';
import 'package:edex_365_getx/features/shared_panel/controller/shared_controller.dart';
import 'package:edex_365_getx/features/student_panel/model/student_problem_list_response_model.dart';
import 'package:edex_365_getx/features/student_panel/view/student_problem_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edex_365_getx/features/student_panel/controller/student_problem_list_controller.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class StudentHomeView extends StatefulWidget {
  const StudentHomeView({super.key});

  @override
  State<StudentHomeView> createState() => _StudentHomeViewState();
}

class _StudentHomeViewState extends State<StudentHomeView> {
  final StudentProblemListController controller =
      Get.find<StudentProblemListController>();
  final AuthController authController = Get.find<AuthController>();
  late Worker _userIdWorker;

  @override
  void initState() {
    super.initState();
    _userIdWorker = ever<String>(authController.userId, (id) {
      if (id.isNotEmpty) {
        controller.fetchAll(id);
      }
    });
    final userId =
        authController.loginResponse.value?.id ?? authController.userId.value;
    if (userId.isNotEmpty) {
      controller.fetchAll(userId);
    }
  }

  @override
  void dispose() {
    _userIdWorker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final userId = authController.loginResponse.value?.id ??
            authController.userId.value;
        if (userId.isNotEmpty) {
          await controller.fetchAll(userId);
        }
      },
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 16,
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Enhanced Welcome Header with user name
              _buildWelcomeHeader(),
              const SizedBox(height: 20),

              // Quick Stats with improved layout
              _buildQuickStats(),
              const SizedBox(height: 24),

              // Learning Progress Section
              _buildLearningProgress(),
              const SizedBox(height: 24),

              // Charts Section with better visualization
              _buildChartsSection(),
              const SizedBox(height: 24),

              // Recent Problems with improved cards
              _buildRecentProblems(),
            ],
          ),
        );
      }),
    );
  }

Widget _buildWelcomeHeader() {
  final sharedController = Get.find<SharedController>();

  return Obx(() {
    final user = sharedController.userDetailsList.firstOrNull;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.8),
            AppColors.secondary.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school,
              size: 30,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello, ${user?.name ?? 'User'}!",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Ready to solve some problems today?",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  });
}


  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Your Progress",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
          children: [
            _buildStatItem(
              title: "Total",
              value: controller.totalProblems.length.toString(),
              icon: Icons.assignment,
              color: AppColors.primary,
              progress: 1.0,
              onTap: () => Get.to(() => const StudentProblemListView(),
              transition: Transition.rightToLeft, // 👈 Animation type
              duration: const Duration(milliseconds: 400), // 👈 Optional custom duration
              ),
              
            ),
            _buildStatItem(
              title: "Solved",
              value: controller.solvedProblems.length.toString(),
              icon: Icons.check_circle,
              color: AppColors.success,
              progress: controller.totalProblems.isNotEmpty
                  ? controller.solvedProblems.length / controller.totalProblems.length
                  : 0.0,
            ),
            _buildStatItem(
              title: "Pending",
              value: controller.pendingProblems.length.toString(),
              icon: Icons.pending_actions,
              color: AppColors.secondary,
              progress: controller.totalProblems.isNotEmpty
                  ? controller.pendingProblems.length / controller.totalProblems.length
                  : 0.0,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required double progress,
     VoidCallback? onTap,
  }) {
    return GestureDetector(
        onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    value: progress,
                    backgroundColor: color.withOpacity(0.1),
                    color: color,
                    strokeWidth: 6,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLearningProgress() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Learning Progress",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: controller.totalProblems.isNotEmpty
                ? controller.solvedProblems.length / controller.totalProblems.length
                : 0.0,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            color: AppColors.primary,
            minHeight: 12,
            borderRadius: BorderRadius.circular(6),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${controller.totalProblems.isNotEmpty ? (controller.solvedProblems.length / controller.totalProblems.length * 100).toStringAsFixed(1) : 0}% Completed",
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                "${controller.solvedProblems.length} of ${controller.totalProblems.length} problems solved",
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    final total = controller.totalProblems.length;
    final solved = controller.solvedProblems.length;
    final pending = controller.pendingProblems.length;
    final others = total - solved - pending;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Performance Analytics",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: AppColors.surface, 
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: AppColors.divider.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Problem Distribution",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: SfCircularChart(
                    palette: const [
                      AppColors.success,
                      AppColors.secondary,
                      AppColors.primary,
                    ],
                    legend: const Legend(
                      isVisible: true,
                      position: LegendPosition.bottom,
                      textStyle: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                      overflowMode: LegendItemOverflowMode.wrap,
                    ),
                    series: <CircularSeries>[
                      PieSeries<ChartData, String>(
                        dataSource: [
                          ChartData('Solved', solved, AppColors.success),
                          ChartData('Pending', pending, AppColors.secondary),
                          if (others > 0)
                            ChartData('Others', others, AppColors.primary),
                        ],
                        xValueMapper: (ChartData data, _) => data.category,
                        yValueMapper: (ChartData data, _) => data.value,
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          labelPosition: ChartDataLabelPosition.inside,
                          textStyle: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        enableTooltip: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentProblems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Recent Problems",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            if (controller.totalProblems.length > 3)
              TextButton(
                onPressed: () {
                  Get.to(() => const StudentProblemListView(),
                  transition: Transition.downToUp,
                  duration: const Duration(milliseconds: 400)
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                ),
                child: const Text("View All"),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (controller.totalProblems.isEmpty)
          _buildEmptyState()
        else
          ...controller.totalProblems.take(3).map((item) {
            return _buildProblemCard(item);
          }),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 48,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              "No problems submitted yet",
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Start by submitting your first problem",
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to problem submission
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                "Submit Problem",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProblemCard(StudentProblemListResponseModel problem) {
    final isSolved = controller.solvedProblems.contains(problem);
    final isPending = controller.pendingProblems.contains(problem);

    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.divider.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Handle problem tap
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: isPending
                      ? AppColors.secondary
                      : isSolved
                          ? AppColors.success
                          : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      problem.subject,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      problem.topic,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      problem.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  final String category;
  final int value;
  final Color color;

  ChartData(this.category, this.value, this.color);
}
