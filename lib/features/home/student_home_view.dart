import 'package:edex_365_getx/core/config/app_colors.dart';
import 'package:edex_365_getx/features/authentication/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edex_365_getx/features/student_panel/controller/student_problem_list_controller.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class StudentHomeView extends StatefulWidget {
  StudentHomeView({super.key});

  @override
  State<StudentHomeView> createState() => _StudentHomeViewState();
}

class _StudentHomeViewState extends State<StudentHomeView> {
  final StudentProblemListController controller = Get.find<StudentProblemListController>();
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
    final userId = authController.loginResponse.value?.id ?? authController.userId.value;
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
        final userId = authController.loginResponse.value?.id ?? authController.userId.value;
        if (userId.isNotEmpty) {
          await controller.fetchAll(userId);
        }
      },
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Dashboard Header
              _buildDashboardHeader(),
              const SizedBox(height: 20),
              
              // Stats Cards Row
              _buildStatsCards(),
              const SizedBox(height: 20),
              
              // Pie Chart
              _buildPieChart(),
              const SizedBox(height: 20),
              
              // Bar Chart
              _buildBarChart(),
              const SizedBox(height: 20),
              
              // Recent Problems Section
              _buildRecentProblemsSection(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDashboardHeader() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Problem Dashboard",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Overview of your problem requests",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: const Icon(Icons.person, color: Colors.blue),
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildStatCard(
            title: "Total Problems",
            value: controller.totalProblems.length.toString(),
            color: Colors.blue,
            icon: Icons.library_books,
          ),
          const SizedBox(width: 10),
          _buildStatCard(
            title: "Pending",
            value: controller.pendingProblems.length.toString(),
            color: Colors.orange,
            icon: Icons.pending_actions,
          ),
          const SizedBox(width: 10),
          _buildStatCard(
            title: "Solved",
            value: controller.solvedProblems.length.toString(),
            color: Colors.green,
            icon: Icons.check_circle,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return SizedBox(
      width: 150,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 18, color: color),
                  ),
                  const Spacer(),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    final total = controller.totalProblems.length;
    final solved = controller.solvedProblems.length;
    final pending = controller.pendingProblems.length;
    final others = total - solved - pending;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Problems Distribution",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: SfCircularChart(
                legend: Legend(
                  isVisible: true,
                  overflowMode: LegendItemOverflowMode.wrap,
                  position: LegendPosition.bottom,
                ),
                series: <CircularSeries>[
                  PieSeries<ChartData, String>(
                    dataSource: [
                      ChartData('Solved', solved, Colors.green),
                      ChartData('Pending', pending, Colors.orange),
                      if (others > 0) ChartData('Others', others, Colors.blue),
                    ],
                    xValueMapper: (ChartData data, _) => data.category,
                    yValueMapper: (ChartData data, _) => data.value,
                    pointColorMapper: (ChartData data, _) => data.color,
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
    );
  }

  Widget _buildBarChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Problems Overview",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: SfCartesianChart(
  primaryXAxis: CategoryAxis(),
  primaryYAxis: NumericAxis(
    minimum: 0,
    maximum: controller.totalProblems.length.toDouble() + 2,
    interval: 1,
  ),
  tooltipBehavior: TooltipBehavior(enable: true),
  series: <CartesianSeries<ChartData, String>>[
    ColumnSeries<ChartData, String>(
      dataSource: [
        ChartData('Total', controller.totalProblems.length, Colors.blue),
        ChartData('Solved', controller.solvedProblems.length, Colors.green),
        ChartData('Pending', controller.pendingProblems.length, Colors.orange),
      ],
      xValueMapper: (ChartData data, _) => data.category,
      yValueMapper: (ChartData data, _) => data.value,
      color: Colors.blue,
      pointColorMapper: (ChartData data, _) => data.color,
      dataLabelSettings: const DataLabelSettings(
        isVisible: true,
        labelAlignment: ChartDataLabelAlignment.top,
      ),
    ),
  ],
),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentProblemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recent Problems",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (controller.totalProblems.isEmpty)
          const Center(child: Text("No problems found"))
        else
          ...controller.totalProblems.take(3).map((item) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildStatusIndicator(item),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.subject,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text("Topic: ${item.topic}"),
                    Text("Class: ${item.sClass}"),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        if (controller.totalProblems.length > 3)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text("View All Problems"),
            ),
          ),
      ],
    );
  }

  Widget _buildStatusIndicator(dynamic item) {
    final isPending = controller.pendingProblems.contains(item);
    final isSolved = controller.solvedProblems.contains(item);
    
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: isSolved ? Colors.green : isPending ? Colors.orange : Colors.grey,
        shape: BoxShape.circle,
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