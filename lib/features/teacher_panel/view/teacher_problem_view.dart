import 'package:edex_365_getx/features/authentication/controller/auth_controller.dart';
import 'package:edex_365_getx/features/home/student_home_view.dart';
import 'package:edex_365_getx/features/shared_panel/controller/shared_controller.dart';
import 'package:edex_365_getx/features/teacher_panel/controller/teacher_problem_controller.dart';
import 'package:edex_365_getx/features/teacher_panel/model/teacher_problem_get_model.dart';
import 'package:edex_365_getx/features/teacher_panel/service/teacher_problem_service.dart';
import 'package:edex_365_getx/features/teacher_panel/view/teacher_accepted_problem_list.dart';
import 'package:edex_365_getx/features/teacher_panel/view/teacher_problem_list.dart';
import 'package:edex_365_getx/features/teacher_panel/view/teacher_solved_problem_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class TeacherProblemView extends StatefulWidget {
  const TeacherProblemView({super.key});

  @override
  State<TeacherProblemView> createState() => _TeacherProblemViewState();
}

class _TeacherProblemViewState extends State<TeacherProblemView> {
  final TeacherProblemController problemController =
      Get.put(TeacherProblemController(TeacherProblemService()));
  final AuthController authController = Get.find<AuthController>();
  final SharedController sharedController = Get.find<SharedController>();
  late Worker _userIdWorker;

