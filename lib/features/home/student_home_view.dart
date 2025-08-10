import 'package:edex_365_getx/core/config/app_colors.dart';
import 'package:edex_365_getx/core/utils/back_press_utils.dart';
import 'package:edex_365_getx/features/authentication/controller/auth_controller.dart';
import 'package:edex_365_getx/features/shared_panel/controller/shared_controller.dart';
import 'package:edex_365_getx/features/student_panel/model/student_problem_list_response_model.dart';
import 'package:edex_365_getx/features/student_panel/view/student_pending_problem_list_view.dart';
import 'package:edex_365_getx/features/student_panel/view/student_problem_list_view.dart';
import 'package:edex_365_getx/features/student_panel/view/student_solved_problem_list_view.dart';
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
  final theme = Theme.of(context);
  return PopScope(
    onPopInvoked: (didpop) => BackPressHandler.handleWillPop(context),
    child: RefreshIndicator(
      onRefresh: () async {
        final userId = authController.loginResponse.value?.id ??
            authController.userId.value;
        if (userId.isNotEmpty) {
          await controller.fetchAll(userId);
        }
      },
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: TextStyle(
                color: theme.colorScheme.error,
                fontSize: 16,
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildWelcomeHeader(theme),
              const SizedBox(height: 20),
              _buildQuickStats(theme),
              const SizedBox(height: 24),
              _buildLearningProgress(theme),
              const SizedBox(height: 24),
              _buildChartsSection(theme),
              const SizedBox(height: 24),
              _buildRecentProblems(theme),
            ],
          ),
        );
      }),
    ),
  );
}



Widget _buildWelcomeHeader(ThemeData theme) {
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
            theme.colorScheme.primary.withOpacity(0.8),
            theme.colorScheme.secondary.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.2),
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
            child: Icon(
              Icons.school,
              size: 30,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello, ${user?.name ?? 'User'}!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Ready to solve some problems today?",
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onPrimary,
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

Widget _buildQuickStats(ThemeData theme) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Your Progress",
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
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
            theme: theme,
            title: "Total",
            value: controller.totalProblems.length.toString(),
            icon: Icons.assignment,
            color: theme.colorScheme.primary,
            progress: 1.0,
            onTap: () => Get.to(() => const StudentProblemListView(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 400),
            ),
          ),
          _buildStatItem(
            theme: theme,
            title: "Solved",
            value: controller.solvedProblems.length.toString(),
            icon: Icons.check_circle,
            color: theme.colorScheme.secondary,
            progress: controller.totalProblems.isNotEmpty
                ? controller.solvedProblems.length / controller.totalProblems.length
                : 0.0,
            onTap: () => Get.to(() => const StudentSolvedProblemListView(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 400),
            ),
          ),
          _buildStatItem(
            theme: theme,
            title: "Pending",
            value: controller.pendingProblems.length.toString(),
            icon: Icons.pending_actions,
            color: theme.colorScheme.tertiary ?? theme.colorScheme.primaryContainer,
            progress: controller.totalProblems.isNotEmpty
                ? controller.pendingProblems.length / controller.totalProblems.length
                : 0.0,
            onTap: () => Get.to(() => const StudentPendingProblemListView(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 400),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _buildStatItem({
  required ThemeData theme,
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
        color: theme.cardColor,
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
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    ),
  );
}

Widget _buildLearningProgress(ThemeData theme) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: theme.cardColor,
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
        Text(
          "Learning Progress",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(
          value: controller.totalProblems.isNotEmpty
              ? controller.solvedProblems.length / controller.totalProblems.length
              : 0.0,
          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
          color: theme.colorScheme.primary,
          minHeight: 12,
          borderRadius: BorderRadius.circular(6),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${controller.totalProblems.isNotEmpty ? (controller.solvedProblems.length / controller.totalProblems.length * 100).toStringAsFixed(1) : 0}% Completed",
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              "${controller.solvedProblems.length} of ${controller.totalProblems.length} problems solved",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildChartsSection(ThemeData theme) {
  final total = controller.totalProblems.length;
  final solved = controller.solvedProblems.length;
  final pending = controller.pendingProblems.length;
  final others = total - solved - pending;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Performance Analytics",
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 16),
      Card(
        color: theme.cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: theme.dividerColor.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Problem Distribution",
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: SfCircularChart(
                  palette: [
                    theme.colorScheme.secondary,
                    theme.colorScheme.tertiary ?? theme.colorScheme.primaryContainer,
                    theme.colorScheme.primary,
                  ],
                  legend: Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                    textStyle: theme.textTheme.bodySmall,
                    overflowMode: LegendItemOverflowMode.wrap,
                  ),
                  series: <CircularSeries>[
                    PieSeries<ChartData, String>(
                      dataSource: [
                        ChartData('Solved', solved, theme.colorScheme.secondary),
                        ChartData(
                          'Pending',
                          pending,
                          theme.colorScheme.tertiary ?? theme.colorScheme.primaryContainer,
                        ),
                        if (others > 0)
                          ChartData('Others', others, theme.colorScheme.primary),
                      ],
                      xValueMapper: (ChartData data, _) => data.category,
                      yValueMapper: (ChartData data, _) => data.value,
                      pointColorMapper: (ChartData data, _) => data.color,
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.inside,
                        textStyle: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontSize: 12,
                        ),
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


Widget _buildRecentProblems(ThemeData theme) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Recent Problems",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
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
                foregroundColor: theme.colorScheme.primary,
              ),
              child: const Text("View All"),
            ),
        ],
      ),
      const SizedBox(height: 12),
      if (controller.totalProblems.isEmpty)
        _buildEmptyState(theme)
      else
        ...controller.totalProblems.take(3).map((item) {
          return _buildProblemCard(item, theme);
        }),
    ],
  );
}

Widget _buildEmptyState(ThemeData theme) {
  return Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Center(
      child: Column(
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 48,
            color: theme.disabledColor,
          ),
          const SizedBox(height: 16),
          Text(
            "No problems submitted yet",
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            "Start by submitting your first problem",
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navigate to problem submission
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              "Submit Problem",
              style: TextStyle(color: theme.colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildProblemCard(StudentProblemListResponseModel problem, ThemeData theme) {
  final isSolved = controller.solvedProblems.contains(problem);
  final isPending = controller.pendingProblems.contains(problem);

  return Card(
    color: theme.cardColor,
    margin: const EdgeInsets.only(bottom: 16),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: theme.dividerColor.withOpacity(0.3),
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
                    ? (theme.colorScheme.tertiary ?? theme.colorScheme.primaryContainer)
                    : isSolved
                        ? theme.colorScheme.secondary
                        : theme.disabledColor,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    problem.subject,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    problem.topic,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    problem.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.disabledColor,
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