  @override
  void initState() {
    super.initState();
    _userIdWorker = ever<String>(authController.userId, (id) {
      if (id.isNotEmpty) {
        problemController.fetchTeacherProblems(id);
        problemController.fetchAcceptedProblems(id);
        problemController.fetchAllSolutionList(id);
      }
    });
    final userId =
        authController.loginResponse.value?.id ?? authController.userId.value;
    if (userId.isNotEmpty) {
      problemController.fetchTeacherProblems(userId);
      problemController.fetchAcceptedProblems(userId);
      problemController.fetchAllSolutionList(userId);
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
    return RefreshIndicator(
      onRefresh: () async {
        final userId = authController.loginResponse.value?.id ??
            authController.userId.value;
        if (userId.isNotEmpty) {
          await problemController.fetchTeacherProblems(userId);
          await problemController.fetchAcceptedProblems(userId);
          await problemController.fetchAllSolutionList(userId);
        }
      },
      child: Obx(() {
        if (problemController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: theme.colorScheme.primary),
          );
        }

        if (problemController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Text(
              problemController.errorMessage.value,
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
              _buildChartsSection(theme),
              const SizedBox(height: 24),
              _buildProblemList(theme),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildWelcomeHeader(ThemeData theme) {
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
                    "Hello, ${user?.name ?? 'Teacher'}!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Here's your problem dashboard",
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
    final total = problemController.totalProblems.length;
    final accepted = problemController.acceptedProblems.length;
    final solved = problemController.solvedProblems.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Problem Overview",
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
              value: total.toString(),
              icon: Icons.assignment,
              color: theme.colorScheme.primary,
              progress: 1.0,
              onTap: () => Get.to(() => const TeacherProblemList(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 400),
            ),
            
            ),
            _buildStatItem(
              theme: theme,
              title: "Accepted",
              value: accepted.toString(),
              icon: Icons.check_circle,
              color: theme.colorScheme.secondary,
              progress: total > 0 ? accepted / total : 0.0,
                 onTap: () => Get.to(() => const TeacherAcceptedProblemList(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 400),
                 )
            ),
            _buildStatItem(
              theme: theme,
              title: "Solved",
              value: solved.toString(),
              icon: Icons.done_all,
              color: theme.colorScheme.tertiary,
              progress: total > 0 ? solved / total : 0.0,
                     onTap: () => Get.to(() => const TeacherSolvedProblemList(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 400),
                 )
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

  Widget _buildChartsSection(ThemeData theme) {
    final total = problemController.totalProblems.length;
    final accepted = problemController.acceptedProblems.length;
    final solved = problemController.solvedProblems.length;

    // Prepare subject distribution data from total problems
    final subjectCounts = <String, int>{};
    for (var problem in problemController.totalProblems) {
      subjectCounts[problem.subject] =
          (subjectCounts[problem.subject] ?? 0) + 1;
    }

    // Prepare class distribution data from total problems
    final classCounts = <String, int>{};
    for (var problem in problemController.totalProblems) {
      classCounts[problem.sClass] = (classCounts[problem.sClass] ?? 0) + 1;
    }

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
        
        // Problem Status Chart
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
                  "Problem Status",
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
                      theme.colorScheme.tertiary,
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
                          ChartData('Accepted', accepted, theme.colorScheme.secondary),
                          ChartData('Solved', solved, theme.colorScheme.tertiary),
                          ChartData('Pending', total - accepted, theme.colorScheme.primary),
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
        const SizedBox(height: 16),
        
        // Subject Distribution Chart
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
                  "Subject Distribution",
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: SfCartesianChart(
                    palette: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                      theme.colorScheme.tertiary,
                    ],
                    primaryXAxis: CategoryAxis(
                      labelStyle: theme.textTheme.bodySmall,
                    ),
                    primaryYAxis: NumericAxis(
                      labelStyle: theme.textTheme.bodySmall,
                    ),
                    series: <CartesianSeries>[
                      ColumnSeries<MapEntry<String, int>, String>(
                        dataSource: subjectCounts.entries.toList(),
                        xValueMapper: (entry, _) => entry.key,
                        yValueMapper: (entry, _) => entry.value,
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          textStyle: theme.textTheme.bodySmall,
                        ),
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Class Distribution Chart
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
                  "Class Distribution",
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: SfCartesianChart(
                    palette: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                      theme.colorScheme.tertiary,
                    ],
                    primaryXAxis: CategoryAxis(
                      labelStyle: theme.textTheme.bodySmall,
                    ),
                    primaryYAxis: NumericAxis(
                      labelStyle: theme.textTheme.bodySmall,
                    ),
                    series: <CartesianSeries>[
                      BarSeries<MapEntry<String, int>, String>(
                        dataSource: classCounts.entries.toList(),
                        xValueMapper: (entry, _) => entry.key,
                        yValueMapper: (entry, _) => entry.value,
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          textStyle: theme.textTheme.bodySmall,
                        ),
                        color: theme.colorScheme.secondary,
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

  Widget _buildProblemList(ThemeData theme) {
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
            if (problemController.totalProblems.length > 3)
              TextButton(
                onPressed: () {
                  // View all problems
                },
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                ),
                child: const Text("View All"),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (problemController.totalProblems.isEmpty)
          _buildEmptyState(theme)
        else
          ...problemController.totalProblems.take(3).map((problem) {
            final isAccepted = problemController.acceptedProblems
                .any((accepted) => accepted.id == problem.id);
            final isSolved = problemController.solvedProblems
                .any((solved) => solved.id == problem.id);
                
            return _buildProblemCard(problem, theme, isAccepted, isSolved);
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
              "Students haven't submitted any problems yet",
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProblemCard(TeacherProblemGetModel problem, ThemeData theme, 
      bool isAccepted, bool isSolved) {
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
          if (!isAccepted) {
            _showAcceptDialog(problem.id);
          }
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
                  color: isSolved
                      ? theme.colorScheme.tertiary
                      : isAccepted
                          ? theme.colorScheme.secondary
                          : theme.colorScheme.error,
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
                      "Class: ${problem.sClass}",
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
                isSolved
                    ? Icons.done_all
                    : isAccepted
                        ? Icons.check_circle
                        : Icons.pending,
                color: isSolved
                    ? theme.colorScheme.tertiary
                    : isAccepted
                        ? theme.colorScheme.secondary
                        : theme.colorScheme.error,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAcceptDialog(String postId) {
    final theme = Theme.of(context);
    
    Get.defaultDialog(
      title: 'Accept Problem',
      titleStyle: theme.textTheme.titleMedium,
      content: Text(
        'Do you want to accept this problem?',
        style: theme.textTheme.bodyMedium,
      ),
      backgroundColor: theme.cardColor,
      contentPadding: const EdgeInsets.all(20),
      titlePadding: const EdgeInsets.only(top: 20),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.error,
          ),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Get.back();
            try {
              if (authController.userId.value.isNotEmpty) {
                await problemController.acceptProblem(
                    authController.userId.value, postId);
                Get.snackbar(
                  'Success',
                  'Problem accepted successfully',
                  backgroundColor: theme.colorScheme.secondary,
                  colorText: theme.colorScheme.onSecondary,
                );
                // Refresh the lists after accepting
                await problemController.fetchAcceptedProblems(authController.userId.value);
              }
            } catch (e) {
              Get.snackbar(
                'Error',
                e.toString(),
                backgroundColor: theme.colorScheme.error,
                colorText: theme.colorScheme.onError,
              );
            }
          },
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
          ),
          child: const Text('Accept'),
        ),
      ],
    );
  }
}
